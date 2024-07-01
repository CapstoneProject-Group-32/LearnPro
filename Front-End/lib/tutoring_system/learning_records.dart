import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'custom_button.dart';
import 'feedback_form.dart';

class LearningRecords extends StatefulWidget {
  const LearningRecords({super.key});

  @override
  _LearningRecordsState createState() => _LearningRecordsState();
}

class _LearningRecordsState extends State<LearningRecords> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    _user = _auth.currentUser;
    setState(() {});
  }

  Future<Map<String, dynamic>> _getUserInfo(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.data() as Map<String, dynamic>;
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

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Learning Records'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Learning Records'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .collection('learningRecs')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Connect to internet.'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No notifications.'));
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
                final teacherId = record['teacherId'];
                final subject = record['subject'];
                final lesson = record['lesson'];
                final recID = record['id'];
                final tchAvblt = record['tchAvblt'] as bool;

                final meetingStarted = DateTime.now().isAfter(
                    DateFormat('yyyy-MM-dd HH:mm').parse('$date $time'));

                return FutureBuilder<Map<String, dynamic>>(
                  future: _getUserInfo(teacherId),
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
                    final teacherProfilePic = userData['profilePic'];
                    final teacherName = userData['userName'];

                    return Card(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.7),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              if (!tchAvblt)
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(teacherProfilePic),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "$teacherName has arranged a meeting for you",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900),
                                    ))
                                  ],
                                ),

                              if (!meetingStarted && tchAvblt)
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(teacherProfilePic),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "$teacherName has arranged a meeting for you",
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
                                          NetworkImage(teacherProfilePic),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "$teacherName is waiting for a feedback about the session ",
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
                                          NetworkImage(teacherProfilePic),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "$teacherName conducted a tuition session for you",
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
                                          NetworkImage(teacherProfilePic),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "$teacherName wasn't able to host  the session",
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "session will start in ${_timeDifference(date, time)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                ),
                              if (meetingStarted && !reviewed && tchAvblt)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: CustomButton(
                                        text: "Missed",
                                        onPressed: () {
                                          _showCancellationDialog(
                                              context, recID);
                                        },
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: CustomButton(
                                        text: "Attended",
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FeedbackForm(recID: recID),
                                            ),
                                          );
                                        },
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              // Center(
                              //     child: Padding(
                              //   padding: EdgeInsets.all(8.0),
                              //   child: Text(
                              //     'No feedbacks yet',
                              //     style: TextStyle(color: Colors.red),
                              //   ),
                              // )),
                              if (reviewed && held && tchAvblt)
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'you have given a feedback',
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
                                Center(
                                    child: Text(
                                  '$teacherName have cancelled for unavoidable reason',
                                  style: const TextStyle(color: Colors.red),
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

  Future<void> _showCancellationDialog(BuildContext context, String recID) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Was the meeting cancelled even after confirming?'),
          actions: [
            TextButton(
              onPressed: () {
                _updateMeetingStatus(recID, reviewed: true, held: false);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateMeetingStatus(String recID,
      {required bool reviewed, required bool held}) async {
    try {
      final uid = _user!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('learningRecs')
          .doc(recID)
          .update({'reviewed': reviewed, 'held': held});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('TeachingRecs')
          .doc(recID)
          .update({'reviewed': reviewed, 'held': held});
    } catch (e) {
      print('Error updating meeting status: $e');
      // Handle error
    }
  }
}



// ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(teacherProfilePic),
//                       ),


                      
//                       title: Text(teacherName),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('$subject - $lesson'),
//                           Text('Time: At $time on $date'),
//                           if (!meetingStarted)
//                             Text(_timeDifference(date, time)),
//                           if (meetingStarted && !reviewed)
//                             Row(
//                               children: [
//                                 CustomButton(
//                                   text: "cancel",
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             FeedbackForm(recID: recID),
//                                       ),
//                                     );
//                                   },
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.background,
//                                   borderColor:
//                                       Theme.of(context).colorScheme.secondary,
//                                   foregroundColor:
//                                       Theme.of(context).colorScheme.secondary,
//                                 ),
//                                 CustomButton(
//                                   text: "OK",
//                                   onPressed: () {
//                                     _showCancellationDialog(context, recID);
//                                   },
//                                   backgroundColor:
//                                       Theme.of(context).colorScheme.secondary,
//                                 ),

//                               ],
//                             ),
//                           if (reviewed && held) Center(child: Text('Reviewed')),
//                           if (reviewed && !held)
//                             Center(child: Text('This meeting was cancelled')),
//                         ],
//                       ),
//                     ),