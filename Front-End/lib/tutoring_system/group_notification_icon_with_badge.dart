import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart' as badges;

class GroupNotificationIconWithBadge extends StatefulWidget {
  final String groupName;

  const GroupNotificationIconWithBadge({super.key, required this.groupName});

  @override
  _GroupNotificationIconWithBadgeState createState() =>
      _GroupNotificationIconWithBadgeState();
}

class _GroupNotificationIconWithBadgeState
    extends State<GroupNotificationIconWithBadge> {
  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  Stream<int> getUnreadRequestsCountStream(String groupName) {
    return firestore
        .collection('groups')
        .doc(groupName)
        .collection('contentrequests')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: getUnreadRequestsCountStream(widget.groupName),
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
