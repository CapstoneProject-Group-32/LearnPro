import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:flutter_application_1/Screens/search_user_screen.dart';
import 'package:flutter_application_1/Widgets/navigation_bar.dart';

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
//       UserModel currentUser =
//           UserModel.fromJSON(userSnapshot.data() as Map<String, dynamic>);
//       List<UserModel> fetchedFriends = [];
//       for (String friendUid in currentUser.friends) {
//         DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(friendUid)
//             .get();
//         UserModel friend =
//             UserModel.fromJSON(friendSnapshot.data() as Map<String, dynamic>);
//         fetchedFriends.add(friend);
//       }
//       setState(() {
//         friends = fetchedFriends;
//         isLoading = false;
//       });
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
//     await _firestore
//         .collection('users')
//         .where("userName", isEqualTo: _search.text)
//         .get()
//         .then((value) {
//       if (value.docs.isNotEmpty) {
//         setState(() {
//           userMap = value.docs[0].data();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = "Invalid user";
//           isLoading = false;
//         });
//       }
//     });
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
//                               child: const Center(child: Text("People")),
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
//                               child: const Center(child: Text("Groups")),
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
//                               child: const Center(child: Text("Tutored You")),
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
//                         child: _studybuddyCard(
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
//                       ),
//                     // Display friends' details
//                     ...friends.map((friend) {
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: _studybuddyCard(
//                           NetworkImage(friend.profilePic),
//                           friend.userName,
//                           friend.major,
//                           () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     SearchUserScreen(user: friend),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }

// //study buddie tution card method

// Widget _studybuddyCard(
//   ImageProvider<Object> userImage,
//   String userName,
//   String userLevel,
//   Function() onTap,
// ) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       width: 370,
//       height: 100,
//       decoration: ShapeDecoration(
//         color: const Color(0xEAF6EEEE),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         shadows: const [
//           BoxShadow(
//             color: Color(0x3F000000),
//             blurRadius: 4,
//             offset: Offset(0, 4),
//             spreadRadius: 0,
//           )
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 15),
//               child: Container(
//                 margin: const EdgeInsets.all(5),
//                 width: 80,
//                 height: 80,
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
//           const SizedBox(
//             width: 16,
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 userName,
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontFamily: 'Work Sans',
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(
//                 height: 2,
//               ),
//               Text(
//                 userLevel,
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontFamily: 'Work Sans',
//                   fontWeight: FontWeight.w200,
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 width: 132,
//                 height: 21,
//                 decoration: ShapeDecoration(
//                   color: const Color(0xFF74FE8A),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   shadows: const [
//                     BoxShadow(
//                       color: Color(0x3F000000),
//                       blurRadius: 4,
//                       offset: Offset(0, 4),
//                       spreadRadius: 0,
//                     )
//                   ],
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'request tution',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontFamily: 'Work Sans',
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(
//             width: 16,
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 width: 70,
//                 height: 20,
//                 decoration: ShapeDecoration(
//                   color: const Color(0xFFFCFCFC),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   shadows: const [
//                     BoxShadow(
//                       color: Color(0x3F000000),
//                       blurRadius: 4,
//                       offset: Offset(0, 4),
//                       spreadRadius: 0,
//                     )
//                   ],
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'Add',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontFamily: 'Work Sans',
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 15.55,
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }

class StudyBuddies extends StatefulWidget {
  const StudyBuddies({super.key});

  @override
  State<StudyBuddies> createState() => _StudyBuddiesState();
}

class _StudyBuddiesState extends State<StudyBuddies> {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  String? errorMessage;
  List<UserModel> friends = [];

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

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
      UserModel currentUser =
          UserModel.fromJSON(userSnapshot.data() as Map<String, dynamic>);
      List<UserModel> fetchedFriends = [];
      for (String friendUid in currentUser.friends) {
        DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(friendUid)
            .get();
        UserModel friend =
            UserModel.fromJSON(friendSnapshot.data() as Map<String, dynamic>);
        fetchedFriends.add(friend);
      }
      setState(() {
        friends = fetchedFriends;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load friends: $e";
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
    await _firestore
        .collection('users')
        .where("userName", isEqualTo: _search.text)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          userMap = value.docs[0].data();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Invalid user";
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(
                child: Container(
                  height: 20,
                  width: 20,
                  child: const CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
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
                            child: const Icon(
                              Icons.search,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: const Color(0xFF74FE8A),
                              ),
                              child: const Center(child: Text("People")),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: const Color(0xFFD9D9D9),
                              ),
                              child: const Center(child: Text("Groups")),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: const Color(0xFFD9D9D9),
                              ),
                              child: const Center(child: Text("Tutored You")),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                        child: _studybuddyCard(
                          NetworkImage(userMap!['profilePic']),
                          userMap!['userName'],
                          userMap!['major'],
                          () {
                            UserModel user = UserModel.fromJSON(userMap!);
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
                    else
                      ...friends.map((friend) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _studybuddyCard(
                            NetworkImage(friend.profilePic),
                            friend.userName,
                            friend.major,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SearchUserScreen(user: friend),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
      ),
    );
  }
}

//study buddie tution card method

Widget _studybuddyCard(
  ImageProvider<Object> userImage,
  String userName,
  String userLevel,
  Function() onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                margin: const EdgeInsets.all(5),
                width: 80,
                height: 80,
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
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                userLevel,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 132,
                height: 21,
                decoration: ShapeDecoration(
                  color: const Color(0xFF74FE8A),
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
                    'request tution',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 70,
                height: 20,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFCFCFC),
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
                    'Add',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15.55,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
