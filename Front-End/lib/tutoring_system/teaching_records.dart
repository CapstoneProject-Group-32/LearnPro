import 'package:LearnPro/tutoring_system/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TeachingRecords extends StatefulWidget {
  final String userId;

  const TeachingRecords({super.key, required this.userId});

  @override
  _TeachingRecordsState createState() => _TeachingRecordsState();
}

class _TeachingRecordsState extends State<TeachingRecords> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    _currentUser = _auth.currentUser;
    setState(() {});
  }

  String _timeDifference(String date, String time) {
    final now = DateTime.now();
    final meetingDate = DateFormat('yyyy-MM-dd').parse(date);
    final meetingTime = TimeOfDay(
      hour: int.parse(time.split(':')[0]),
      minute: int.parse(time.split(':')[1]),
    );
    final meetingDateTime = DateTime(meetingDate.year, meetingDate.month,
        meetingDate.day, meetingTime.hour, meetingTime.minute);
    final difference = meetingDateTime.difference(now);
    if (difference.isNegative) {
      return 'Meeting started';
    }
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    return '$days days $hours hours $minutes mins';
  }

  Future<Map<String, dynamic>> _getUserInfo(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.userId.toString() != _currentUser?.uid.toString()
          ? CustomAppBar(title: "Teaching Records")
          : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .collection('teachingRecs')
              // .orderBy('date')
              .orderBy('sessionTime', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Connect to internet.'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No teaching Records'));
            }

            final records = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id; // Store the document ID for reference
              return data;
            }).toList();

            return ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                final date = record['date'];
                final time = record['time'];
                final reviewed = record['reviewed'] as bool? ?? false;
                final held = record['held'] as bool? ?? false;
                final stdId = record['StdId'];
                final subject = record['subject'];
                final lesson = record['lesson'];
                final tchAvblt = record['tchAvblt'] is bool
                    ? record['tchAvblt'] as bool
                    : true;

                final meetingStarted = DateTime.now().isAfter(
                    DateFormat('yyyy-MM-dd HH:mm').parse('$date $time'));

                return FutureBuilder<Map<String, dynamic>>(
                  future: _getUserInfo(stdId),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (userSnapshot.hasError) {
                      return const Center(
                          child: Text('Error loading user data.'));
                    }

                    if (!userSnapshot.hasData) {
                      return const Center(child: Text('User not found.'));
                    }

                    final userData = userSnapshot.data!;
                    final stdProfilePic = userData['profilePic'];
                    final stdName = userData['userName'];

                    return Card(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              if (!tchAvblt)
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(stdProfilePic),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "$stdName couldn't participate  in tuition session",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900, //
                                          color: Colors.red),
                                    ))
                                  ],
                                ),
                              if (!meetingStarted && tchAvblt)
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(stdProfilePic),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "$stdName is waiting for your tuition session",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900),
                                    ))
                                  ],
                                ),
                              if (meetingStarted && !reviewed && tchAvblt)
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(stdProfilePic),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "$stdName participated in tuition session",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900),
                                    ))
                                  ],
                                ),
                              if (reviewed && held && tchAvblt)
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(stdProfilePic),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "$stdName participated in tuition session",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900),
                                    ))
                                  ],
                                ),
                              if (reviewed && !held && tchAvblt)
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(stdProfilePic),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "$stdName couldn't participate  in tuition session",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.red),
                                    ))
                                  ],
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.book),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text('$subject - $lesson '),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.date_range),
                                  const SizedBox(
                                    width: 1,
                                  ),
                                  Text(' At $time on $date'),
                                ],
                              ),
                              if (!meetingStarted && tchAvblt)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "session will start in ${_timeDifference(date, time)}",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ),
                              if (meetingStarted && !reviewed && tchAvblt)
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'No feedbacks yet',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )),
                              if (reviewed && held && tchAvblt)
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '$stdName have given a feedback',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                )),
                              if (reviewed && !held && tchAvblt)
                                const Center(
                                    child: Text(
                                  'This meeting was cancelled',
                                  style: TextStyle(color: Colors.red),
                                )),
                              if (!tchAvblt)
                                const Center(
                                    child: Text(
                                  'you have cancelled the meeting',
                                  style: TextStyle(color: Colors.red),
                                )),
                            ],
                          ),
                        ));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}


// ListTile(
//                           leading: CircleAvatar(
//                             backgroundImage: NetworkImage(stdProfilePic),
//                           ),
//                           title: Text("student:$stdName"),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(Icons.book),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Expanded(
//                                     child: Text('$subject - $lesson '),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(Icons.date_range),
//                                   SizedBox(
//                                     width: 1,
//                                   ),
//                                   Text(' At $time on $date'),
//                                 ],
//                               ),
//                               if (!meetingStarted)
//                                 Text(_timeDifference(date, time)),
//                               if (meetingStarted && !reviewed)
//                                 Center(
//                                     child: Padding(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: Text(
//                                     'No feedbacks yet',
//                                     style: TextStyle(color: Colors.red),
//                                   ),
//                                 )),
//                               if (reviewed && held)
//                                 Center(
//                                     child: Text(
//                                   '$stdName have given a feedback',
//                                   style: TextStyle(color: Colors.red),
//                                 )),
//                               if (reviewed && !held)
//                                 Center(
//                                     child: Text(
//                                   'This meeting was cancelled',
//                                   style: TextStyle(color: Colors.red),
//                                 )),
//                             ],
//                           ),
//                         ),