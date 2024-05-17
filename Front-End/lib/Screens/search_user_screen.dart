// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Screens/find_studybuddies.dart';
// import 'package:flutter_application_1/Models/usermodel.dart';

// class SearchUserScreen extends StatefulWidget {
//   final UserModel user;

//   const SearchUserScreen({super.key, required this.user});

//   @override
//   State<SearchUserScreen> createState() => _SearchUserScreenState();
// }

// class _SearchUserScreenState extends State<SearchUserScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: <Widget>[
//                   // Profile back button
//                   Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const StudyBuddies(),
//                           ),
//                         );
//                       },
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Icon(
//                             Icons.arrow_back_ios_new_rounded,
//                             size: 28,
//                             color: Colors.black,
//                           ),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             "Profile",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 30,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 width: 370,
//                 height: 400,
//                 decoration: ShapeDecoration(
//                   color: const Color(0xEAF6EEEE),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
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
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 100,
//                       width: 100,
//                       decoration: BoxDecoration(
//                         color: const Color(0xEAF6EEEE),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.grey[300],
//                         backgroundImage: NetworkImage(widget.user.profilePic),
//                       ),
//                     ),
//                     Text(
//                       widget.user.userName,
//                       style: const TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Text(
//                       widget.user.major,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Screens/find_studybuddies.dart';
// import 'package:flutter_application_1/Models/usermodel.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SearchUserScreen extends StatefulWidget {
//   final UserModel user;

//   const SearchUserScreen({super.key, required this.user});

//   @override
//   State<SearchUserScreen> createState() => _SearchUserScreenState();
// }

// class _SearchUserScreenState extends State<SearchUserScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> addFriend() async {
//     User? currentUser = _auth.currentUser;

//     if (currentUser != null) {
//       DocumentReference currentUserDoc =
//           _firestore.collection('users').doc(currentUser.uid);
//       DocumentReference searchedUserDoc =
//           _firestore.collection('users').doc(widget.user.uid);

//       await currentUserDoc.update({
//         'friends': FieldValue.arrayUnion([widget.user.uid]),
//       });

//       await searchedUserDoc.update({
//         'friends': FieldValue.arrayUnion([currentUser.uid]),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Friend added successfully!'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: <Widget>[
//                   // Profile back button
//                   Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const StudyBuddies(),
//                           ),
//                         );
//                       },
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Icon(
//                             Icons.arrow_back_ios_new_rounded,
//                             size: 28,
//                             color: Colors.black,
//                           ),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             "Profile",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 30,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 height: 100,
//                 width: 100,
//                 decoration: BoxDecoration(
//                   color: Colors.white70,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.grey[300],
//                   backgroundImage: NetworkImage(widget.user.profilePic),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 widget.user.userName,
//                 style: const TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black,
//                 ),
//               ),
//               Text(
//                 widget.user.major,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               ElevatedButton(
//                 onPressed: addFriend,
//                 child: const Text('Add Friend'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Models/usermodel.dart';
// import 'package:flutter_application_1/Screens/find_studybuddies.dart';

// class SearchUserScreen extends StatefulWidget {
//   final UserModel user;

//   const SearchUserScreen({super.key, required this.user});

//   @override
//   State<SearchUserScreen> createState() => _SearchUserScreenState();
// }

// class _SearchUserScreenState extends State<SearchUserScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool isFriend = false;

//   @override
//   void initState() {
//     super.initState();
//     checkFriendshipStatus();
//   }

//   void checkFriendshipStatus() async {
//     final userUid = FirebaseAuth.instance.currentUser!.uid;
//     DocumentSnapshot userSnapshot =
//         await _firestore.collection('users').doc(userUid).get();
//     UserModel currentUser =
//         UserModel.fromJSON(userSnapshot.data() as Map<String, dynamic>);
//     setState(() {
//       isFriend = currentUser.friends.contains(widget.user.uid);
//     });
//   }

//   void addFriend() async {
//     final userUid = FirebaseAuth.instance.currentUser!.uid;
//     try {
//       // Fetch the current user's data
//       DocumentSnapshot userSnapshot =
//           await _firestore.collection('users').doc(userUid).get();
//       UserModel currentUser =
//           UserModel.fromJSON(userSnapshot.data() as Map<String, dynamic>);

//       // Update the current user's friend list
//       await _firestore.collection('users').doc(userUid).update({
//         'friends': FieldValue.arrayUnion([widget.user.uid]),
//         'sentRequests': FieldValue.arrayUnion([widget.user.uid])
//       });

//       // Update the friend's received requests
//       await _firestore.collection('users').doc(widget.user.uid).update({
//         'receivedRequests': FieldValue.arrayUnion([userUid])
//       });

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Friend request sent to ${widget.user.userName}')));
//       setState(() {
//         isFriend = true;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }

//   void removeFriend() async {
//     final userUid = FirebaseAuth.instance.currentUser!.uid;
//     try {
//       // Remove the friend from the current user's friend list
//       await _firestore.collection('users').doc(userUid).update({
//         'friends': FieldValue.arrayRemove([widget.user.uid])
//       });

//       // Remove the current user from the friend's friend list
//       await _firestore.collection('users').doc(widget.user.uid).update({
//         'friends': FieldValue.arrayRemove([userUid])
//       });

//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Friend removed')));
//       setState(() {
//         isFriend = false;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: <Widget>[
//                   // Profile back button
//                   Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const StudyBuddies(),
//                           ),
//                         );
//                       },
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Icon(
//                             Icons.arrow_back_ios_new_rounded,
//                             size: 28,
//                             color: Colors.black,
//                           ),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             "Profile",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 30,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 height: 100,
//                 width: 100,
//                 decoration: BoxDecoration(
//                   color: Colors.white70,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.grey[300],
//                   backgroundImage: NetworkImage(widget.user.profilePic),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 widget.user.userName,
//                 style: const TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black,
//                 ),
//               ),
//               Text(
//                 widget.user.major,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               ElevatedButton(
//                 onPressed: isFriend ? removeFriend : addFriend,
//                 child: Text(isFriend ? 'Remove Friend' : 'Add Friend'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:flutter_application_1/Screens/find_studybuddies.dart';

class SearchUserScreen extends StatefulWidget {
  final UserModel user;

  const SearchUserScreen({super.key, required this.user});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
        body: Container(
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
                widget.user.userName,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                widget.user.major,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: isFriend ? removeFriend : addFriend,
                child: Text(isFriend ? 'Remove Friend' : 'Add Friend'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
