// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_application_1/Models/usermodel.dart';
// import 'package:flutter_application_1/Screens/Community/request_tution.dart';
// import 'package:flutter_application_1/Screens/Community/search_user_screen.dart';
// import 'package:flutter_application_1/Widgets/navigation_bar.dart';

// class StudyBuddies extends StatefulWidget {
//   const StudyBuddies({super.key});

//   @override
//   State<StudyBuddies> createState() => _StudyBuddiesState();
// }

// class _StudyBuddiesState extends State<StudyBuddies> {
//   Map<String, dynamic>? userMap;
//   bool isLoading = false;
//   final TextEditingController _search = TextEditingController();
//   String? errorMessage;
//   List<UserModel> friends = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchFriends();
//   }

//   void fetchFriends() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       final userUid = FirebaseAuth.instance.currentUser!.uid;
//       DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userUid)
//           .get();
//       if (userSnapshot.exists) {
//         Map<String, dynamic> userData =
//             userSnapshot.data() as Map<String, dynamic>;
//         UserModel currentUser = UserModel.fromJSON(userData);
//         List<UserModel> fetchedFriends = [];
//         for (String friendUid in currentUser.friends) {
//           DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance
//               .collection('users')
//               .doc(friendUid)
//               .get();
//           if (friendSnapshot.exists) {
//             Map<String, dynamic> friendData =
//                 friendSnapshot.data() as Map<String, dynamic>;
//             UserModel friend = UserModel.fromJSON(friendData);
//             fetchedFriends.add(friend);
//           }
//         }
//         setState(() {
//           friends = fetchedFriends;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = "User document does not exist";
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = "Failed to load friends: $e";
//         isLoading = false;
//       });
//     }
//   }

//   void onSearch() async {
//     FirebaseFirestore _firestore = FirebaseFirestore.instance;

//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//       userMap = null;
//     });
//     try {
//       QuerySnapshot searchResult = await _firestore
//           .collection('users')
//           .where("userName", isEqualTo: _search.text)
//           .get();

//       if (searchResult.docs.isNotEmpty) {
//         Map<String, dynamic> userData =
//             searchResult.docs[0].data() as Map<String, dynamic>;
//         setState(() {
//           userMap = userData;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = "Invalid user";
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = "Error searching user: $e";
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: isLoading
//             ? Center(
//                 child: Container(
//                   height: 20,
//                   width: 20,
//                   child: const CircularProgressIndicator(),
//                 ),
//               )
//             : SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const NavigationBarBottom(),
//                             ),
//                           );
//                         },
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Icon(
//                               Icons.arrow_back_ios_new_rounded,
//                               size: 28,
//                               color: Colors.black,
//                             ),
//                             SizedBox(
//                               width: 8,
//                             ),
//                             Text(
//                               "Student Community",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 30,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: TextField(
//                         controller: _search,
//                         decoration: InputDecoration(
//                           hintText: 'Search...',
//                           prefixIcon: GestureDetector(
//                             onTap: () {
//                               onSearch();
//                             },
//                             child: const Icon(
//                               Icons.search,
//                             ),
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(40),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       color: Colors.white,
//                       height: 50,
//                       width: double.infinity,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               width: 100,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(40),
//                                 color: const Color(0xFF74FE8A),
//                               ),
//                               child: const Center(
//                                 child: Text("People"),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               width: 100,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(40),
//                                 color: const Color(0xFFD9D9D9),
//                               ),
//                               child: const Center(
//                                 child: Text("Groups"),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               width: 100,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(40),
//                                 color: const Color(0xFFD9D9D9),
//                               ),
//                               child: const Center(
//                                 child: Text("Tutored You"),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     if (errorMessage != null)
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           errorMessage!,
//                           style: const TextStyle(
//                             color: Colors.red,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     if (userMap != null)
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: _studybuddyCardBeforeAddFriend(
//                           NetworkImage(userMap!['profilePic']),
//                           userMap!['userName'],
//                           userMap!['major'],
//                           () {
//                             UserModel user = UserModel.fromJSON(userMap!);
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     SearchUserScreen(user: user),
//                               ),
//                             );
//                           },
//                         ),
//                       )
//                     else if (friends.isNotEmpty)
//                       ...friends.map(
//                         (friend) {
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: _studybuddyCardAfterAddFriend(
//                               NetworkImage(friend.profilePic),
//                               friend.userName,
//                               friend.major,
//                               () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         SearchUserScreen(user: friend),
//                                   ),
//                                 );
//                               },
//                               () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => RequestTuitionScreen(
//                                       friendUid: friend.uid,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                       ).toList()
//                     else
//                       const Center(
//                         child: Text("No friends found."),
//                       ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }

// // Study Buddy card before adding friend
// Widget _studybuddyCardBeforeAddFriend(
//   ImageProvider<Object> userImage,
//   String userName,
//   String userLevel,
//   Function() onTapView,
// ) {
//   return Container(
//     width: 370,
//     height: 100,
//     decoration: ShapeDecoration(
//       color: const Color(0xEAF6EEEE),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
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
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Center(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Container(
//                 margin: const EdgeInsets.all(5),
//                 width: 75,
//                 height: 75,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0x3F000000),
//                       blurRadius: 4,
//                       offset: Offset(0, 4),
//                       spreadRadius: 0,
//                     ),
//                   ],
//                 ),
//                 child: CircleAvatar(
//                   backgroundImage: userImage,
//                   radius: 40,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           width: 15,
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               userName,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               userLevel,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(
//           width: 25,
//         ),
//         GestureDetector(
//           onTap: onTapView,
//           child: Container(
//             width: 125,
//             height: 30,
//             decoration: ShapeDecoration(
//               color: const Color(0xFF74FE8A),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(45),
//               ),
//               shadows: const [
//                 BoxShadow(
//                   color: Color(0x3F000000),
//                   blurRadius: 4,
//                   offset: Offset(0, 4),
//                   spreadRadius: 0,
//                 )
//               ],
//             ),
//             child: const Center(
//               child: Text(
//                 'View',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontFamily: 'Work Sans',
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // Study Buddy card after adding friend
// Widget _studybuddyCardAfterAddFriend(
//   ImageProvider<Object> userImage,
//   String userName,
//   String userLevel,
//   Function() onTapView,
//   Function() onTapRequestTuition,
// ) {
//   return Container(
//     width: 370,
//     height: 100,
//     decoration: ShapeDecoration(
//       color: const Color(0xEAF6EEEE),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
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
//     child: Padding(
//       padding: const EdgeInsets.all(4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Center(
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Container(
//                   margin: const EdgeInsets.all(5),
//                   width: 75,
//                   height: 75,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color(0x3F000000),
//                         blurRadius: 4,
//                         offset: Offset(0, 4),
//                         spreadRadius: 0,
//                       ),
//                     ],
//                   ),
//                   child: CircleAvatar(
//                     backgroundImage: userImage,
//                     radius: 40,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 15,
//           ),
//           Flexible(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   userName,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   userLevel,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             width: 25,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 GestureDetector(
//                   onTap: onTapView,
//                   child: Container(
//                     width: 125,
//                     height: 30,
//                     decoration: ShapeDecoration(
//                       color: const Color(0xFF74FE8A),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(45),
//                       ),
//                       shadows: const [
//                         BoxShadow(
//                           color: Color(0x3F000000),
//                           blurRadius: 4,
//                           offset: Offset(0, 4),
//                           spreadRadius: 0,
//                         )
//                       ],
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'View',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 16,
//                           fontFamily: 'Work Sans',
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: onTapRequestTuition,
//                   child: Container(
//                     width: 125,
//                     height: 30,
//                     decoration: ShapeDecoration(
//                       color: const Color(0xFF74FE8A),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(45),
//                       ),
//                       shadows: const [
//                         BoxShadow(
//                           color: Color(0x3F000000),
//                           blurRadius: 4,
//                           offset: Offset(0, 4),
//                           spreadRadius: 0,
//                         )
//                       ],
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Request Tution',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 16,
//                           fontFamily: 'Work Sans',
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:flutter_application_1/Screens/Community/request_tution.dart';
import 'package:flutter_application_1/Screens/Community/search_user_screen.dart';
import 'package:flutter_application_1/Widgets/navigation_bar.dart';

class StudyBuddies extends StatefulWidget {
  const StudyBuddies({super.key});

  @override
  State<StudyBuddies> createState() => _StudyBuddiesState();
}

class _StudyBuddiesState extends State<StudyBuddies>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  String? errorMessage;
  List<UserModel> friends = [];
  List<UserModel> tutoredUsers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchFriends();
    fetchTutoredUsers();
  }

  // void fetchFriends() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     final userUid = FirebaseAuth.instance.currentUser!.uid;
  //     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userUid)
  //         .get();
  //     if (userSnapshot.exists) {
  //       Map<String, dynamic> userData =
  //           userSnapshot.data() as Map<String, dynamic>;
  //       UserModel currentUser = UserModel.fromJSON(userData);
  //       List<UserModel> fetchedFriends = [];
  //       for (String friendUid in currentUser.friends) {
  //         DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(friendUid)
  //             .get();
  //         if (friendSnapshot.exists) {
  //           Map<String, dynamic> friendData =
  //               friendSnapshot.data() as Map<String, dynamic>;
  //           UserModel friend = UserModel.fromJSON(friendData);
  //           fetchedFriends.add(friend);
  //         }
  //       }
  //       setState(() {
  //         friends = fetchedFriends;
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         errorMessage = "User document does not exist";
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = "Failed to load friends: $e";
  //       isLoading = false;
  //     });
  //   }
  // }

  void fetchFriends() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userUid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        UserModel currentUser = UserModel.fromJSON(userData);
        List<UserModel> fetchedFriends = [];
        for (String friendUid in currentUser.friends) {
          DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(friendUid)
              .get();
          if (friendSnapshot.exists) {
            Map<String, dynamic> friendData =
                friendSnapshot.data() as Map<String, dynamic>;
            UserModel friend = UserModel.fromJSON(friendData);
            fetchedFriends.add(friend);
          }
        }
        setState(() {
          friends = fetchedFriends;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "User document does not exist";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load friends: $e";
        isLoading = false;
      });
    }
  }

  void fetchTutoredUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userUid = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot tutoredSnapshot = await FirebaseFirestore.instance
          .collection('tutored')
          .where('tutoredUserUid', isEqualTo: userUid)
          .get();

      List<UserModel> fetchedTutoredUsers = [];
      for (QueryDocumentSnapshot doc in tutoredSnapshot.docs) {
        String tutorUid = doc['tutorUserUid'];
        DocumentSnapshot tutorSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(tutorUid)
            .get();
        if (tutorSnapshot.exists) {
          Map<String, dynamic> tutorData =
              tutorSnapshot.data() as Map<String, dynamic>;
          UserModel tutor = UserModel.fromJSON(tutorData);
          fetchedTutoredUsers.add(tutor);
        }
      }
      setState(() {
        tutoredUsers = fetchedTutoredUsers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load tutored users: $e";
        isLoading = false;
      });
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
      errorMessage = null;
      userMap = null;
    });
    try {
      QuerySnapshot searchResult = await _firestore
          .collection('users')
          .where("userName", isEqualTo: _search.text)
          .get();

      if (searchResult.docs.isNotEmpty) {
        Map<String, dynamic> userData =
            searchResult.docs[0].data() as Map<String, dynamic>;
        setState(() {
          userMap = userData;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Invalid user";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error searching user: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationBarBottom(),
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
                  width: 10,
                ),
                Text(
                  "Student Community",
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
        body: isLoading
            ? Center(
                child: Container(
                  height: 20,
                  width: 20,
                  child: const CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: GestureDetector(
                          onTap: () {
                            onSearch();
                          },
                          child: const Icon(Icons.search),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xFF00FF00),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    tabs: [
                      _buildTab(
                        'People',
                        0,
                      ),
                      _buildTab(
                        'Groups',
                        1,
                      ),
                      _buildTab(
                        'Tutored You',
                        2,
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              if (errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              if (userMap != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _studybuddyCardBeforeAddFriend(
                                    NetworkImage(userMap!['profilePic']),
                                    userMap!['userName'],
                                    userMap!['major'],
                                    () {
                                      UserModel user =
                                          UserModel.fromJSON(userMap!);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SearchUserScreen(user: user),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              else if (friends.isNotEmpty)
                                ...friends.map(
                                  (friend) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _studybuddyCardAfterAddFriend(
                                        NetworkImage(friend.profilePic),
                                        friend.userName,
                                        friend.major,
                                        () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchUserScreen(
                                                      user: friend),
                                            ),
                                          );
                                        },
                                        () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RequestTuitionScreen(
                                                friendUid: friend.uid,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ).toList()
                              else
                                const Center(
                                  child: Text("No friends found."),
                                ),
                            ],
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Groups Section - Under Development',
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: tutoredUsers.isNotEmpty
                                ? tutoredUsers.map((tutor) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _studybuddyCardAfterAddFriend(
                                        NetworkImage(tutor.profilePic),
                                        tutor.userName,
                                        tutor.major,
                                        () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchUserScreen(user: tutor),
                                            ),
                                          );
                                        },
                                        () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RequestTuitionScreen(
                                                friendUid: tutor.uid,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }).toList()
                                : [
                                    const Center(
                                      child: Text("No tutors found."),
                                    ),
                                  ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

//Tab bar widget

Widget _buildTab(String text, int tabIndex) {
  return Tab(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        // color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// Study Buddy card before adding friend
Widget _studybuddyCardBeforeAddFriend(
  ImageProvider<Object> userImage,
  String userName,
  String userLevel,
  Function() onTapView,
) {
  return Container(
    width: 370,
    height: 100,
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
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: Center(
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
                  backgroundImage: userImage,
                  radius: 40,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              userLevel,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 25,
        ),
        GestureDetector(
          onTap: onTapView,
          child: Container(
            width: 125,
            height: 30,
            decoration: ShapeDecoration(
              color: const Color(0xFF74FE8A),
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
                'View',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// Study Buddy card after adding friend
Widget _studybuddyCardAfterAddFriend(
  ImageProvider<Object> userImage,
  String userName,
  String userLevel,
  Function() onTapView,
  Function() onTapRequestTuition,
) {
  return Container(
    width: 370,
    height: 100,
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
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Center(
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
                    backgroundImage: userImage,
                    radius: 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userLevel,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
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
                  onTap: onTapView,
                  child: Container(
                    width: 125,
                    height: 30,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF74FE8A),
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
                        'View',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Work Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onTapRequestTuition,
                  child: Container(
                    width: 125,
                    height: 30,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF74FE8A),
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
                        'Request Tution',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
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
        ],
      ),
    ),
  );
}
