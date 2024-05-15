import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserInfoAsStreamByIdProvider =
    StreamProvider.autoDispose.family<UserModel, String>((ref, String userId) {
  final controller = StreamController<UserModel>();

  final sub = FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: userId)
      .limit(1)
      .snapshots()
      .listen((snapshot) {
    final userData = snapshot.docs.first;
    final user = UserModel.fromJSON(userData.data());
    controller.sink.add(user);
  });

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });

  return controller.stream;
});
