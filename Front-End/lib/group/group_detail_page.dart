import 'package:LearnPro/tutoring_system/custom_button.dart';
import 'package:LearnPro/tutoring_system/group_notification_icon_with_badge.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:LearnPro/Screens/pdf_viewer_page.dart';
import 'package:LearnPro/group/comment_section.dart';
import 'package:LearnPro/group/content_upload_form.dart';
import 'package:LearnPro/group/send_group_invites.dart';
import 'group_content_request_page.dart';

class GroupDetailPage extends StatelessWidget {
  final String groupName;

  const GroupDetailPage({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(groupName),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(groupName)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                var groupData = snapshot.data!.data() as Map<String, dynamic>;
                var currentUser = FirebaseAuth.instance.currentUser;

                if (currentUser!.uid == groupData['owner']) {
                  return IconButton(
                    icon: GroupNotificationIconWithBadge(
                      groupName: groupData['groupname'],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GroupContentRequestsPage(groupName: groupName),
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('groups')
              .doc(groupName)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var groupData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                CachedNetworkImage(
                  imageUrl: groupData['groupicon'],
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        groupData['groupname'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text('Members: ${groupData['members'].length}'),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(groupData['groupdescription']),
                      ),
                    ],
                  ),
                ),
                const TabBar(
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: "Content"),
                    Tab(text: "Members"),
                  ],
                ),
                SizedBox(
                  height: 500,
                  child: TabBarView(
                    children: [
                      ContentTab(groupName: groupName),
                      MembersTab(
                        groupName: groupName,
                        owner: groupData['owner'],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ContentTab extends StatelessWidget {
  final String groupName;

  const ContentTab({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('groups').doc(groupName).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var groupData = snapshot.data!.data() as Map<String, dynamic>;
        var owner = groupData['owner'];

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContentUploadForm(groupName: groupName),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('groups')
                .doc(groupName)
                .collection('groupcontents')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var currentUser = FirebaseAuth.instance.currentUser;
              var contents = snapshot.data!.docs;

              return ListView(
                children: contents.map((doc) {
                  var contentData = doc.data() as Map<String, dynamic>;
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(contentData['postedby'])
                        .get(),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var userData =
                          userSnapshot.data!.data() as Map<String, dynamic>;
                      return ContentCard(
                        groupName: groupName,
                        contentId: doc.id,
                        contentData: contentData,
                        username: userData['userName'],
                        profilePic: userData['profilePic'],
                        isOwnerOrPoster:
                            currentUser!.uid == contentData['postedby'] ||
                                currentUser.uid == owner,
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }
}

class ContentCard extends StatefulWidget {
  final String groupName;
  final String contentId;
  final Map<String, dynamic> contentData;
  final String username;
  final String profilePic;
  final bool isOwnerOrPoster;

  const ContentCard({
    super.key,
    required this.groupName,
    required this.contentId,
    required this.contentData,
    required this.username,
    required this.profilePic,
    required this.isOwnerOrPoster,
  });

  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool isLiked = false;
  int likeCount = 0;
  int _commentCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeLikeState();
    _fetchCommentCount();
  }

  void _initializeLikeState() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final likes = widget.contentData['likes'] as Map<String, dynamic>? ?? {};
    setState(() {
      isLiked = likes[currentUser.uid] == true;
      likeCount = likes.values.where((value) => value == true).length;
    });
  }

  void toggleLike() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final contentRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupName)
        .collection('groupcontents')
        .doc(widget.contentId);

    setState(() {
      if (isLiked) {
        likeCount--;
      } else {
        likeCount++;
      }
      isLiked = !isLiked;
    });

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(contentRef);
      if (!snapshot.exists) {
        return;
      }

      final likes = (snapshot.data()?['likes'] as Map<String, dynamic>? ?? {});
      likes[currentUser.uid] = isLiked;

      transaction.update(contentRef, {'likes': likes});
    });
  }

//comment count method
  void _fetchCommentCount() async {
    final contentSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupName)
        .collection('groupcontents')
        .doc(widget.contentId)
        .get();

    final contentData = contentSnapshot.data() as Map<String, dynamic>;
    final comments = contentData['comments'] as Map<String, dynamic>? ?? {};
    setState(() {
      _commentCount = comments.length;
    });
  }

  //newcode start
  void _showEditDialog() {
    TextEditingController titleController =
        TextEditingController(text: widget.contentData['contentTitle']);
    TextEditingController descriptionController =
        TextEditingController(text: widget.contentData['contentDescription']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('groups')
                    .doc(widget.groupName)
                    .collection('groupcontents')
                    .doc(widget.contentId)
                    .update({
                  'contentTitle': titleController.text,
                  'contentDescription': descriptionController.text,
                });

                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
  //newcode

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseFirestore.instance
                    .collection('groups')
                    .doc(widget.groupName)
                    .collection('groupcontents')
                    .doc(widget.contentId)
                    .delete();

                // Delete files from Firestore Storage
                final storageRef = FirebaseStorage.instance.ref().child(
                    'groups/${widget.groupName}/content/${widget.contentId}');
                await storageRef.listAll().then((result) {
                  for (var fileRef in result.items) {
                    fileRef.delete();
                  }
                });
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      CachedNetworkImageProvider(widget.profilePic),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(widget.username),
                ),
                if (widget.isOwnerOrPoster)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditDialog();
                      } else if (value == 'remove') {
                        _showDeleteDialog();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text('Remove'),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(widget.contentData['contentTitle'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(widget.contentData['contentDescription']),
            const SizedBox(height: 10),
            widget.contentData['filetype'] == 'images'
                ? _buildImageSlider(widget.contentData['contentfiles'])
                : _buildPdfList(widget.contentData['contentfiles'], context),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(isLiked
                          ? Icons.thumb_up
                          : Icons.thumb_up_off_alt_outlined),
                      onPressed: toggleLike,
                    ),
                    const SizedBox(width: 5),
                    Text('$likeCount likes'),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentSection(
                                      groupName: widget.groupName,
                                      contentId: widget.contentId,
                                    )),
                          ).then((_) =>
                              _fetchCommentCount()); // Fetch comment count after returning
                        },
                        child: const Icon(Icons.comment)),
                    const SizedBox(width: 5),
                    Text('$_commentCount comments'),
                  ],
                ),
              ],
            ),
          ],
        ),
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

  Widget _buildPdfList(
      Map<String, dynamic> contentFiles, BuildContext context) {
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

class MembersTab extends StatelessWidget {
  final String groupName;
  final String owner;

  const MembersTab({super.key, required this.groupName, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('groups')
                .doc(groupName)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var groupData = snapshot.data!.data() as Map<String, dynamic>;
              var members = List<String>.from(groupData['members']);

              return ListView(
                children: members.map((uid) {
                  return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .snapshots(),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var userData =
                          userSnapshot.data!.data() as Map<String, dynamic>;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              userData['profilePic']),
                        ),
                        title: Text(userData['userName']),
                        trailing: owner != uid
                            // FirebaseAuth.instance.currentUser!.uid
                            ? FirebaseAuth.instance.currentUser!.uid == owner
                                ? PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'view') {
                                        // Handle view action
                                      } else if (value == 'remove') {
                                        _showRemoveDialog(
                                            context, uid, userData['userName']);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'view',
                                        child: Text('View'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'remove',
                                        child: Text('Remove'),
                                      ),
                                    ],
                                  )
                                : null
                            : const Text("owner"),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
        if (FirebaseAuth.instance.currentUser!.uid == owner)
          CustomButton(
            text: "Invite",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SendGroupInvites(groupName: groupName)),
              );
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            borderColor: Theme.of(context).colorScheme.secondary,
          ),
        // Padding(
        //   padding: const EdgeInsets.all(20.0),
        //   child: ElevatedButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) =>
        //                 SendGroupInvites(groupName: groupName)),
        //       );
        //     },
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: const Color(0xFF29F6D2),
        //       foregroundColor:
        //           Colors.black, // Use foregroundColor for text color
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10.0),
        //       ),
        //       textStyle: const TextStyle(
        //         fontSize: 25.0,
        //         fontFamily: 'Work Sans',
        //         fontWeight: FontWeight.w500,
        //       ),
        //       minimumSize: const Size(150.0, 50.0), // Set width and height
        //       padding: EdgeInsets.zero, // Remove default padding
        //     ),
        //     child: const Text('Invite'),
        //   ),
        // ),
        if (FirebaseAuth.instance.currentUser!.uid != owner)
          CustomButton(
              text: "Leave",
              onPressed: () {
                _showLeaveDialog(context);
              },
              backgroundColor: Colors.redAccent.shade700),
//
        // Padding(
        //   padding: const EdgeInsets.all(20.0),
        //   child: ElevatedButton(
        //     onPressed: () {
        //       _showLeaveDialog(context);
        //     },
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: const Color(0xFF29F6D2),
        //       foregroundColor:
        //           Colors.black, // Use foregroundColor for text color
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10.0),
        //       ),
        //       textStyle: const TextStyle(
        //         fontSize: 25.0,
        //         fontFamily: 'Work Sans',
        //         fontWeight: FontWeight.w500,
        //       ),
        //       minimumSize: const Size(150.0, 50.0), // Set width and height
        //       padding: EdgeInsets.zero, // Remove default padding
        //     ),
        //     child: const Text('Leave'),
        //   ),
        // )
      ],
    );
  }

  void _showRemoveDialog(BuildContext context, String uid, String username) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Member'),
          content:
              Text('Are you sure you want to remove $username from the group?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                // Remove user from group
                await FirebaseFirestore.instance
                    .collection('groups')
                    .doc(groupName)
                    .update({
                  'members': FieldValue.arrayRemove([uid])
                });

                // Remove group from user's joined groups
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({
                  'joinedgroups': FieldValue.arrayRemove([groupName])
                });

                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showLeaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave Group'),
          content: const Text('Are you sure you want to leave this group?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser == null) return;

                // Remove current user from group
                await FirebaseFirestore.instance
                    .collection('groups')
                    .doc(groupName)
                    .update({
                  'members': FieldValue.arrayRemove([currentUser.uid])
                });

                // Remove group from user's joined groups
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .update({
                  'joinedgroups': FieldValue.arrayRemove([groupName])
                });

                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
