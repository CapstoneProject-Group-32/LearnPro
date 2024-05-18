import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:flutter_application_1/Screens/Community/request_tution.dart';

import 'package:flutter_application_1/Screens/Timer/timer_page.dart';

import 'package:flutter_application_1/Screens/Community/find_studybuddies.dart';

import 'package:flutter_application_1/Screens/library.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  // final String uid;
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  Widget build(BuildContext context) {
//date

    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(now);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:

//getting stored user data

            StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              UserModel user = UserModel.fromJSON(userData);
              List<String> friends =
                  List<String>.from(userData['friends'] ?? []);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
// First container

                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDFFCE4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
// Name and Date

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, left: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
//Name
                                              Text(
                                                user.userName,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30,
                                                    color: Colors.black),
                                              ),

//date
                                              Text(
                                                formattedDate,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(
                                          width: 100,
                                        ),

//Notification

                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.notifications,
                                              size: 30,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 30,
                                  ),

// Today progress container

                                  Container(
                                    height: 150,
                                    width: 350,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF82C0CC),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Today Progress",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              _progressContainer(
                                                "4h",
                                                "Focus Time",
                                              ),
                                              _progressContainer(
                                                "300",
                                                "Points",
                                              ),
                                              _progressContainer(
                                                "3",
                                                "Tutored",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

// Search bar(design only)

                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

//Daily moto

                        Container(
                          height: 250,
                          width: 350,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDFFCE4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Flexible(
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    "\"The journey of a thousand miles begins with a single step.Take that step, keep studying, and you'll eventually reach your destination.\"",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              Image.asset(
                                "assets/boy.png",
                                height: 150,
                                width: 150,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

//Icons

                        Container(
                          width: 400,
                          height: 125,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              _iconMethod(
                                context,
                                const Library(),
                                const AssetImage('assets/task.png'),
                                'Your Notes',
                              ),
                              _iconMethod(
                                context,
                                const StudyBuddies(),
                                const AssetImage('assets/cooperation.png'),
                                'Request Tutoring',
                              ),
                              _iconMethod(
                                context,
                                const TimerScreen(),
                                const AssetImage('assets/reading.png'),
                                'Focus',
                              ),
                              _iconMethod(
                                context,
                                const StudyBuddies(),
                                const AssetImage('assets/notebook.png'),
                                'Study Plan',
                              ),
                            ],
                          ),
                        ),

//Today Goals subheading by calling subtopic method

                        _subtopics('Today Goals'),

//Join Groups subheading by calling subtopic method

                        _subtopics('Join Groups'),

                        const SizedBox(
                          height: 18,
                        ),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 25,
                              ),
                              _groupContainer(
                                context,
                                const StudyBuddies(),
                                const AssetImage('assets/google.png'),
                                'Java Programming',
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              _groupContainer(
                                context,
                                const StudyBuddies(),
                                const AssetImage('assets/google.png'),
                                'Java Programming',
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              _groupContainer(
                                context,
                                const StudyBuddies(),
                                const AssetImage('assets/google.png'),
                                'Java Programming',
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              _groupContainer(
                                context,
                                const StudyBuddies(),
                                const AssetImage('assets/google.png'),
                                'Java Programming',
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              _groupContainer(
                                context,
                                const StudyBuddies(),
                                const AssetImage('assets/google.png'),
                                'Java Programming',
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

// View Button method calling

                        _viewallButton(),

                        const SizedBox(
                          height: 20,
                        ),

//Your Freinds subheading by calling subtopic method

                        _subtopics('Your Freinds'),

                        const SizedBox(
                          height: 10,
                        ),
//Calling buildFreindsList method

                        _buildFriendsList(friends),
                        const SizedBox(
                          height: 27,
                        ),

// View Button method calling

                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StudyBuddies(),
                                ),
                              );
                            },
                            child: _viewallButton()),

                        const SizedBox(
                          height: 20,
                        ),
                      ],
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
//progress Container Method

  Widget _progressContainer(String value, String label) {
    return Container(
      height: 58,
      width: 110,
      decoration: const BoxDecoration(
        color: Color(0xFF82C0CC),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
              color: Color(0xFF6F7665),
            ),
          ),
        ],
      ),
    );
  }

//Icon Method

  Widget _iconMethod(BuildContext context, Widget linkedPage,
      ImageProvider<Object> iconImage, String imageTopic) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => linkedPage,
          ),
        );
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Image(
              image: iconImage,
              height: 50,
              width: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              imageTopic,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

//Subtopic Method

  Widget _subtopics(String subtopic) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtopic,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

//Group Container Method

  Widget _groupContainer(BuildContext context, Widget linkedPage,
      ImageProvider<Object> groupImage, String groupTopic) {
    return Container(
      width: 240,
      height: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            width: 240,
            height: 145,
            decoration: const BoxDecoration(
              color: Color(0xFFF4F4F4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Image(
              image: groupImage,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: 240,
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFFF4F4F4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    groupTopic,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => linkedPage,
                      ),
                    );
                  },
                  child: Container(
                    width: 127,
                    height: 27.56,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF7BE7FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
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
                        'View',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Work Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//View All Button

  Widget _viewallButton() {
    return Container(
      width: 275,
      height: 40,
      decoration: ShapeDecoration(
        color: const Color(0xFFD9D9D9),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Center(
        child: Text(
          'View All',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Work Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

//friend list method

  Widget _buildFriendsList(List<String> friends) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 25), // Add space at the beginning
          for (int i = 0; i < friends.length; i++) ...[
            _buildFriend(friends[i]),
            const SizedBox(width: 25), // Add space between friendContainer
          ],
          const SizedBox(width: 25), // Add space at the end
        ],
      ),
    );
  }

  //gettinf friends details from fire store

  Widget _buildFriend(String friendId) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection("users").doc(friendId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final friendData = snapshot.data!.data() as Map<String, dynamic>;
          String userName = friendData['userName'];
          String major = friendData['major'];
          String profilePic = friendData['profilePic'];

          return _friendContainer(
            context,
            const RequestTutionScreen(),
            NetworkImage(profilePic),
            userName,
            major,
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading friend');
        }
        return const CircularProgressIndicator();
      },
    );
  }

//Freind container methods

  Widget _friendContainer(BuildContext context, Widget linkedPage,
      ImageProvider<Object> friendImage, String friendname, String frindLevel) {
    return Container(
      width: 200,
      height: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Container(
          height: 230,
          width: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.values[2],
            children: [
              ClipOval(
                child: Image(
                  image: friendImage,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                friendname,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                frindLevel,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(
                height: 11,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => linkedPage),
                  );
                },
                child: Container(
                  width: 130,
                  height: 28,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF7BE7FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
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
                      'Request Tution',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Work Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
