import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'custom_button.dart';

class CancelMsgView extends StatelessWidget {
  final String msgID;

  const CancelMsgView({super.key, required this.msgID});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancelled Meeting Message'),
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
            future: userDocRef.collection('cancelledmeetings').doc(msgID).get(),
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
              final String stdId = msgData['StdId'];
              final String message = msgData['msg'];
              final String date = msgData['date'];
              final String time = msgData['time'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(stdId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> studentSnapshot) {
                  if (studentSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (studentSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${studentSnapshot.error}'));
                  }
                  if (!studentSnapshot.hasData ||
                      !studentSnapshot.data!.exists) {
                    return const Center(child: Text('Student not found'));
                  }

                  final studentData =
                      studentSnapshot.data!.data() as Map<String, dynamic>;
                  final String studentName = studentData['userName'];
                  final String studentProfilePic = studentData['profilePic'];

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(studentProfilePic),
                              radius: 20,
                            ),
                            const SizedBox(width: 8),
                            Text('Student: $studentName',
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
                              'Thanks so much for trying to schedule a tutoring session regarding my request. Unfortunately, I won\'t be able to participate in this session at $time on $date. My apologies for the inconvenience. I would send another request to rearrange this meeting.\n\n'
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
