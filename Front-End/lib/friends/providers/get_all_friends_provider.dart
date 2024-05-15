import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getAllFriendsProvider = StreamProvider.autoDispose((ref) {
  final myUid = FirebaseAuth.instance.currentUser!.uid;

  final controller = StreamController<Iterable<String>>();

  final sub = FirebaseFirestore.instance
      .collection('users')
      .doc(myUid)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.exists) {
      final userData = snapshot.data() as Map<String, dynamic>;
      final user = UserModel.fromJSON(userData);
      controller.sink.add(user.friends);
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
