// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Screens/tutoring_system/all_mesages.dart';
// import 'package:flutter_application_1/Screens/tutoring_system/meeting_notifications.dart';
// import 'package:flutter_application_1/Screens/tutoring_system/tutor_request_notifications.dart';
// import 'package:flutter_application_1/group/group_invitation_notifications.dart';

// class AllNotifications extends StatefulWidget {
//   final int initialIndex;

//   const AllNotifications({Key? key, this.initialIndex = 0}) : super(key: key);

//   @override
//   State<AllNotifications> createState() => _AllNotificationsState();
// }

// class _AllNotificationsState extends State<AllNotifications>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(
//         length: 4, vsync: this, initialIndex: widget.initialIndex);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Icon(
//                   Icons.arrow_back_ios_new_rounded,
//                   size: 20,
//                   color: Colors.black,
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Text(
//                   "Notifications",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         body: Column(
//           children: [
//             TabBar(
//               controller: _tabController,
//               isScrollable: true,
//               dividerColor: Colors.transparent,
//               indicator: BoxDecoration(
//                 color: Theme.of(context).colorScheme.secondary,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               tabs: [
//                 _buildTab('Meetings', 0),
//                 _buildTab('Requests', 1),
//                 _buildTab('Responses', 2),
//                 _buildTab('Group Invites', 3),
//               ],
//             ),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   MeetingNotifications(),
//                   TutorRequestNotifications(),
//                   AllMessages(),
//                   GroupInvitationNotificationScreen(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTab(String text, int tabIndex) {
//     return Tab(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: Theme.of(context).colorScheme.secondary,
//               width: 1,
//             )),
//         child: Align(
//           alignment: Alignment.center,
//           child: Text(
//             text,
//             style: const TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:badges/badges.dart' as badges;
import 'package:rxdart/rxdart.dart';

import '../Screens/Notification/group_invitation_notifications.dart';
import 'all_mesages.dart';
import 'meeting_notifications.dart';
import 'tutor_request_notifications.dart';

class AllNotifications extends StatefulWidget {
  final int initialIndex;

  const AllNotifications({super.key, this.initialIndex = 0});

  @override
  State<AllNotifications> createState() => _AllNotificationsState();
}

class _AllNotificationsState extends State<AllNotifications>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late FirebaseFirestore firestore;
  late FirebaseAuth auth;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 4, vsync: this, initialIndex: widget.initialIndex);
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
    } else {
      // Handle the case where the user is not signed in
      // You might want to redirect them to the login screen
    }
  }

  Stream<int> getUnreadCountStream(String collection) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection(collection)
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getResponsesUnreadCountStream() {
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

    return Rx.combineLatest3(
        confirmMsgsCountStream,
        cancelledMeetingsCountStream,
        rejectedMsgsCountStream,
        (a, b, c) => a + b + c);
  }

  Stream<int> getGroupInvitesUnreadCountStream() {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      List<dynamic> groupInvitations =
          snapshot.data()?['groupinvitations'] ?? [];
      return groupInvitations.length;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Notifications",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              tabs: [
                StreamBuilder<int>(
                  stream: getUnreadCountStream('arrangedMeetings'),
                  builder: (context, snapshot) {
                    return _buildTab('Meetings', snapshot.data ?? 0);
                  },
                ),
                StreamBuilder<int>(
                  stream: getUnreadCountStream('tuitionRequests'),
                  builder: (context, snapshot) {
                    return _buildTab('Requests', snapshot.data ?? 0);
                  },
                ),
                StreamBuilder<int>(
                  stream: getResponsesUnreadCountStream(),
                  builder: (context, snapshot) {
                    return _buildTab('Responses', snapshot.data ?? 0);
                  },
                ),
                StreamBuilder<int>(
                  stream: getGroupInvitesUnreadCountStream(),
                  builder: (context, snapshot) {
                    return _buildTab('Group Invites', snapshot.data ?? 0);
                  },
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  MeetingNotifications(),
                  TutorRequestNotifications(),
                  AllMessages(),
                  GroupInvitationNotificationScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, int count) {
    return Tab(
      child: badges.Badge(
        showBadge: count > 0,
        badgeContent: Text(
          count.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        badgeStyle: const badges.BadgeStyle(
          badgeColor: Colors.red,
        ),
        position: badges.BadgePosition.topEnd(top: -5, end: -10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
                width: 1,
              )),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
