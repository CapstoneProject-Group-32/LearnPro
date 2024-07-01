import 'package:LearnPro/tutoring_system/request_tution_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:LearnPro/Models/usermodel.dart';
import 'package:LearnPro/Screens/Community/request_tution.dart';
import 'package:LearnPro/Screens/Community/search_user_screen.dart';

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
    double deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
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
                          context,
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
                              context,
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
                                    builder: (context) => RequestTuitionForm(
                                      userID: friend.uid,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ).toList()
                    else
                      Container(
                        height: deviceHeight / 2,
                        child: Center(child: Text("No friends found")),
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
  BuildContext context,
  ImageProvider<Object> userImage,
  String userName,
  String userLevel,
  Function() onTapView,
) {
  return Container(
    width: double.infinity,
    // width: 370,
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
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userLevel,
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
          child: GestureDetector(
            onTap: onTapView,
            child: Container(
              width: 110,
              height: 25,
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.background,
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
                    fontSize: 13,
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.w400,
                  ),
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
  BuildContext context,
  ImageProvider<Object> userImage,
  String userName,
  String userLevel,
  Function() onTapView,
  Function() onTapRequestTuition,
) {
  return Container(
    width: double.infinity,
    // width: 370,
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userLevel,
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
                  onTap: onTapView,
                  child: Container(
                    width: 110,
                    height: 25,
                    decoration: ShapeDecoration(
                      color: Theme.of(context).colorScheme.secondary,
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
                          fontSize: 13,
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
                    width: 110,
                    height: 25,
                    decoration: ShapeDecoration(
                      color: Theme.of(context).colorScheme.secondary,
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
                          fontSize: 13,
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
