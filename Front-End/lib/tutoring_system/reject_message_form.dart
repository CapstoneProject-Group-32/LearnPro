import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'custom_button.dart';

class RejectMessageForm extends StatefulWidget {
  final String requestID;

  const RejectMessageForm({super.key, required this.requestID});

  @override
  _RejectMessageFormState createState() => _RejectMessageFormState();
}

class _RejectMessageFormState extends State<RejectMessageForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;
  String? currentUserName;
  DateTime sentTime = DateTime.now();
  // String? currentUserProfilePic;
  String? senderStudentUid;
  String? senderStudentName;
  String? senderStudentProfilePic;
  Map<String, dynamic>? requestData;
  bool isLoading = true;
  bool hasError = false;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserAndRequestData();
  }

  Future<void> _fetchCurrentUserAndRequestData() async {
    try {
      currentUser = _auth.currentUser;
      if (currentUser == null) {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        return;
      }

      var userDoc =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      var requestDoc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('tuitionRequests')
          .doc(widget.requestID)
          .get();

      var senderUid = requestDoc['senderStudent'];

      var senderDoc = await _firestore.collection('users').doc(senderUid).get();

      setState(() {
        currentUserName = userDoc['userName'];
        // currentUserProfilePic = userDoc['profilePic'];
        requestData = requestDoc.data();
        senderStudentUid = senderUid;
        senderStudentName = senderDoc['userName'];
        senderStudentProfilePic = senderDoc['profilePic'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _handleReject() async {
    if (messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a reason for rejection.')),
      );
      return;
    }

    try {
      var requestDocRef = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('tuitionRequests')
          .doc(widget.requestID);

      await requestDocRef.update({
        'status': 'rejected',
        'read': true,
      });

      var rejectedMsgDocRef = _firestore
          .collection('users')
          .doc(senderStudentUid)
          .collection('rejectedMsgs')
          .doc(widget.requestID);

      await rejectedMsgDocRef.set({
        'msgId': widget.requestID,
        'msg': messageController.text,
        'teacherId': currentUser!.uid,
        // 'teacherName': currentUserName,
        // 'teacherProfilePic': currentUserProfilePic,
        'subject': requestData!['subject'],
        'lesson': requestData!['lesson'],
        'endTime': requestData!['timeEnd'],
        'startTime': requestData!['timeStart'],
        'date': requestData!['date'],
        'sentTime': sentTime,
        'read': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You rejected the request')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to reject the request. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reject Request')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError || requestData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reject Request')),
        body: const Center(child: Text('Failed to load request details.')),
      );
    }

    String lesson = requestData!['lesson'];
    String subject = requestData!['subject'];
    String timeStart = requestData!['timeStart'];
    String timeEnd = requestData!['timeEnd'];
    String date = requestData!['date'];
    String msg = requestData!['message'];

    return Scaffold(
      appBar: AppBar(title: const Text('Reject Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    " From:",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(senderStudentProfilePic!),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    senderStudentName!,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              const Text('Request message:'),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Hi $currentUserName,\n'
                    "I'm struggling with $lesson in $subject, I saw your profile and think you might be a great fit to help me. "
                    "Would you mind tutoring me that could help me understand it better? "
                    "I have availability between $timeStart to $timeEnd on $date. Can you arrange a meeting for this?\n"
                    "$msg",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Your Reply:'),
              const Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "My apologies for the inconvenience. Unfortunately, I won't be able to arrange a meeting for this.\n"
                    "Because……",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const Text('Text – type your reason:'),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ElevatedButton(
                  //   onPressed: _handleReject,
                  //   child: Text('Reject'),
                  // ),
                  CustomButton(
                    text: "cancel",
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    borderColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  CustomButton(
                      text: "Reject",
                      onPressed: _handleReject,
                      backgroundColor: Colors.red),
                  // SizedBox(width: 10),
                  // ElevatedButton(
                  //   onPressed: () => Navigator.pop(context),
                  //   child: Text('Cancel'),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
