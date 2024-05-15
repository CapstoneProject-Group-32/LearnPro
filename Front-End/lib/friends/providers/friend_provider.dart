import 'package:flutter_application_1/friends/repository/friend_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final friendProvider = Provider((ref) {
  return FriendRepository();
});
