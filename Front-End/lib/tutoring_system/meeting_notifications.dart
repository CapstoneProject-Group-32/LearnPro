import 'package:LearnPro/tutoring_system/defined_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'cancel_meeting_form.dart';
import 'confirm_message_form.dart';
import 'custom_button.dart';
import 'meeting_message.dart';

class MeetingNotifications extends StatefulWidget {
  const MeetingNotifications({super.key});

  @override
  _MeetingNotificationsState createState() => _MeetingNotificationsState();
}

class _MeetingNotificationsState extends State<MeetingNotifications> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Center(child: Text('User not logged in'));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .collection('arrangedMeetings')
            .orderBy('deliveredTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Connect to the internet'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notifications'));
          }

          List<Meeting> meetings = snapshot.data!.docs
              .map((doc) => Meeting.fromDocument(doc))
              .toList();

          // Separate read and unread meetings
          List<Meeting> unreadMeetings =
              meetings.where((m) => !m.read).toList();
          List<Meeting> readMeetings = meetings.where((m) => m.read).toList();

          // Combine the lists with unread meetings first
          List<Meeting> sortedMeetings = unreadMeetings + readMeetings;

          return ListView.builder(
            itemCount: sortedMeetings.length,
            itemBuilder: (context, index) {
              Meeting meeting = sortedMeetings[index];
              return GestureDetector(
                  onLongPress: () => _showDeleteDialog(context, meeting),
                  child: _buildMeetingItem(meeting));
            },
          );
        },
      ),
    );
  }

  Widget _buildMeetingItem(Meeting meeting) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(meeting.teacherId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Failed to load teacher details'));
        }

        var teacherData = snapshot.data!;
        String teacherName = teacherData['userName'];
        String teacherProfilePic = teacherData['profilePic'];

        return Card(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(teacherProfilePic),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        '$teacherName has arranged a meeting for your tutor request.',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Meeting details:',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 4.0),
                //Text('Subject: ${meeting.subject}'),
                Row(
                  children: [
                    Icon(
                      Icons.book,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Text(' ${meeting.lesson}(${meeting.subject})')),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('At ${meeting.time} on ${meeting.date}'),
                  ],
                ),

                if (!meeting.read) ...[
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => ConfirmMessage(
                      //           meetingID: meeting.meetingID,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   child: Text('Confirm Participation'),
                      // ),
                      CustomButton(
                          text: "Cancel",
                          onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CancelMeeting(
                                    meetingID: meeting.meetingID,
                                  ),
                                ),
                              ),
                          backgroundColor: rejectButtonColor),
                      CustomButton(
                        text: "Yes.I'm In",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmMessageForm(
                                meetingID: meeting.meetingID,
                              ),
                            ),
                          );
                        },
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => CancelMeeting(
                      //           meetingID: meeting.meetingID,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   child: Text('Cancel Meeting'),
                      // ),
                    ],
                  ),
                ],
                if (meeting.read && meeting.status == 'accepted') ...[
                  const SizedBox(height: 8.0),
                  Center(
                      child: Text(
                    'You have confirmed your participation',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: CustomButton(
                      text: "Get link",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeetingMessage(
                              meetingID: meeting.meetingID,
                            ),
                          ),
                        );
                      },
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),

                    // child: ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => MeetingMessage(
                    //           meetingID: meeting.meetingID,
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   child: Text('Get Link'),
                    // ),
                  ),
                ],
                if (meeting.read && meeting.status == 'rejected') ...[
                  const SizedBox(height: 8.0),
                  const Center(
                      child: Text(
                    'You have canceled the meeting',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )),
                ],
                if (meeting.read && meeting.status == 'cancelled') ...[
                  const SizedBox(height: 8.0),
                  Center(
                      child: Text(
                    '$teacherName have canceled the meeting',
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  )),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Meeting meeting) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Meeting'),
          content: const Text('Are you sure you want to delete this meeting?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteMeeting(meeting);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteMeeting(Meeting meeting) async {
    if (_currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('arrangedMeetings')
          .doc(meeting.meetingID)
          .delete();
    }
  }
}

class Meeting {
  final String meetingID;
  final String date;
  final Timestamp deliveredTime;
  final String lesson;
  final String link;
  final String msg;
  final bool read;
  final String status;
  final String subject;
  final String teacherId;
  final String time;

  Meeting({
    required this.meetingID,
    required this.date,
    required this.deliveredTime,
    required this.lesson,
    required this.link,
    required this.msg,
    required this.read,
    required this.status,
    required this.subject,
    required this.teacherId,
    required this.time,
  });

  factory Meeting.fromDocument(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Meeting(
      meetingID: doc.id,
      date: data['date'],
      deliveredTime: data['deliveredTime'],
      lesson: data['lesson'],
      link: data['link'],
      msg: data['msg'],
      read: data['read'],
      status: data['status'],
      subject: data['subject'],
      teacherId: data['teacherId'],
      time: data['time'],
    );
  }
}
