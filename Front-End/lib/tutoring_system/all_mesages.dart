import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:badges/badges.dart' as badges;

import 'cancelled_meeting_msgs.dart';
import 'confirmed_meet_msgs.dart';
import 'rejected_messages_screen.dart';

class AllMessages extends StatefulWidget {
  const AllMessages({super.key});

  @override
  _AllMessagesState createState() => _AllMessagesState();
}

class _AllMessagesState extends State<AllMessages> {
  String userId = ''; // Replace with the current user ID

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  void fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    } else {
      // Handle the case where the user is not signed in
      // You might want to redirect them to the login screen
    }
  }

  Stream<int> getUnreadCountStream(String collection) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(collection)
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1, // Set initial tab index to 1 (middle tab)
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            children: <Widget>[
              TabBar(
                tabs: [
                  StreamBuilder<int>(
                    stream: getUnreadCountStream('rejectedMsgs'),
                    builder: (context, snapshot) {
                      return _buildTab('Rejected', snapshot.data ?? 0);
                    },
                  ),
                  StreamBuilder<int>(
                    stream: getUnreadCountStream('confirmMsgs'),
                    builder: (context, snapshot) {
                      return _buildTab('Confirmed', snapshot.data ?? 0);
                    },
                  ),
                  StreamBuilder<int>(
                    stream: getUnreadCountStream('cancelledmeetings'),
                    builder: (context, snapshot) {
                      return _buildTab('Cancelled', snapshot.data ?? 0);
                    },
                  ),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).secondaryHeaderColor,
                dividerColor: Colors.transparent,
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    RejectedMsgsScreen(),
                    ConfirmedMsgsScreen(),
                    CancelledMeetMsgsScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, int count) {
    return Tab(
      child: badges.Badge(
        showBadge: count > 0,
        badgeContent: Text(
          count.toString(),
          style: const TextStyle(color: Color.fromARGB(255, 246, 27, 27)),
        ),
        badgeStyle: const badges.BadgeStyle(
            badgeColor: Color.fromARGB(255, 255, 254, 254)),
        position: badges.BadgePosition.topEnd(top: -15, end: -15),
        child: Text(title),
      ),
    );
  }
}
