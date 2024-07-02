import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'arrange_meeting_form.dart';
import 'custom_button.dart';
import 'defined_colors.dart';
import 'reject_message_form.dart';

class TutorRequestNotifications extends StatefulWidget {
  const TutorRequestNotifications({super.key});

  @override
  _TutorRequestNotificationsState createState() =>
      _TutorRequestNotificationsState();
}

class _TutorRequestNotificationsState extends State<TutorRequestNotifications> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentUid;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _getCurrentUserUid();
  }

  Future<void> _getCurrentUserUid() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        setState(() {
          currentUid = user.uid;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
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
          .collection('tuitionRequests')
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
          title: const Text('Delete Message'),
          content: const Text('Are you sure you want to delete this message?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
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
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white54
        : Colors.black45;
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: const Center(child: Text('Connect to internet.')),
      );
    }

    return Scaffold(
      // appBar: AppBar(title: Text('Notifications')),
      body: currentUid == null
          ? const Center(child: Text('No notifications'))
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(currentUid)
                  .collection('tuitionRequests')
                  .orderBy('sentTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong.'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No notifications'));
                }

                var requests = snapshot.data!.docs;

                // Categorize and sort requests
                List<DocumentSnapshot> readRequests = [];
                List<DocumentSnapshot> unreadRequests = [];
                for (var request in requests) {
                  var data = request.data() as Map<String, dynamic>;
                  if (data['read'] == true) {
                    readRequests.add(request);
                  } else {
                    unreadRequests.add(request);
                  }
                }

                List<DocumentSnapshot> sortedRequests = [
                  ...unreadRequests,
                  ...readRequests
                ];

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                    itemCount: sortedRequests.length,
                    itemBuilder: (context, index) {
                      var request = sortedRequests[index];
                      return _buildRequestItem(request);
                    },
                  ),
                );
              },
            ),
    );
  }

  Widget _buildRequestItem(DocumentSnapshot request) {
    var data = request.data() as Map<String, dynamic>;
    String senderUid = data['senderStudent'];
    String subject = data['subject'];
    String lesson = data['lesson'];
    String date = data['date'];
    String timeStart = data['timeStart'];
    String timeEnd = data['timeEnd'];
    bool isRead = data['read'];
    String status = data['status'];
    String reqId = data['reqid'];

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(senderUid).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userSnapshot.hasError) {
          return const Center(child: Text('Something went wrong.'));
        }

        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return const Center(child: Text('User not found.'));
        }

        var userData = userSnapshot.data!.data() as Map<String, dynamic>;
        String senderName = userData['userName'];
        String senderProfilePic = userData['profilePic'];

        return GestureDetector(
          onLongPress: () {
            _showDeleteConfirmationDialog(reqId);
          },
          child: Card(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(senderProfilePic),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text('$senderName has requested for tuition',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Request Details',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  // Text('Subject: $subject'),
                  Row(
                    children: [
                      const Icon(Icons.book),
                      Expanded(child: Text(' $lesson($subject)')),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.date_range),
                      Text(' Date: $date'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timelapse_outlined),
                      Text(' Between $timeStart and $timeEnd'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!isRead) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ElevatedButton(
                        //   onPressed: () => _navigateToArrangeMeeting(reqId),
                        //   child: Text('Accept'),
                        // ),
                        CustomButton(
                            text: "Reject",
                            onPressed: () => _navigateToRejectMessage(reqId),
                            backgroundColor: rejectButtonColor),

                        CustomButton(
                          text: "Accept",
                          onPressed: () => _navigateToArrangeMeeting(reqId),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),

                        // ElevatedButton(
                        //   onPressed: () => _navigateToRejectMessage(reqId),
                        //   child: Text('Reject'),
                        // ),
                      ],
                    ),
                  ],
                  if (isRead && status == 'accepted')
                    Center(
                        child: Text('You have accepted the request',
                            style: TextStyle(color: Colors.grey.shade800))),
                  if (isRead && status == 'rejected')
                    const Center(
                        child: Text(
                      'You have rejected the request',
                      style: TextStyle(color: Colors.red),
                    )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToArrangeMeeting(String reqId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArrangeMeetingForm(
          requestID: reqId,
        ),
      ),
    );
  }

  void _navigateToRejectMessage(String reqId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RejectMessageForm(
          requestID: reqId,
        ),
      ),
    );
  }
}
