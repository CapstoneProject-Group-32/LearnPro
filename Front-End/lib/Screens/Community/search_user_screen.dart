import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:LearnPro/Models/usermodel.dart';

class SearchUserScreen extends StatefulWidget {
  final UserModel user;

  const SearchUserScreen({super.key, required this.user});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  int calculatePoints(double sumOfFocusTime) {
    if (sumOfFocusTime >= 4) return 7500;
    if (sumOfFocusTime >= 3) return 3500;
    if (sumOfFocusTime >= 2) return 1500;
    if (sumOfFocusTime >= 1) return 500;
    return 0;
  }

  int calculateLevel(int points) {
    if (points >= 8000) return 4;
    if (points >= 4000) return 3;
    if (points >= 2000) return 2;
    if (points >= 500) return 1;
    return 0;
  }

  bool isFriend = false;

  @override
  void initState() {
    super.initState();
    checkFriendshipStatus();
  }

  void checkFriendshipStatus() async {
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(userUid).get();
    UserModel currentUser =
        UserModel.fromJSON(userSnapshot.data() as Map<String, dynamic>);
    setState(() {
      isFriend = currentUser.friends.contains(widget.user.uid);
    });
  }

  void addFriend() async {
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    try {
      // Add the friend to the current user's friend list
      await _firestore.collection('users').doc(userUid).update({
        'friends': FieldValue.arrayUnion([widget.user.uid]),
      });

      // Add the current user to the friend's friend list
      await _firestore.collection('users').doc(widget.user.uid).update({
        'friends': FieldValue.arrayUnion([userUid]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added ${widget.user.userName} as a friend')));
      setState(() {
        isFriend = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void removeFriend() async {
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    try {
      // Remove the friend from the current user's friend list
      await _firestore.collection('users').doc(userUid).update({
        'friends': FieldValue.arrayRemove([widget.user.uid]),
      });

      // Remove the current user from the friend's friend list
      await _firestore.collection('users').doc(widget.user.uid).update({
        'friends': FieldValue.arrayRemove([userUid]),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Removed friend')));
      setState(() {
        isFriend = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget
                .user.uid) // Use the uid of the user passed to this widget
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final timerData = userData['timer'];

            UserModel user = UserModel.fromJSON(userData);

            double sumOfFocusTime =
                timerData != null && timerData['sumOfFocusTime'] != null
                    ? timerData['sumOfFocusTime'] / 3600
                    : 0.0;

            int points = calculatePoints(sumOfFocusTime);
            int level = calculateLevel(points);

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 100,
                              width: 100,
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
                                backgroundImage:
                                    NetworkImage(widget.user.profilePic),
                                radius: 50,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              user.userName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              user.major,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            //prograss container

                            Container(
                              width: double.infinity,
                              decoration: ShapeDecoration(
                                color: Theme.of(context).colorScheme.secondary,
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildStatColumn(
                                            level.toString(), "Level"),
                                        _buildStatColumn(
                                            "${sumOfFocusTime.toStringAsFixed(1)}H",
                                            "Time"),
                                        _buildStatColumn("4", "Tutored"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),

                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Total Statistics",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // statistic containers

                            _buildStatContainer("Friends",
                                widget.user.friends.length.toString()),
                            const SizedBox(height: 20),
                            _buildStatContainer("Points", points.toString()),
                            const SizedBox(height: 20),
                            _buildStatContainer("Rating", "3.7"),
                            const SizedBox(
                              height: 20,
                            ),

                            GestureDetector(
                              onTap: isFriend ? removeFriend : addFriend,
                              child: Container(
                                width: 200,
                                height: 50,
                                decoration: ShapeDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                                child: Center(
                                  child: Text(
                                    isFriend ? 'Remove Friend' : 'Add Friend',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(
    String value,
    String label,
  ) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            Text(
              label,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatContainer(String label, String value) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
