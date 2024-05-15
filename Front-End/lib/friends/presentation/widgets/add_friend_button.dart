import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:flutter_application_1/friends/providers/friend_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFriendButton extends ConsumerStatefulWidget {
  const AddFriendButton({
    super.key,
    required this.userName,
  });

  final UserModel userName;

  @override
  ConsumerState<AddFriendButton> createState() => _AddFriendButtonState();
}

class _AddFriendButtonState extends ConsumerState<AddFriendButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    final requestSent = widget.userName.receivedRequests.contains(myUid);
    final requestReceived = widget.userName.sentRequests.contains(myUid);
    final alreadyFriend = widget.userName.friends.contains(myUid);
    return isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: requestReceived
                ? null
                : () async {
                    setState(() => isLoading = true);
                    final provider = ref.read(friendProvider);
                    final userId = widget.userName.uid;
                    if (requestSent) {
                      // cancel request
                      await provider.removeFriendRequest(userId: userId);
                    } else if (alreadyFriend) {
                      // remove friendship
                      await provider.removeFriend(userId: userId);
                    } else {
                      // sent friend request
                      await provider.sendFriendReuqest(userId: userId);
                    }
                    setState(() => isLoading = false);
                  },
            child: Text(
              requestSent
                  ? 'Cancel Request'
                  : alreadyFriend
                      ? 'Remove Friend'
                      : 'Add Friend',
            ));
  }
}
