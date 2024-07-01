import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_button.dart';

class MeetingMessage extends StatefulWidget {
  final String meetingID;

  const MeetingMessage({super.key, required this.meetingID});

  @override
  _MeetingMessageState createState() => _MeetingMessageState();
}

class _MeetingMessageState extends State<MeetingMessage> {
  bool _isLoading = true;
  Map<String, dynamic>? _meetingData;
  String? _userName;
  // String? _userProfilePic;
  String? _teacherName;
  String? _teacherProfilePic;

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
            // _userProfilePic = userSnapshot['profilePic'];
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

  Future<void> _copyLink(String link) async {
    await Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Link copied to clipboard'),
    ));
  }

  Future<void> _openLink(String link) async {
    final Uri? url = Uri.tryParse(link);

    if (url != null) {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        // Handle cases where there's no app to handle the URL scheme
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No app found to open this type of link'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid URL'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Meeting Message'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_meetingData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Meeting Message'),
        ),
        body: const Center(child: Text('No data found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Message'),
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
              const Text(
                "Here's the meeting link:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () => _openLink(_meetingData!['link']),
                child: Text(
                  _meetingData!['link'],
                  style: const TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: "Open Link",
                    onPressed: () => _openLink(_meetingData!['link']),
                    backgroundColor: Colors.blue,
                  ),
                  CustomButton(
                    text: "Copy Link",
                    onPressed: () => _copyLink(_meetingData!['link']),
                    backgroundColor: Colors.blue,
                  ),

                  // ElevatedButton(
                  //   onPressed: _openLink,
                  //   child: Text('Open Link'),
                  // ),
                  // ElevatedButton(
                  //   onPressed: _copyLink,
                  //   child: Text('Copy Link'),
                  // ),
                ],
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              Center(
                child: CustomButton(
                  text: "close",
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  borderColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
