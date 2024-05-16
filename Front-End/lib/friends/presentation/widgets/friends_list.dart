import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/error.dart';
import 'package:flutter_application_1/friends/presentation/widgets/friend_tile.dart';
import 'package:flutter_application_1/friends/providers/get_all_friends_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendsList extends ConsumerStatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FriendsListState();
}

class _FriendsListState extends ConsumerState<FriendsList> {
  @override
  Widget build(BuildContext context) {
    final friendsList = ref.watch(getAllFriendsProvider);

    return friendsList.when(
      data: (friends) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final userId = friends.elementAt(index);
              return FriendTile(
                userId: userId,
              );
            },
            childCount: friends.length,
          ),
        );
      },
      error: (error, stackTrace) {
        return SliverToBoxAdapter(
          child: ErrorScreen(error: error.toString()),
        );
      },
      loading: () {
        return const SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
