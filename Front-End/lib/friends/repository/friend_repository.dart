import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class FriendRepository {
  final _myUid = FirebaseAuth.instance.currentUser!.uid;
  final _firestore = FirebaseFirestore.instance;

  // Send friend request
  Future<String?> sendFriendReuqest({
    required String userId,
  }) async {
    try {
      // Get the user document
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      // Update received requests
      await _firestore.collection('users').doc(userId).update({
        'receivedRequests': FieldValue.arrayUnion([_myUid]),
      });

      // Update sent requests
      await _firestore.collection('users').doc(_myUid).update({
        'sentRequests': FieldValue.arrayUnion([userId]),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

// Accept friend request
  Future<String?> acceptFriendRequest({
    required String userId,
  }) async {
    try {
      // Update other person's friend list
      await _firestore.collection("users").doc(userId).update({
        'friends': FieldValue.arrayUnion([_myUid]),
      });

      // Update your own friend list
      await _firestore.collection("users").doc(_myUid).update({
        'friends': FieldValue.arrayUnion([userId]),
      });

      // Remove sent and received friend requests
      removeFriendRequest(userId: userId);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> removeFriendRequest({
    required String userId,
  }) async {
    try {
      // Remove from other person's received requests
      await _firestore.collection("users").doc(userId).update({
        'receivedRequests': FieldValue.arrayRemove([_myUid]),
      });

      // Remove from other person's sent requests
      await _firestore.collection("users").doc(userId).update({
        'sentRequests': FieldValue.arrayRemove([_myUid]),
      });

      // Remove from your own sent requests
      await _firestore.collection("users").doc(_myUid).update({
        'sentRequests': FieldValue.arrayRemove([userId]),
      });

      // Remove from your own received requests
      await _firestore.collection("users").doc(_myUid).update({
        'receivedRequests': FieldValue.arrayRemove([userId]),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

// Remove friend
  Future<String?> removeFriend({
    required String userId,
  }) async {
    try {
      // Remove from other person's friend list
      await _firestore.collection("users").doc(userId).update({
        'friends': FieldValue.arrayRemove([_myUid]),
      });

      // Remove from your own friend list
      await _firestore.collection("users").doc(_myUid).update({
        'friends': FieldValue.arrayRemove([userId]),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
