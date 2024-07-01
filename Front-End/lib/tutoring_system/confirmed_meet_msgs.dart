import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'confirm_msg_view.dart';
import 'custom_button.dart';

class ConfirmedMsgsScreen extends StatefulWidget {
  const ConfirmedMsgsScreen({super.key});

  @override
  _ConfirmedMsgsScreenState createState() => _ConfirmedMsgsScreenState();
}

class _ConfirmedMsgsScreenState extends State<ConfirmedMsgsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> _streamConfirmMsgs() {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No user logged in");
    }

    String uid = currentUser.uid;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('confirmMsgs')
        .orderBy('sessionTime', descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<Map<String, dynamic>> confirmMsgs = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        if (data['read'] == false) {
          confirmMsgs.insert(
              0, data); // Insert unread messages at the beginning
        } else {
          confirmMsgs.add(data); // Append read messages at the end
        }
      }
      return confirmMsgs;
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
          builder: (context) => ConfirmMsgView(
            msgID: msgId,
          ),
        ),
      );
      String uid = currentUser.uid;
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('confirmMsgs')
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
          .collection('confirmMsgs')
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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _streamConfirmMsgs(),
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
                  future:
                      _firestore.collection('users').doc(msg['StdId']).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("");
                      // return ListTile(
                      //   leading: CircleAvatar(
                      //     backgroundColor: Colors.grey[300],
                      //     child: const CircularProgressIndicator(),
                      //   ),
                      //   title: const Text('Loading...'),
                      // );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                        ),
                        title: const Text('Error loading student info'),
                      );
                    } else {
                      var studentData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onLongPress: () {
                            _showDeleteConfirmationDialog(msg['msgID']);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              // color:
                              //     Theme.of(context).colorScheme.onPrimaryFixed,
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            studentData['profilePic']),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: Text(
                                          '${studentData['userName']} will join your the meeting',
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
                                  Text('📅 on ${msg['date']} (${msg['time']})'),
                                  const SizedBox(height: 8.0),
                                  Center(
                                    child: SizedBox(
                                      height: 30,
                                      child: CustomButton(
                                        text: "View",
                                        onPressed: () {
                                          _markAsReadAndNavigate(
                                              msg['msgID'], msg['msgID']);
                                        },
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
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
