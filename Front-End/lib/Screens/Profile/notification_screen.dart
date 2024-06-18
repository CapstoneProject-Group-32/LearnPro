import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Screens/Community/schedule_meeting.dart';
import 'package:url_launcher/url_launcher.dart';

import 'user_profile.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getDownloadURL(String folderName) async {
    String uid = _auth.currentUser!.uid;
    Reference ref = _storage.ref().child(folderName).child(uid);
    return await ref.getDownloadURL();
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();

  Future<void> _deleteNotification(
      String requestId, String senderUid, String senderName) async {
    try {
      final userSnapshot =
          await _firestore.collection('users').doc(currentUser.uid).get();
      final userName = userSnapshot.data()?['userName'] ?? 'User';

      // Delete the notification from the current user's received requests
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('receivedTuitionRequests')
          .doc(requestId)
          .delete();

      // Send a rejection notification to the sender
      await _firestore
          .collection('users')
          .doc(senderUid)
          .collection('rejectedRequests')
          .add({
        'message': '$userName rejected your request',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request rejected and sender notified')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject request: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog(
      String requestId, String senderUid, String senderName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to reject this request?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteNotification(requestId, senderUid,
                    senderName); // Delete the notification
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteNotificationlink(
      String receivedId, String receiverUid, String receiverName) async {
    try {
      final userSnapshot =
          await _firestore.collection('users').doc(currentUser.uid).get();
      final userName = userSnapshot.data()?['userName'] ?? 'User';

      // Delete the notification from the current user's received requests
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('AcceptedRequests')
          .doc(receivedId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link Deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject request: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialogForlink(
      String receivedId, String receiverUid, String receiverName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
              'Do you copy that given link ? Because there are no chance to get back that link agin after delete the notification ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteNotificationlink(receivedId, receiverUid,
                    receiverName); // Delete the notification
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<String> _getProfilePicUrl() async {
    return await _storageMethods.getDownloadURL('profilePictures');
  }

  Future<String> _getCurrentUserName() async {
    final snapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return snapshot.data()?['userName'] ?? 'User';
  }

  Future<void> _deleteRejectedNotification(String notificationId) async {
    try {
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('rejectedRequests')
          .doc(notificationId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rejected request notification deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete notification: $e')),
      );
    }
  }

  void _navigateToAcceptRequest(String senderUid, String requestId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AcceptRequest(senderUid: senderUid, requestId: requestId),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      throw 'Error launching URL: $e';
    }
  }

//dialog box for copy link

  void _showLinkDialog(BuildContext context, String link) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Link',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  await _launchURL(link);
                },
                child: Text(
                  link,
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: link));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copied to clipboard')),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy Link'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Notification list
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.uid)
                      .collection('receivedTuitionRequests')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final requests = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request =
                            requests[index].data() as Map<String, dynamic>;
                        final requestId = requests[index].id;
                        final senderName = request['senderName'];
                        final subject = request['subject'];
                        final lesson = request['lesson'];
                        final date = request['date'];
                        final time = request['time'];
                        final senderUid = request['sender'];
                        final senderProfilePic = request['senderProfilePic'];

                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            width: 380,
                            height: 140,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: ShapeDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x190043CE),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                senderProfilePic.isNotEmpty
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18),
                                        child: SizedBox(
                                          height: 85,
                                          width: 85,
                                          child: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(senderProfilePic),
                                          ),
                                        ),
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.only(left: 18),
                                        child: SizedBox(
                                          height: 85,
                                          width: 85,
                                          child: CircleAvatar(
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                      ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$senderName Requested for tutoring',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontFamily: 'Work Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          width: 208,
                                          child: Text(
                                            'Subject: $subject',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: 'Work Sans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 208,
                                          child: Text(
                                            'Lesson: $lesson',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: 'Work Sans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 208,
                                          child: Text(
                                            'Date: $date',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: 'Work Sans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 208,
                                          child: Text(
                                            'Time: $time',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: 'Work Sans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                          Icons.border_color_rounded),
                                      onPressed: () {
                                        _navigateToAcceptRequest(
                                            senderUid, requestId);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close_rounded),
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(
                                            requestId, senderUid, senderName);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.uid)
                      .collection('rejectedRequests')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final notifications = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification =
                            notifications[index].data() as Map<String, dynamic>;
                        final message = notification['message'];
                        final notificationId = notifications[index].id;

                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            width: 380,
                            height: 50,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: ShapeDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x190043CE),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 18),
                                  child: Text(
                                    message,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteRejectedNotification(notificationId);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.uid)
                      .collection('AcceptedRequests')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final requests = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request =
                            requests[index].data() as Map<String, dynamic>;
                        final receivedId = requests[index].id;
                        final receiverName = request['receiverName'];
                        final Link = request['link'];
                        final date = request['date'];
                        final time = request['time'];
                        final receiverUid = request['receiverUid'];
                        final senderProfilePic = request['senderProfilePic'];

                        return GestureDetector(
                          onTap: () {
                            _showLinkDialog(context, Link);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              width: 380,
                              height: 140,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: ShapeDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x190043CE),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  senderProfilePic.isNotEmpty
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 18),
                                          child: SizedBox(
                                            height: 85,
                                            width: 85,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  senderProfilePic),
                                            ),
                                          ),
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.only(left: 18),
                                          child: SizedBox(
                                            height: 85,
                                            width: 85,
                                            child: CircleAvatar(
                                              child: Icon(Icons.person),
                                            ),
                                          ),
                                        ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 25),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$receiverName Accepted for tutoring',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontFamily: 'Work Sans',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: 208,
                                            child: Text(
                                              'Link: $Link',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Work Sans',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 208,
                                            child: Text(
                                              'Date: $date',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Work Sans',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 208,
                                            child: Text(
                                              'Time: $time',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Work Sans',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () {
                                      _showDeleteConfirmationDialogForlink(
                                          receivedId,
                                          receiverUid,
                                          receiverName);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
