import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'custom_button.dart';

class RejectedMsgView extends StatelessWidget {
  final String msgID;

  const RejectedMsgView({super.key, required this.msgID});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejected Message'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userDocRef.get(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }
          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return const Center(child: Text('User not found'));
          }

          final currentUserData =
              userSnapshot.data!.data() as Map<String, dynamic>;
          final String currentUserName = currentUserData['userName'];

          return FutureBuilder<DocumentSnapshot>(
            future: userDocRef.collection('rejectedMsgs').doc(msgID).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> msgSnapshot) {
              if (msgSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (msgSnapshot.hasError) {
                return Center(child: Text('Error: ${msgSnapshot.error}'));
              }
              if (!msgSnapshot.hasData || !msgSnapshot.data!.exists) {
                return const Center(child: Text('Message not found'));
              }

              final msgData = msgSnapshot.data!.data() as Map<String, dynamic>;
              final String teacherId = msgData['teacherId'];
              final String message = msgData['msg'];
              final String date = msgData['date'];
              final String startTime = msgData['startTime'];
              final String endTime = msgData['endTime'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(teacherId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> teacherSnapshot) {
                  if (teacherSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (teacherSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${teacherSnapshot.error}'));
                  }
                  if (!teacherSnapshot.hasData ||
                      !teacherSnapshot.data!.exists) {
                    return const Center(child: Text('Teacher not found'));
                  }

                  final teacherData =
                      teacherSnapshot.data!.data() as Map<String, dynamic>;
                  final String teacherName = teacherData['userName'];
                  final String teacherProfilePic = teacherData['profilePic'];

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(teacherProfilePic),
                              radius: 20,
                            ),
                            const SizedBox(width: 8),
                            Text('Teacher: $teacherName',
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Message:', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 8),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Hi $currentUserName,\n'
                              'My apologies for the inconvenience. Unfortunately, I won\'t be able to arrange a meeting on $date '
                              'between $startTime to $endTime.\n\n'
                              '$message',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: CustomButton(
                            text: "Close",
                            onPressed: () => Navigator.pop(context),
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            borderColor:
                                Theme.of(context).colorScheme.secondary,
                            foregroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),

                          //  ElevatedButton(
                          //   onPressed: () {
                          //     Navigator.of(context).pop();
                          //   },
                          //   child: Text('Close'),
                          // ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
