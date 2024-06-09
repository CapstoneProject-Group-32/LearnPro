// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Models/usermodel.dart';
// import 'package:flutter_application_1/Screens/Authentication/authenticate.dart';
// import 'package:flutter_application_1/Screens/Profile/notification_screen.dart';
// import 'package:flutter_application_1/Services/auth_firebase.dart';
// import 'package:flutter_application_1/Widgets/navigation_bar.dart';

// class UserProfile extends StatefulWidget {
//   const UserProfile({super.key});

//   @override
//   State<UserProfile> createState() => _UserProfileState();
// }

// class _UserProfileState extends State<UserProfile> {
//   final currentUser = FirebaseAuth.instance.currentUser!;

//   int calculatePoints(double sumOfFocusTime) {
//     if (sumOfFocusTime >= 4) return 7500;
//     if (sumOfFocusTime >= 3) return 3500;
//     if (sumOfFocusTime >= 2) return 1500;
//     if (sumOfFocusTime >= 1) return 500;
//     return 0;
//   }

//   int calculateLevel(int points) {
//     if (points >= 8000) return 4;
//     if (points >= 4000) return 3;
//     if (points >= 2000) return 2;
//     if (points >= 500) return 1;
//     return 0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               // Profile back button
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const NavigationBarBottom(),
//                     ),
//                   );
//                 },
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Icon(
//                       Icons.arrow_back_ios_new_rounded,
//                       size: 28,
//                       color: Colors.black,
//                     ),
//                     SizedBox(
//                       width: 8,
//                     ),
//                     Text(
//                       "Profile",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 30,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Notification button
//               IconButton(
//                 icon: const Icon(
//                   Icons.notifications,
//                   color: Colors.black,
//                   size: 35,
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       CupertinoPageRoute(
//                           builder: (BuildContext context) =>
//                               const NotificationScreen()));
//                 },
//               ),
//             ],
//           ),
//         ),
//         body: StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("users")
//               .doc(currentUser.uid)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               final userData = snapshot.data!.data() as Map<String, dynamic>;
//               final timerData = userData['timer'];

//               UserModel user = UserModel.fromJSON(userData);

//               double sumOfFocusTime =
//                   timerData != null && timerData['sumOfFocusTime'] != null
//                       ? timerData['sumOfFocusTime'] / 3600
//                       : 0.0;

//               int points = calculatePoints(sumOfFocusTime);
//               int level = calculateLevel(points);

//               return Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       height: 100,
//                       width: 100,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(0x3F000000),
//                             blurRadius: 4,
//                             offset: Offset(0, 4),
//                             spreadRadius: 0,
//                           ),
//                         ],
//                       ),
//                       child: CircleAvatar(
//                         backgroundImage: NetworkImage(user.profilePic),
//                         radius: 50,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       user.userName,
//                       style: const TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Text(
//                       user.major,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),

//                     // Progress container

//                     Container(
//                       height: 100,
//                       width: 350,
//                       decoration: ShapeDecoration(
//                         color: const Color(0xEAF6EEEE),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         shadows: const [
//                           BoxShadow(
//                             color: Color(0x3F000000),
//                             blurRadius: 4,
//                             offset: Offset(0, 4),
//                             spreadRadius: 0,
//                           )
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   height: 58,
//                                   width: 110,
//                                   decoration: const BoxDecoration(
//                                     color: Color(0x129F6EEEE),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         level.toString(),
//                                         style: const TextStyle(
//                                             fontSize: 25,
//                                             fontWeight: FontWeight.w400,
//                                             color: Colors.black),
//                                       ),
//                                       const Text(
//                                         "Level",
//                                         style: TextStyle(
//                                             fontSize: 25,
//                                             fontWeight: FontWeight.w300,
//                                             color: Color(0xFF6F7665)),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   height: 58,
//                                   width: 110,
//                                   decoration: const BoxDecoration(
//                                     color: Color(0x129F6EEEE),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         "${sumOfFocusTime.toStringAsFixed(1)}H",
//                                         style: const TextStyle(
//                                             fontSize: 25,
//                                             fontWeight: FontWeight.w400,
//                                             color: Colors.black),
//                                       ),
//                                       const Text(
//                                         "Time",
//                                         style: TextStyle(
//                                             fontSize: 25,
//                                             fontWeight: FontWeight.w300,
//                                             color: Color(0xFF6F7665)),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   height: 58,
//                                   width: 110,
//                                   decoration: const BoxDecoration(
//                                     color: Color(0x129F6EEEE),
//                                   ),
//                                   child: const Column(
//                                     children: [
//                                       Text(
//                                         "4",
//                                         style: TextStyle(
//                                             fontSize: 25,
//                                             fontWeight: FontWeight.w400,
//                                             color: Colors.black),
//                                       ),
//                                       Text(
//                                         "Tutored",
//                                         style: TextStyle(
//                                           fontSize: 25,
//                                           fontWeight: FontWeight.w300,
//                                           color: Color(0xFF6F7665),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     const Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           width: 15,
//                         ),
//                         Text(
//                           "Total Statistics",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     // Statistic containers
//                     Container(
//                       width: 350,
//                       height: 60,
//                       decoration: ShapeDecoration(
//                         color: const Color(0xFFFCFCFC),
//                         shape: RoundedRectangleBorder(
//                           side: const BorderSide(width: 1),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         shadows: const [
//                           BoxShadow(
//                             color: Color(0x3F000000),
//                             blurRadius: 4,
//                             offset: Offset(0, 4),
//                             spreadRadius: 0,
//                           )
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.only(left: 30),
//                             child: Text(
//                               "Friends",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 30),
//                             child: Text(
//                               user.friends.length.toString(),
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       width: 350,
//                       height: 60,
//                       decoration: ShapeDecoration(
//                         color: const Color(0xFFFCFCFC),
//                         shape: RoundedRectangleBorder(
//                           side: const BorderSide(width: 1),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         shadows: const [
//                           BoxShadow(
//                             color: Color(0x3F000000),
//                             blurRadius: 4,
//                             offset: Offset(0, 4),
//                             spreadRadius: 0,
//                           )
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.only(left: 30),
//                             child: Text(
//                               "Points",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 30),
//                             child: Text(
//                               points.toString(),
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     // Statistic containers
//                     Container(
//                       width: 350,
//                       height: 60,
//                       decoration: ShapeDecoration(
//                         color: const Color(0xFFFCFCFC),
//                         shape: RoundedRectangleBorder(
//                           side: const BorderSide(width: 1),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         shadows: const [
//                           BoxShadow(
//                             color: Color(0x3F000000),
//                             blurRadius: 4,
//                             offset: Offset(0, 4),
//                             spreadRadius: 0,
//                           )
//                         ],
//                       ),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(left: 30),
//                             child: Text(
//                               "Rating",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(right: 30),
//                             child: Text(
//                               "3.7",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     // Log out button
//                     GestureDetector(
//                       onTap: () async {
//                         await AuthServices().logOut();
//                         Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(
//                             builder: (context) => const Authenticate(),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         width: 200,
//                         height: 50,
//                         decoration: ShapeDecoration(
//                           color: const Color(0xFF29F6D2),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           shadows: const [
//                             BoxShadow(
//                               color: Color(0x3F000000),
//                               blurRadius: 4,
//                               offset: Offset(0, 4),
//                               spreadRadius: 0,
//                             )
//                           ],
//                         ),
//                         child: const Center(
//                           child: Text(
//                             'Log Out',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 25,
//                               fontFamily: 'Work Sans',
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text('Error${snapshot.error}'),
//               );
//             }
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:flutter_application_1/Screens/Authentication/authenticate.dart';
import 'package:flutter_application_1/Screens/Profile/notification_screen.dart';
import 'package:flutter_application_1/Services/auth_firebase.dart';
import 'package:flutter_application_1/Widgets/navigation_bar.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!;

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavigationBarBottom(),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const NotificationScreen()));
                },
              ),
            ],
          ),
        ),
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
                              const SizedBox(height: 15),
                              Container(
                                width: constraints.maxWidth * 0.9,
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
                              const SizedBox(height: 30),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Total Statistics",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildStatContainer(
                                  "Friends", user.friends.length.toString()),
                              const SizedBox(height: 20),
                              _buildStatContainer("Points", points.toString()),
                              const SizedBox(height: 20),
                              _buildStatContainer("Rating", "3.7"),
                              const SizedBox(height: 20),
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
                                  height: 50,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF29F6D2),
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
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0x129F6EEEE),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF6F7665)),
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
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 20,
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
                fontSize: 20,
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
