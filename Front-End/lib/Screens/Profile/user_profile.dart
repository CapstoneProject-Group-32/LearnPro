import 'package:LearnPro/tutoring_system/level_and_points.dart';
import 'package:LearnPro/tutoring_system/user_rating_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:LearnPro/Models/usermodel.dart';
import 'package:LearnPro/Screens/Authentication/authenticate.dart';

import 'package:LearnPro/Screens/Profile/edit_profile.dart';
import 'package:LearnPro/Services/auth_firebase.dart';
import 'package:LearnPro/Widgets/navigation_bar.dart';

import '../../tutoring_system/feedbacks_page.dart';
import '../../tutoring_system/records.dart';
import '../../tutoring_system/tutored_count.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationBarBottom()),
        );
        return false; // Prevent the default back button behavior
      },
      child: SafeArea(
        child: Scaffold(
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
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfile(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit_note_sharp,
                  size: 26,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(currentUser.uid)
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

                // int points = calculatePoints(sumOfFocusTime);
                // int level = calculateLevel(points);

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
                                const SizedBox(height: 10),
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
                                        NetworkImage(user.profilePic),
                                    radius: 50,
                                  ),
                                ),
                                const SizedBox(height: 10),
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
                                const SizedBox(height: 15),

                                //prograss container

                                Container(
                                  width: constraints.maxWidth * 0.9,
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // _buildStatColumn(
                                            //     level.toString(), "Level"),
                                            _buildStatColumnLevel('Level'),
                                            _buildStatColumn(
                                                "${sumOfFocusTime.toStringAsFixed(1)}H",
                                                "Time"),
                                            _buildStatColumnTutored("Tutored"),
                                            // _buildStatColumn("4", "Tutored"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                const Align(
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
                                const SizedBox(height: 10),
                                _buildStatContainer(
                                    "Friends", user.friends.length.toString()),
                                const SizedBox(height: 20),
                                _buildStatContainerNewPoints('Points'),
                                // _buildStatContainer(
                                //     "Points", points.toString()),
                                const SizedBox(height: 20),
                                //  _buildStatContainer("Rating", "3.7"),
                                _buildStatContainerNewRating("Rating"),

                                const SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    newContainer(
                                        'Records',
                                        (context) =>
                                            Records(userID: currentUser.uid)),
                                    newContainer(
                                        'FeedBacks',
                                        (context) => FeedbacksPage(
                                            userId: currentUser.uid)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),

                                GestureDetector(
                                  onTap: () async {
                                    await AuthServices().logOut();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Authenticate(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: constraints.maxWidth * 0.5,
                                    height: 40,
                                    decoration: ShapeDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                                    child: const Center(
                                      child: Text(
                                        'Log Out',
                                        style: TextStyle(
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
        ),
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

  Widget newContainer(String title, WidgetBuilder builder) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: builder,
        ),
      ),
      child: Container(
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
          width: 2.2 * MediaQuery.of(context).size.width / 5,
          height: 60,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
                const Icon(
                  Icons.chevron_right_outlined,
                  color: Colors.black,
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildStatContainerNewRating(String label) {
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
            child: UserRatingWidget(userId: currentUser.uid)
                .buildAverageRatingWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumnTutored(
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
            TutoredCount(
              userId: currentUser.uid,
              fontSize: 22,
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

  Widget _buildStatColumnLevel(
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
            UserStats(
              userId: currentUser.uid,
              choice: 'l',
              fontSize: 24,
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

  Widget _buildStatContainerNewPoints(String label) {
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
              child: UserStats(
                choice: 'p',
                userId: currentUser.uid,
                fontSize: 17,
              )),
        ],
      ),
    );
  }
}
