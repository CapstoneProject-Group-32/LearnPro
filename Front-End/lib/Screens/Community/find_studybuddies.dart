import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:flutter_application_1/Screens/Community/request_tution.dart';
import 'package:flutter_application_1/Screens/Community/search_user_screen.dart';

class StudyBuddies extends StatefulWidget {
  final Map<String, dynamic>? userMap;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onSearch;

  const StudyBuddies({
    Key? key,
    required this.userMap,
    required this.isLoading,
    required this.errorMessage,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<StudyBuddies> createState() => _StudyBuddiesState();
}

class _StudyBuddiesState extends State<StudyBuddies> {
  List<UserModel> friends = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  void fetchFriends() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
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
                    if (widget.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    if (widget.userMap != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _studybuddyCardBeforeAddFriend(
                          NetworkImage(widget.userMap!['profilePic']),
                          widget.userMap!['userName'],
                          widget.userMap!['major'],
                          () {
                            UserModel user =
                                UserModel.fromJSON(widget.userMap!);
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
                                        SearchUserScreen(user: friend),
                                  ),
                                );
                              },
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RequestTuitionScreen(
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
      ),
    );
  }
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
