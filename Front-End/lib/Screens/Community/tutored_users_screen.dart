import 'package:LearnPro/tutoring_system/request_tution_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TutoredUsersScreen extends StatelessWidget {
  const TutoredUsersScreen({super.key});

  Future<Map<String, dynamic>> getCurrentUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.data()!;
  }

  Future<List<String>> getTutoredUIDs() async {
    final userData = await getCurrentUserData();
    final Map<String, dynamic> tutoredMe = userData['tutoredMe'];
    final List<String> tutoredUIDs = tutoredMe.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
    return tutoredUIDs;
  }

  Future<List<Map<String, dynamic>>> getTutoredUsersData() async {
    final tutoredUIDs = await getTutoredUIDs();
    final usersCollection = FirebaseFirestore.instance.collection('users');

    final List<Map<String, dynamic>> tutoredUsersData = [];
    for (String uid in tutoredUIDs) {
      final userDoc = await usersCollection.doc(uid).get();
      tutoredUsersData.add(userDoc.data()!);
    }
    return tutoredUsersData;
  }

  Future<List<Map<String, dynamic>>> fetchTutoredUsers() async {
    return await getTutoredUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTutoredUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No tutored users found'),
            );
          }

          final tutoredUsers = snapshot.data!;

          return ListView.builder(
            itemCount: tutoredUsers.length,
            itemBuilder: (context, index) {
              final user = tutoredUsers[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 370,
                  height: 100,
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            width: 75,
                            height: 75,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user['profilePic']),
                              radius: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['userName'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user['major'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RequestTuitionForm(
                                      userID: user[
                                          'uid'], // Pass the uid of the user
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 110,
                                height: 25,
                                decoration: ShapeDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'Request Tuition',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     // Add review function here
                            //   },
                            //   child: Container(
                            //     width: 110,
                            //     height: 25,
                            //     decoration: ShapeDecoration(
                            //       color:
                            //           Theme.of(context).colorScheme.secondary,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(45),
                            //       ),
                            //       shadows: const [
                            //         BoxShadow(
                            //           color: Color(0x3F000000),
                            //           blurRadius: 4,
                            //           offset: Offset(0, 4),
                            //           spreadRadius: 0,
                            //         )
                            //       ],
                            //     ),
                            //     child: const Center(
                            //       child: Text(
                            //         'Review',
                            //         style: TextStyle(
                            //           color: Colors.black,
                            //           fontSize: 13,
                            //           fontFamily: 'Work Sans',
                            //           fontWeight: FontWeight.w400,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
