import 'package:LearnPro/tutoring_system/custom_appbar.dart';
import 'package:LearnPro/tutoring_system/custom_button.dart';
import 'package:LearnPro/tutoring_system/defined_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:LearnPro/Screens/pdf_viewer_page.dart';

class GroupContentRequestsPage extends StatefulWidget {
  final String groupName;

  const GroupContentRequestsPage({super.key, required this.groupName});

  @override
  _GroupContentRequestsPageState createState() =>
      _GroupContentRequestsPageState();
}

class _GroupContentRequestsPageState extends State<GroupContentRequestsPage> {
  late String currentUserId;
  bool isLoading = true;
  bool isOwner = false;

  @override
  void initState() {
    super.initState();
    _checkOwnership();
  }

  Future<void> _checkOwnership() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      DocumentSnapshot groupDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupName)
          .get();

      if (groupDoc.exists && groupDoc['owner'] == currentUserId) {
        setState(() {
          isOwner = true;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _handleAccept(
      String contentId, Map<String, dynamic> contentData) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupName)
          .collection('groupcontents')
          .doc(contentId)
          .set(contentData);

      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupName)
          .collection('contentrequests')
          .doc(contentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('you have accepted the request the request'),
        ),
      );
      setState(() {});
    } catch (e) {
      print('Error accepting content: $e');
    }
  }

  Future<void> _handleReject(String contentId) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final folderRef =
          storageRef.child('groups/${widget.groupName}/content/$contentId');

      // List all files in the folder and delete them
      ListResult result = await folderRef.listAll();
      for (Reference fileRef in result.items) {
        await fileRef.delete();
      }

      // Delete the Firestore document
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupName)
          .collection('contentrequests')
          .doc(contentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('you have rejected the request'),
        ),
      );
      setState(() {});
    } catch (e) {
      print('Error rejecting content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Content Requests'),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!isOwner) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Content Requests'),
        ),
        body: const Center(
          child: Text("You don't have access to this page"),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Content Requests'),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupName)
            .collection('contentrequests')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No content requests'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> contentData =
                  doc.data() as Map<String, dynamic>;
              String postedBy = contentData['postedby'];
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(postedBy)
                    .get(),
                builder:
                    (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  String username = userData['userName'];
                  String profilePic = userData['profilePic'];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    CachedNetworkImageProvider(profilePic),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '$username has requested to post this on ${widget.groupName}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(contentData['contentTitle'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(contentData['contentDescription']),
                          const SizedBox(height: 10),
                          contentData['filetype'] == 'images'
                              ? _buildImageSlider(contentData['contentfiles'])
                              : _buildPdfList(contentData['contentfiles']),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                  text: "Reject",
                                  onPressed: () => () async {
                                        await _handleReject(doc.id);
                                        setState(() {
                                          // Update state to reflect changes
                                        });
                                      },
                                  backgroundColor: rejectButtonColor),

                              CustomButton(
                                text: "Accept",
                                onPressed: () async {
                                  await _handleAccept(doc.id, contentData);
                                  setState(() {
                                    // Update state to reflect changes
                                  });
                                },
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                              ),
                              // ElevatedButton(
                              //   onPressed: () async {
                              //     await _handleAccept(doc.id, contentData);
                              //     setState(() {
                              //       // Update state to reflect changes
                              //     });
                              //   },
                              //   child: const Text('Accept'),
                              // ),
                              // ElevatedButton(
                              //   onPressed: () async {
                              //     await _handleReject(doc.id);
                              //     setState(() {
                              //       // Update state to reflect changes
                              //     });
                              //   },
                              //   child: const Text('Reject'),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildImageSlider(Map<String, dynamic> contentFiles) {
    List<Widget> imageWidgets = contentFiles.entries.map((entry) {
      return Image.network(entry.value);
    }).toList();

    return SizedBox(
      height: 200,
      child: PageView(
        children: imageWidgets,
      ),
    );
  }

  Widget _buildPdfList(Map<String, dynamic> contentFiles) {
    return Column(
      children: contentFiles.entries.map((entry) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewerPage(pdflink: entry.value),
              ),
            );
          },
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf),
              const SizedBox(width: 10),
              Text(entry.key),
            ],
          ),
        );
      }).toList(),
    );
  }
}
