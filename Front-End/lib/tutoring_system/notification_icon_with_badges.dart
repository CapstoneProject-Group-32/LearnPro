import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart' as badges;
import 'package:rxdart/rxdart.dart';

class NotificationIconWithBadge extends StatefulWidget {
  const NotificationIconWithBadge({super.key});

  @override
  _NotificationIconWithBadgeState createState() =>
      _NotificationIconWithBadgeState();
}

class _NotificationIconWithBadgeState extends State<NotificationIconWithBadge> {
  late FirebaseFirestore firestore;
  late FirebaseAuth auth;
  String userId = '';

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    auth = FirebaseAuth.instance;
    fetchUserId();
  }

  void fetchUserId() async {
    User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  Stream<int> getTotalUnreadCountStream() {
    Stream<int> arrangedMeetingsCountStream = firestore
        .collection('users')
        .doc(userId)
        .collection('arrangedMeetings')
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);

    Stream<int> tuitionRequestsCountStream = firestore
        .collection('users')
        .doc(userId)
        .collection('tuitionRequests')
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);

    Stream<int> confirmMsgsCountStream = firestore
        .collection('users')
        .doc(userId)
        .collection('confirmMsgs')
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);

    Stream<int> cancelledMeetingsCountStream = firestore
        .collection('users')
        .doc(userId)
        .collection('cancelledmeetings')
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);

    Stream<int> rejectedMsgsCountStream = firestore
        .collection('users')
        .doc(userId)
        .collection('rejectedMsgs')
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);

    Stream<int> groupInvitationsCountStream =
        firestore.collection('users').doc(userId).snapshots().map((snapshot) {
      List<dynamic> groupInvitations =
          snapshot.data()?['groupinvitaions'] ?? [];
      return groupInvitations.length;
    });

    return Rx.combineLatest6(
      arrangedMeetingsCountStream,
      tuitionRequestsCountStream,
      confirmMsgsCountStream,
      cancelledMeetingsCountStream,
      rejectedMsgsCountStream,
      groupInvitationsCountStream,
      (a, b, c, d, e, f) => a + b + c + d + e + f,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: getTotalUnreadCountStream(),
      builder: (context, snapshot) {
        int unreadCount = snapshot.data ?? 0;
        return badges.Badge(
          showBadge: unreadCount > 0,
          badgeContent: Text(
            unreadCount.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: Colors.red,
          ),
          position: badges.BadgePosition.topEnd(top: -10, end: -10),
          child: const Icon(Icons.notifications),
        );
      },
    );
  }
}
