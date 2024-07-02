import 'package:LearnPro/tutoring_system/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SendGroupInvites extends StatefulWidget {
  final String groupName;

  const SendGroupInvites({super.key, required this.groupName});

  @override
  _SendGroupInvitesState createState() => _SendGroupInvitesState();
}

class _SendGroupInvitesState extends State<SendGroupInvites> {
  List<String> friends = []; // List of friends' UIDs
  Map<String, bool> selectedFriends = {};
  Map<String, String> friendUsernames = {}; // Map to store UID and username

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final friendsList = List<String>.from(userDoc['friends']);

    setState(() {
      friends = friendsList;
    });
  }

  void invite() async {
    final contentRef =
        FirebaseFirestore.instance.collection('groups').doc(widget.groupName);

    final selectedUIDs = selectedFriends.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // Update the group document with invited members
    await contentRef.update({
      'invitedmembers': FieldValue.arrayUnion(selectedUIDs),
    });

    // Update each invited friend's document with the group invitation
    for (var uid in selectedUIDs) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'groupinvitations': FieldValue.arrayUnion([widget.groupName]),
      });
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Invite Friends'),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          String uid = friends[index];
          return FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance.collection('users').doc(uid).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              friendUsernames[uid] = userData['userName'];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userData['profilePic']),
                ),
                title: Text(userData['userName']),
                trailing: Checkbox(
                  value: selectedFriends[uid] ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      selectedFriends[uid] = value!;
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: invite,
        child: const Icon(Icons.check),
      ),
    );
  }
}
