import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CommentSection extends StatelessWidget {
  final String groupName;
  final String contentId;

  CommentSection({required this.groupName, required this.contentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(groupName)
                  .collection('groupcontents')
                  .doc(contentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var contentData = snapshot.data!.data() as Map<String, dynamic>;
                var comments =
                    contentData['comments'] as Map<String, dynamic>? ?? {};

                return ListView(
                  children: comments.entries.map((entry) {
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
                          return Center(child: CircularProgressIndicator());
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
                            child:
                                profilePic.isEmpty ? Icon(Icons.person) : null,
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
                    decoration: InputDecoration(
                      labelText: 'Add a comment',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController _commentController = TextEditingController();

  void _addComment() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || _commentController.text.isEmpty) return;

    final contentRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupName)
        .collection('groupcontents')
        .doc(contentId);

    final snapshot = await contentRef.get();
    if (!snapshot.exists) return;

    final contentData = snapshot.data() as Map<String, dynamic>;
    final comments = contentData['comments'] as Map<String, dynamic>? ?? {};
    final newKey = comments.keys.length.toString();

    comments[newKey] = {
      'uid': currentUser.uid,
      'comment': _commentController.text,
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
          title: Text('Delete Comment'),
          content: Text('Are you sure you want to delete this comment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                if (currentUser.uid == uid ||
                    await _isGroupOwner(currentUser.uid)) {
                  final contentRef = FirebaseFirestore.instance
                      .collection('groups')
                      .doc(groupName)
                      .collection('groupcontents')
                      .doc(contentId);

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
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _isGroupOwner(String uid) async {
    final groupSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupName)
        .get();
    if (!groupSnapshot.exists) return false;

    final groupData = groupSnapshot.data() as Map<String, dynamic>;
    return groupData['owner'] == uid;
  }
}
