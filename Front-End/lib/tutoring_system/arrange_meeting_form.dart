import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'custom_button.dart';

class ArrangeMeetingForm extends StatefulWidget {
  final String requestID;

  const ArrangeMeetingForm({super.key, required this.requestID});

  @override
  _ArrangeMeetingFormState createState() => _ArrangeMeetingFormState();
}

class _ArrangeMeetingFormState extends State<ArrangeMeetingForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;
  String? currentUserName;
  //String? currentUserUId;
  //String? currentUserProfilePic;
  String? senderStudentUid;
  String? senderStudentName;
  String? senderStudentProfilePic;
  Map<String, dynamic>? requestData;
  bool isLoading = true;
  bool hasError = false;

  DateTime deliveredTime = DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController timeController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserAndRequestData();
    timeController.addListener(_updateTimeText);
  }

  @override
  void dispose() {
    timeController.removeListener(_updateTimeText);
    timeController.dispose();
    linkController.dispose();
    messageController.dispose();
    super.dispose();
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
        // currentUserUId = userDoc['uid'];
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

  void _updateTimeText() {
    final text = timeController.text;
    if (text.length == 2 && !text.endsWith(':')) {
      timeController.text = '$text:';
      timeController.selection = TextSelection.fromPosition(
        TextPosition(offset: timeController.text.length),
      );
    }
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a time.';
    }
    final timeParts = value.split(':');
    if (timeParts.length != 2) {
      return 'Invalid time format. Use HH:MM';
    }
    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);
    if (hour == null || minute == null) {
      return 'Invalid time format. Use HH:MM';
    }
    if (hour < 0 || hour > 23) {
      return 'Hour must be between 00 and 23.';
    }
    if (minute < 0 || minute > 59) {
      return 'Minute must be between 00 and 59.';
    }
    return null;
  }

  Future<void> _handleArrange() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      var requestDocRef = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('tuitionRequests')
          .doc(widget.requestID);

      await requestDocRef.update({
        'status': 'accepted',
        'read': true,
      });

      var arrangedMeetingDocRef = _firestore
          .collection('users')
          .doc(senderStudentUid)
          .collection('arrangedMeetings')
          .doc(widget.requestID);

      await arrangedMeetingDocRef.set({
        'meetingID': widget.requestID,
        'time': timeController.text,
        'link': linkController.text,
        'msg': messageController.text,
        'teacherId': currentUser!.uid,
        //'teacherName': currentUserName,
        // 'teacherProfilePic': currentUserProfilePic,
        'subject': requestData!['subject'],
        'lesson': requestData!['lesson'],
        'date': requestData!['date'],
        'read': false,
        'status': "",
        'deliveredTime': deliveredTime,
      });
      await _firestore.collection('users').doc(senderStudentUid).set({
        'tutoredMe': {
          currentUser!.uid: true,
        },
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You arranged the meeting')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to arrange the meeting. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Arrange Meeting')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError || requestData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Arrange Meeting')),
        body: const Center(child: Text('Failed to load request details.')),
      );
    }

    String lesson = requestData!['lesson'];
    String subject = requestData!['subject'];
    String timeStart = requestData!['timeStart'];
    String timeEnd = requestData!['timeEnd'];
    String date = requestData!['date'];

    return Scaffold(
      appBar: AppBar(title: const Text('Arrange Meeting')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      " From",
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
                      "I have availability between $timeStart to $timeEnd on $date. Can you arrange a meeting for this?",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Your Reply:'),
                const Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Sure, I can help you with this lesson and I am available during this time period. I am arranging a meeting here.",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateTime,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: linkController,
                  decoration: const InputDecoration(
                    labelText: 'Link',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a link.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: messageController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      text: "cancel",
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      borderColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    CustomButton(
                      text: "Arrange",
                      onPressed: _handleArrange,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),

                    // ElevatedButton(
                    //   onPressed: _handleArrange,
                    //   child: Text('Arrange'),
                    // ),
                    //SizedBox(width: 10),
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
      ),
    );
  }
}
