import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_button.dart';

class ConfirmMessageForm extends StatefulWidget {
  final String meetingID;

  const ConfirmMessageForm({super.key, required this.meetingID});

  @override
  _ConfirmMessageFormState createState() => _ConfirmMessageFormState();
}

class _ConfirmMessageFormState extends State<ConfirmMessageForm> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = true;
  Map<String, dynamic>? _meetingData;
  String? _userName;
  //String? _userProfilePic;
  String? _teacherName;
  String? _teacherProfilePic;

  DateTime? _sessionTime;
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

  Future<void> _confirmParticipation() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && _meetingData != null) {
        String teacherId = _meetingData!['teacherId'];
        String message = _messageController.text.trim();

        String sessionTimeString =
            "${_meetingData!['date']} ${_meetingData!['time']}";
        _sessionTime = DateTime.parse(sessionTimeString);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('arrangedMeetings')
            .doc(widget.meetingID)
            .update({'status': 'accepted', 'read': true});

        await FirebaseFirestore.instance
            .collection('users')
            .doc(teacherId)
            .collection('confirmMsgs')
            .doc(widget.meetingID)
            .set({
          'msgID': widget.meetingID,
          'time': _meetingData!['time'],
          'link': _meetingData!['link'],
          'msg': message,
          'StdId': user.uid,
          // 'StdName': _userName,
          // 'StdProfilePic': _userProfilePic,
          'subject': _meetingData!['subject'],
          'lesson': _meetingData!['lesson'],
          'date': _meetingData!['date'],
          'sessionTime': _sessionTime,
          'read': false,
          'cancelBtn': true,
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(teacherId)
            .collection('teachingRecs')
            .doc(widget.meetingID)
            .set({
          'recID': widget.meetingID,
          'time': _meetingData!['time'],
          'StdId': user.uid,
          // 'StdName': _userName,
          //'StdProfilePic': _userProfilePic,`
          'subject': _meetingData!['subject'],
          'lesson': _meetingData!['lesson'],
          'date': _meetingData!['date'],
          'reviewed': false,
          'held': true,
          'sessionTime': _sessionTime,
          'tchAvblt': true,
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('learningRecs')
            .doc(widget.meetingID)
            .set({
          'recID': widget.meetingID,
          'time': _meetingData!['time'],
          'teacherId': _meetingData!['teacherId'],
          //'teacherName': _teacherName,
          //'teacherProfilePic': _teacherProfilePic,
          'subject': _meetingData!['subject'],
          'lesson': _meetingData!['lesson'],
          'date': _meetingData!['date'],
          'reviewed': false,
          'held': true,
          'sessionTime': _sessionTime,
          'tchAvblt': true,
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You confirmed the meeting'),
        ));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to confirm participation'),
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
          title: const Text('Confirm Participation'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_meetingData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Confirm Participation'),
        ),
        body: const Center(child: Text('No data found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Participation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    Text(
                      _teacherName ?? '',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Hi $_userName,\n'
                      'Thanks for reaching out. I would be happy to help you with ${_meetingData!['lesson']} in ${_meetingData!['subject']}. I have arranged a meeting to tutor you via online on ${_meetingData!['date']} at ${_meetingData!['time']} (within your requested timeframe), Does that work for you? Let me know.\n'
                      '${_meetingData!['msg']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const Text('Here\'s the meeting link:'),
                InkWell(
                  onTap: () => _openLink(_meetingData!['link']),
                  child: Text(
                    _meetingData!['link'],
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(
                  height: 9,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ElevatedButton(
                    //   onPressed: () => _openLink(_meetingData!['link']),
                    //   child: Text('Open Link'),
                    // ),
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
                    //   onPressed: () => _copyLink(_meetingData!['link']),
                    //   child: Text('Copy Link'),
                    // ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Text('Your Reply:'),
                const SizedBox(height: 8.0),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'That works perfectly for me! Thanks so much. I\'ll be sure to join the meeting on time.',
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text('Mention additional message if you need'),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _messageController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Message',
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ElevatedButton(
                    //   onPressed: _confirmParticipation,
                    //   child: Text('Send'),
                    // ),
                    CustomButton(
                      text: "cancel",
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      borderColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    CustomButton(
                      text: "OK",
                      onPressed: _confirmParticipation,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
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
