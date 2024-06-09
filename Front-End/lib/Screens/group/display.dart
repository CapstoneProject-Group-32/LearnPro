import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JoinedGroupsScreen extends StatefulWidget {
  @override
  _JoinedGroupsScreenState createState() => _JoinedGroupsScreenState();
}

class _JoinedGroupsScreenState extends State<JoinedGroupsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _joinedGroups = [];

  @override
  void initState() {
    super.initState();
    _fetchJoinedGroups();
  }

  Future<void> _fetchJoinedGroups() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Get the current user's document
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        List<String> joinedGroups =
            List<String>.from(userDoc['joinedgroups'] ?? []);

        List<Map<String, dynamic>> groupDetails = [];
        for (String groupName in joinedGroups) {
          DocumentSnapshot groupDoc =
              await _firestore.collection('groups').doc(groupName).get();
          if (groupDoc.exists) {
            groupDetails.add(groupDoc.data() as Map<String, dynamic>);
          }
        }

        setState(() {
          _joinedGroups = groupDetails;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joined Groups'),
      ),
      body: _joinedGroups.isEmpty
          ? Center(
              child: Text(
                "No joined groups",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: _joinedGroups.length,
              itemBuilder: (context, index) {
                final group = _joinedGroups[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _groupCard(
                    NetworkImage(group['groupicon']),
                    group['groupname'],
                    group['groupmajor'],
                    () {
                      // TODO: Implement navigation to the group details page
                    },
                  ),
                );
              },
            ),
    );
  }
}

Widget _groupCard(
  ImageProvider<Object> groupIcon,
  String groupName,
  String groupMajor,
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
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Container(
              width: 75,
              height: 75,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: groupIcon,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  groupMajor,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: GestureDetector(
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
          ),
        ],
      ),
    ),
  );
}
