import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../tutoring_system/custom_appbar.dart';

class CommentSection extends StatefulWidget {
  final String groupName;
  final String contentId;

  const CommentSection(
      {super.key, required this.groupName, required this.contentId});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();

  void _addComment() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || _commentController.text.isEmpty) return;

    final contentRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupName)
        .collection('groupcontents')
        .doc(widget.contentId);

    final snapshot = await contentRef.get();
    if (!snapshot.exists) return;

    final contentData = snapshot.data() as Map<String, dynamic>;
    final comments = contentData['comments'] as Map<String, dynamic>? ?? {};

    // Use a unique key based on the current timestamp
    final newKey = DateTime.now().millisecondsSinceEpoch.toString();

    comments[newKey] = {
      'uid': currentUser.uid,
      'comment': _commentController.text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await contentRef.update({'comments': comments});
    _commentController.clear();
  }

  void _showDeleteDialog(BuildContext context, String commentKey, String uid) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Comment'),
          content: const Text('Are you sure you want to delete this comment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                if (currentUser.uid == uid ||
                    await _isGroupOwner(currentUser.uid)) {
                  final contentRef = FirebaseFirestore.instance
                      .collection('groups')
                      .doc(widget.groupName)
                      .collection('groupcontents')
                      .doc(widget.contentId);

                  final snapshot = await contentRef.get();
                  if (!snapshot.exists) return;

                  final contentData = snapshot.data() as Map<String, dynamic>;
                  final comments =
                      contentData['comments'] as Map<String, dynamic>? ?? {};

                  comments.remove(commentKey);

                  await contentRef.update({'comments': comments});
                }

                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _isGroupOwner(String uid) async {
    final groupSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupName)
        .get();
    if (!groupSnapshot.exists) return false;

    final groupData = groupSnapshot.data() as Map<String, dynamic>;
    return groupData['owner'] == uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Comments'),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(widget.groupName)
                  .collection('groupcontents')
                  .doc(widget.contentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var contentData = snapshot.data!.data() as Map<String, dynamic>;
                var comments =
                    contentData['comments'] as Map<String, dynamic>? ?? {};

                // Convert comments to a list and sort by timestamp
                var sortedComments = comments.entries.toList()
                  ..sort((a, b) {
                    var timestampA = a.value['timestamp'] as Timestamp?;
                    var timestampB = b.value['timestamp'] as Timestamp?;
                    return timestampA
                            ?.compareTo(timestampB ?? Timestamp.now()) ??
                        0;
                  });

                return ListView(
                  children: sortedComments.map((entry) {
                    var commentData = entry.value as Map<String, dynamic>;
                    var uid = commentData['uid'] as String? ?? '';
                    var comment = commentData['comment'] as String? ?? '';

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        var userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        var username =
                            userData['userName'] as String? ?? 'Unknown';
                        var profilePic =
                            userData['profilePic'] as String? ?? '';

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: profilePic.isNotEmpty
                                ? CachedNetworkImageProvider(profilePic)
                                : null,
                            child: profilePic.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(username),
                          subtitle: Text(comment),
                          onLongPress: () {
                            _showDeleteDialog(context, entry.key, uid);
                          },
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration:
                        const InputDecoration(hintText: 'Add a comment...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
