import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'custom_button.dart';
import 'rejected_msg_view.dart';

class RejectedMsgsScreen extends StatefulWidget {
  const RejectedMsgsScreen({super.key});

  @override
  _RejectedMsgsScreenState createState() => _RejectedMsgsScreenState();
}

class _RejectedMsgsScreenState extends State<RejectedMsgsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> _streamRejectedMsgs() {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No user logged in");
    }

    String uid = currentUser.uid;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('rejectedMsgs')
        .orderBy('sentTime', descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<Map<String, dynamic>> rejectedMsgs = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        if (data['read'] == false) {
          rejectedMsgs.insert(
              0, data); // Insert unread messages at the beginning
        } else {
          rejectedMsgs.add(data); // Append read messages at the end
        }
      }
      return rejectedMsgs;
    });
  }

  Future<void> _markAsReadAndNavigate(String docId, String msgId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user logged in");
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RejectedMsgView(msgID: msgId),
        ),
      );
      String uid = currentUser.uid;
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('rejectedMsgs')
          .doc(docId)
          .update({'read': true});
    } catch (e) {
      // Handle error appropriately
      print('Error marking as read and navigating: $e');
    }
  }

  Future<void> _deleteMsg(String docId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user logged in");
      }
      String uid = currentUser.uid;
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('rejectedMsgs')
          .doc(docId)
          .delete();
    } catch (e) {
      // Handle error appropriately
      print('Error deleting message: $e');
    }
  }

  void _showDeleteConfirmationDialog(String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Message'),
          content: Text('Are you sure you want to delete this message?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteMsg(docId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Notifications'),
      // ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _streamRejectedMsgs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            if (snapshot.error.toString().contains('Failed to get documents')) {
              return const Center(
                child: Text('Connect to internet'),
              );
            }
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No notifications'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var msg = snapshot.data![index];
                return FutureBuilder<DocumentSnapshot>(
                  future: _firestore
                      .collection('users')
                      .doc(msg['teacherId'])
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: const CircularProgressIndicator(),
                        ),
                        title: const Text('Loading...'),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                        ),
                        title: const Text('Error loading teacher info'),
                      );
                    } else {
                      var teacherData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onLongPress: () {
                            _showDeleteConfirmationDialog(msg['msgId']);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.7),
                              border: Border(
                                left: BorderSide(
                                  color: msg['read'] == false
                                      ? Colors.green
                                      : Colors.transparent,
                                  width: 10.0,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                            // margin: EdgeInsets.all(8.0),
                            // shape: RoundedRectangleBorder(
                            //   // side: BorderSide(
                            //   //   color: msg['read'] == false
                            //   //       ? Colors.green
                            //   //       : Colors.transparent,
                            //   //   width: 4.0,
                            //   // ),
                            //   borderRadius: BorderRadius.circular(4.0),
                            // ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            teacherData['profilePic']),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: Text(
                                          '${teacherData['userName']} isn’t available to teach you',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  const Text('Request details'),
                                  Text(
                                      '📚 ${msg['lesson']} (${msg['subject']})'),
                                  Text(
                                      '📅 on ${msg['date']} (${msg['startTime']} to ${msg['endTime']})'),
                                  const SizedBox(height: 8.0),
                                  Center(
                                    child: SizedBox(
                                      height: 30,
                                      child: CustomButton(
                                        text: "View",
                                        onPressed: () {
                                          _markAsReadAndNavigate(
                                              msg['msgId'], msg['msgId']);
                                        },
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),

                                    // child: ElevatedButton(
                                    //   onPressed: () {
                                    //     _markAsReadAndNavigate(
                                    //         msg['msgId'], msg['msgId']);
                                    //   },
                                    //   child: Text('View'),
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
