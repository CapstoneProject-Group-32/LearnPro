import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'custom_button.dart';

class CancelMeeting extends StatefulWidget {
  final String meetingID;

  const CancelMeeting({super.key, required this.meetingID});

  @override
  _CancelMeetingState createState() => _CancelMeetingState();
}

class _CancelMeetingState extends State<CancelMeeting> {
  final TextEditingController _replyController = TextEditingController();
  bool _isLoading = true;
  Map<String, dynamic>? _meetingData;
  String? _userName;
  // String? _userProfilePic;
  String? _teacherName;
  String? _teacherProfilePic;
  DateTime sentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchMeetingData();
  }

  Future<void> _fetchMeetingData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch meeting data
        DocumentSnapshot meetingSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('arrangedMeetings')
            .doc(widget.meetingID)
            .get();

        _meetingData = meetingSnapshot.data() as Map<String, dynamic>;

        if (_meetingData != null) {
          String teacherId = _meetingData!['teacherId'];

          // Fetch teacher data
          DocumentSnapshot teacherSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(teacherId)
              .get();

          // Fetch user data
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          setState(() {
            _userName = userSnapshot['userName'];
            //_userProfilePic = userSnapshot['profilePic'];
            _teacherName = teacherSnapshot['userName'];
            _teacherProfilePic = teacherSnapshot['profilePic'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to load data'),
      ));
    }
  }

  Future<void> _cancelMeeting() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && _meetingData != null) {
        String teacherId = _meetingData!['teacherId'];
        String reply = _replyController.text.trim();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('arrangedMeetings')
            .doc(widget.meetingID)
            .update({'status': 'rejected', 'read': true});

        await FirebaseFirestore.instance
            .collection('users')
            .doc(teacherId)
            .collection('cancelledmeetings')
            .doc(widget.meetingID)
            .set({
          'msgID': widget.meetingID,
          'time': _meetingData!['time'],
          'msg': reply,
          'StdId': user.uid,
          //'StdName': _userName,
          //'StdProfilePic': _userProfilePic,
          'subject': _meetingData!['subject'],
          'lesson': _meetingData!['lesson'],
          'date': _meetingData!['date'],
          'read': false,
          'sentTime': sentTime,
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You cancelled the meeting'),
        ));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to cancel meeting'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cancel Meeting'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_meetingData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cancel Meeting'),
        ),
        body: const Center(child: Text('No data found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancel Meeting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "From:",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundImage: NetworkImage(_teacherProfilePic ?? ''),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _teacherName ?? '',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Hi $_userName,\n\n"
                      "Thanks for reaching out. I would be happy to help you with ${_meetingData!['lesson']} in ${_meetingData!['subject']}. I have arranged a meeting to tutor you via online on ${_meetingData!['date']} at ${_meetingData!['time']} (within your requested timeframe), Does that work for you? Let me know.\n"
                      "${_meetingData!['msg']}"),
                ),
              ),
              const SizedBox(height: 10.0),
              const Text('Your Reply:'),
              const SizedBox(height: 8.0),
              const Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Thanks so much for trying to schedule a tutoring session. Unfortunately, I won\'t be able to participate in this session. My apologies for the inconvenience. I would send another request to rearrange this meeting.',
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              const Text('Mention the reason why if you cancel the meeting.'),
              const SizedBox(height: 8.0),
              TextField(
                controller: _replyController,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Reply',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ElevatedButton(
                  //   onPressed: _cancelMeeting,
                  //   child: Text('Send'),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () => Navigator.pop(context),
                  //   child: Text('Cancel'),
                  // ),
                  CustomButton(
                    text: "cancel",
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    borderColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  CustomButton(
                    text: "Postpone",
                    onPressed: _cancelMeeting,
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
