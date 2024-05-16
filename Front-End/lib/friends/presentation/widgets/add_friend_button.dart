import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:flutter_application_1/friends/providers/friend_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFriendButton extends ConsumerStatefulWidget {
  const AddFriendButton({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  ConsumerState<AddFriendButton> createState() => _AddFriendButtonState();
}

class _AddFriendButtonState extends ConsumerState<AddFriendButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    final requestSent = widget.user.receivedRequests.contains(myUid);
    final requestReceived = widget.user.sentRequests.contains(myUid);
    final alreadyFriend = widget.user.friends.contains(myUid);

    return isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: requestReceived
                ? null
                : () async {
                    setState(() => isLoading = true);
                    final provider = ref.read(friendProvider);
                    final userId = widget.user.uid;
                    if (requestSent) {
                      // Cancel request
                      await provider.removeFriendRequest(userId: userId);
                    } else if (alreadyFriend) {
                      // Remove friendship
                      await provider.removeFriend(userId: userId);
                    } else {
                      // Send friend request
                      await provider.sendFriendRequest(userId: userId);
                    }
                    setState(() => isLoading = false);
                  },
            child: Text(
              requestSent
                  ? 'Cancel Request'
                  : alreadyFriend
                      ? 'Remove Friend'
                      : 'Add Friend',
            ),
          );
  }
}
