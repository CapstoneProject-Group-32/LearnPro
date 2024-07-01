import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_button.dart';

class ConfirmMsgView extends StatefulWidget {
  final String msgID;
  const ConfirmMsgView({Key? key, required this.msgID}) : super(key: key);

  @override
  _ConfirmMsgViewState createState() => _ConfirmMsgViewState();
}

class _ConfirmMsgViewState extends State<ConfirmMsgView> {
  late FirebaseFirestore firestore;
  late FirebaseAuth auth;
  DocumentSnapshot<Map<String, dynamic>>? messageDoc;
  DocumentSnapshot<Map<String, dynamic>>? studentDoc;
  DocumentSnapshot<Map<String, dynamic>>? currentUserDoc;
  bool isLoading = true;
  bool cancelButtonVisible = false;
  String? stdId;
  String? profilePic;
  String? stdName;
  String? message;
  String? link;
  String? time;
  String? date;
  String? currentUserName;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    auth = FirebaseAuth.instance;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Fetch the confirmMsg document
      messageDoc = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('confirmMsgs')
          .doc(widget.msgID)
          .get();

      if (messageDoc != null && messageDoc!.exists) {
        print("Confirm message data: ${messageDoc!.data()}");

        setState(() {
          stdId = messageDoc!['StdId'];
          cancelButtonVisible = messageDoc!['cancelBtn'];
          message = messageDoc!['msg'];
          link = messageDoc!['link'];
          time = messageDoc!['time'];
          date = messageDoc!['date'];
        });

        // Fetch the student document
        studentDoc = await firestore.collection('users').doc(stdId).get();

        if (studentDoc != null && studentDoc!.exists) {
          print("Student data: ${studentDoc!.data()}");

          setState(() {
            profilePic = studentDoc!['profilePic'];
            stdName = studentDoc!['userName'];
          });
        } else {
          showError("Student document not found.");
        }

        // Fetch the current user document
        currentUserDoc = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get();

        if (currentUserDoc != null && currentUserDoc!.exists) {
          print("Current user data: ${currentUserDoc!.data()}");

          setState(() {
            currentUserName = currentUserDoc!['userName'];
            isLoading = false;
          });
        } else {
          showError("Current user document not found.");
        }
      } else {
        showError("Message document not found.");
      }
    } catch (e) {
      showError(e.toString());
    }
  }

  void showError(String error) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Colors.red,
    ));
  }

  Future<void> cancelMeeting() async {
    try {
      WriteBatch batch = firestore.batch();
      DocumentReference studentLearningRec = firestore
          .collection('users')
          .doc(stdId)
          .collection('learningRecs')
          .doc(widget.msgID);
      DocumentReference studentArrangedMeetings = firestore
          .collection('users')
          .doc(stdId)
          .collection('arrangedMeetings')
          .doc(widget.msgID);
      DocumentReference userTeachingRec = firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('teachingRecs')
          .doc(widget.msgID);
      DocumentReference confirmMsg = firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('confirmMsgs')
          .doc(widget.msgID);

      batch.update(studentLearningRec, {'tchAvblt': false});
      batch.update(studentArrangedMeetings, {'status': 'cancelled'});
      batch.update(userTeachingRec, {'tchAvblt': false});
      batch.update(confirmMsg, {'cancelBtn': false});

      await batch.commit();

      Navigator.pop(context);
    } catch (e) {
      showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Confirm Message")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    String formattedMessage = """
Hi ${currentUserName ?? ''},
Time and date work perfectly for me! Thank you so much for setting up the meeting. I'm available at ${date ?? ''} at ${time ?? ''} for our online tutoring session. That works perfectly for me! I'll be sure to join the meeting on time.
${message ?? ''}
""";

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Message")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        profilePic != null ? NetworkImage(profilePic!) : null,
                    child: profilePic == null ? const Icon(Icons.person) : null,
                  ),
                  const SizedBox(width: 8),
                  Text(stdName ?? '', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    formattedMessage,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "The link is provided to make convenience for you to log in to the meeting:"),
              ),
              GestureDetector(
                onTap: () => _launchURL(link ?? ''),
                child: Text(
                  link ?? '',
                  style: const TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: "Open Link",
                    onPressed: () => _launchURL(link ?? ''),
                    backgroundColor: Colors.blue,
                  ),
                  // ElevatedButton(
                  //   onPressed: () => _launchURL(link ?? ''),
                  //   child: Text("Open Link"),
                  // ),
                  CustomButton(
                    text: "Copy link",
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: link ?? ''));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Link copied to clipboard")),
                      );
                    },
                    backgroundColor: Colors.blue,
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Clipboard.setData(ClipboardData(text: link ?? ''));
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text("Link copied to clipboard")),
                  //     );
                  //   },
                  //   child: Text("Copy Link"),
                  // ),
                ],
              ),
              const SizedBox(height: 16),
              // const Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Text(
              //     "You can use this button to cancel the meeting. Canceling a meeting can be disruptive, so please use this button only if absolutely necessary due to unforeseen circumstances. It will be inconvenient for your student.",
              //     style: TextStyle(fontWeight: FontWeight.bold),
              //   ),
              // ),
              if (!cancelButtonVisible)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "You have cancelled this meeting",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              if (cancelButtonVisible)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "You can use this button to cancel the meeting. Canceling a meeting can be disruptive, so please use this button only if absolutely necessary due to unforeseen circumstances. It will be inconvenient for your student.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              if (cancelButtonVisible)
                Center(
                  child: CustomButton(
                    text: "Cancel Meeting",
                    onPressed: () async {
                      bool confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Cancel Meeting"),
                          content: const Text(
                              "Are you sure that you want to cancel?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Yes"),
                            ),
                          ],
                        ),
                      );

                      if (confirm) {
                        await cancelMeeting();
                      }
                    },
                    backgroundColor: Colors.red,
                  ),
                ),
              // ElevatedButton(
              //   onPressed: () async {
              //     bool confirm = await showDialog(
              //       context: context,
              //       builder: (context) => AlertDialog(
              //         title: Text("Cancel Meeting"),
              //         content: Text("Are you sure that you want to cancel?"),
              //         actions: [
              //           TextButton(
              //             onPressed: () => Navigator.pop(context, false),
              //             child: Text("No"),
              //           ),
              //           TextButton(
              //             onPressed: () => Navigator.pop(context, true),
              //             child: Text("Yes"),
              //           ),
              //         ],
              //       ),
              //     );

              //     if (confirm) {
              //       await cancelMeeting();
              //     }
              //   },
              //   child: Text("Cancel Meeting"),
              // ),

              const SizedBox(height: 16),
              // Center(
              //   child: CustomButton(
              //     onPressed: () => Navigator.pop(context),
              //     text: "Back",
              //     backgroundColor: Theme.of(context).colorScheme.surface,
              //     borderColor: Theme.of(context).colorScheme.secondary,
              //     foregroundColor: Theme.of(context).colorScheme.secondary,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      showError("Could not launch URL");
    }
  }
}
