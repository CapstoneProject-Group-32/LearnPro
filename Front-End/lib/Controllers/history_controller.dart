import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/timer_history_model.dart';

class HistoryController {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveFocusTime(String userId, History history) async {
    try {
      DocumentReference userDoc = users.doc(userId);
      DocumentSnapshot userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        userDoc.update({
          'timer.focusTime': FieldValue.arrayUnion([history.toJson()]),
          'timer.sumOfFocusTime': FieldValue.increment(history.focusedSecs)
        });
      } else {
        userDoc.set({
          'timer': {
            'focusTime': [history.toJson()],
            'sumOfFocusTime': history.focusedSecs
          }
        });
      }
    } catch (e) {
      print('Error saving focus time: $e');
    }
  }

  Future<List<History>> readFocusTime(String userId) async {
    List<History> historyList = [];
    try {
      DocumentSnapshot userSnapshot = await users.doc(userId).get();
      if (userSnapshot.exists) {
        List<dynamic> focusTimes = userSnapshot.get('timer.focusTime');
        for (var focusTime in focusTimes) {
          historyList.add(History.fromJson(focusTime));
        }
      }
    } catch (e) {
      print('Error reading focus time: $e');
    }
    return historyList;
  }

  Future<int> readSumOfFocusTime(String userId) async {
    int sumOfFocusTime = 0;
    try {
      DocumentSnapshot userSnapshot = await users.doc(userId).get();
      if (userSnapshot.exists) {
        sumOfFocusTime = userSnapshot.get('timer.sumOfFocusTime');
      }
    } catch (e) {
      print('Error reading sum of focus time: $e');
    }
    return sumOfFocusTime;
  }
}
