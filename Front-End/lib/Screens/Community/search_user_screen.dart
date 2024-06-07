import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:flutter_application_1/Screens/Community/find_studybuddies.dart';

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
          .showSnackBar(SnackBar(content: Text('Removed friend')));
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
    return SafeArea(
      child: Scaffold(
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

              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding:
                    const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // Profile back button
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StudyBuddies(),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 28,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Profile",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: NetworkImage(widget.user.profilePic),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      user.userName,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      user.major,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    //progress container

                    Container(
                      height: 100,
                      width: 350,
                      decoration: ShapeDecoration(
                        color: const Color(0xEAF6EEEE),
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
                              children: [
                                Container(
                                  height: 58,
                                  width: 110,
                                  decoration: const BoxDecoration(
                                    color: Color(0x129F6EEEE),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        level.toString(),
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      const Text(
                                        "Level",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xFF6F7665)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 58,
                                  width: 110,
                                  decoration: const BoxDecoration(
                                    color: Color(0x129F6EEEE),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        timerData != null
                                            ? (timerData['sumOfFocusTime'] !=
                                                    null
                                                ? (timerData['sumOfFocusTime'] /
                                                            3600)
                                                        .toStringAsFixed(1) +
                                                    'H'
                                                : '0.0H')
                                            : '0.0H',
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      const Text(
                                        "Time",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xFF6F7665)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 58,
                                  width: 110,
                                  decoration: const BoxDecoration(
                                    color: Color(0x129F6EEEE),
                                  ),
                                  child: const Column(
                                    children: [
                                      Text(
                                        "4",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "Tutored",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xFF6F7665),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                        Text(
                          "Total Statistics",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // statistic containers

                    Container(
                      width: 350,
                      height: 60,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFCFCFC),
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
                          const Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              "Friends",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: Text(
                              widget.user.friends.length.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // statistic containers
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 350,
                      height: 60,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFCFCFC),
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
                          const Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              "Points",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: Text(
                              points.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // statistic containers

                    Container(
                      width: 350,
                      height: 60,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFCFCFC),
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              "Rating",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 30),
                            child: Text(
                              "3.7",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    GestureDetector(
                      onTap: isFriend ? removeFriend : addFriend,
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF29F6D2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
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
                              fontSize: 25,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
