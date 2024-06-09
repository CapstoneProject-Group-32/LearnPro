import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInvitationNotificationScreen extends StatefulWidget {
  const GroupInvitationNotificationScreen({super.key});

  @override
  _GroupInvitationNotificationScreenState createState() =>
      _GroupInvitationNotificationScreenState();
}

class _GroupInvitationNotificationScreenState
    extends State<GroupInvitationNotificationScreen> {
  late Future<List<Map<String, dynamic>>> invitationsFuture;

  @override
  void initState() {
    super.initState();
    invitationsFuture = loadInvitations();
  }

  Future<List<Map<String, dynamic>>> loadInvitations() async {
    List<String> groupInvitations = await getCurrentUserGroupInvitations();
    List<Map<String, dynamic>> invitations = [];

    for (String groupName in groupInvitations) {
      Map<String, dynamic>? groupDetails = await getGroupDetails(groupName);
      if (groupDetails != null) {
        Map<String, dynamic>? ownerDetails =
            await getUserDetails(groupDetails['owner']);
        if (ownerDetails != null) {
          invitations.add({
            'groupDetails': groupDetails,
            'ownerDetails': ownerDetails,
          });
        }
      }
    }

    return invitations;
  }

  Future<List<String>> getCurrentUserGroupInvitations() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("No user logged in");
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      return List<String>.from(userDoc['groupinvitations'] ?? []);
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getGroupDetails(String groupName) async {
    DocumentSnapshot groupDoc = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupName)
        .get();

    if (groupDoc.exists && groupDoc.data() != null) {
      return groupDoc.data() as Map<String, dynamic>?;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists && userDoc.data() != null) {
      return userDoc.data() as Map<String, dynamic>?;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: invitationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No invitations'));
          } else {
            List<Map<String, dynamic>> invitations = snapshot.data!;
            return ListView.builder(
              itemCount: invitations.length,
              itemBuilder: (context, index) {
                return InvitationCard(
                  groupDetails: invitations[index]['groupDetails'],
                  ownerDetails: invitations[index]['ownerDetails'],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class InvitationCard extends StatefulWidget {
  final Map<String, dynamic> groupDetails;
  final Map<String, dynamic> ownerDetails;

  const InvitationCard({super.key, required this.groupDetails, required this.ownerDetails});

  @override
  _InvitationCardState createState() => _InvitationCardState();
}

class _InvitationCardState extends State<InvitationCard> {
  String? status;

  void handleAccept() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    String groupName = widget.groupDetails['groupname'];

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference groupRef =
          FirebaseFirestore.instance.collection('groups').doc(groupName);
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      transaction.update(groupRef, {
        'members': FieldValue.arrayUnion([currentUser.uid]),
        'invitedmembers': FieldValue.arrayRemove([currentUser.uid]),
      });

      transaction.update(userRef, {
        'groupinvitations': FieldValue.arrayRemove([groupName]),
        'joinedgroups': FieldValue.arrayUnion([groupName])
      });
    });

    setState(() {
      status = 'accepted';
    });
  }

  void handleReject() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    String groupName = widget.groupDetails['groupname'];

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference groupRef =
          FirebaseFirestore.instance.collection('groups').doc(groupName);
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      transaction.update(groupRef, {
        'invitedmembers': FieldValue.arrayRemove([currentUser.uid]),
      });

      transaction.update(userRef, {
        'groupinvitations': FieldValue.arrayRemove([groupName]),
      });
    });

    setState(() {
      status = 'rejected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.ownerDetails['profilePic'] ?? ''),
                ),
                const SizedBox(width: 10),
                Text(
                    '${widget.ownerDetails['userName'] ?? 'Unknown user'} has invited you to his group'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Image.network(
                  widget.groupDetails['groupicon'] ?? '',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.groupDetails['groupname'] ?? 'Unknown group',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.groupDetails['groupmajor'] ??
                        'No major specified'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(widget.groupDetails['groupdescription'] ??
                'No description provided'),
            const SizedBox(height: 10),
            if (status == null) ...[
              Row(
                children: [
                  ElevatedButton(
                      onPressed: handleAccept, child: const Text('Accept')),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: handleReject, child: const Text('Reject')),
                ],
              ),
            ] else if (status == 'accepted') ...[
              const Center(
                child: Text('Accepted', style: TextStyle(color: Colors.green)),
              ),
            ] else if (status == 'rejected') ...[
              const Center(
                child: Text('Rejected', style: TextStyle(color: Colors.red)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
