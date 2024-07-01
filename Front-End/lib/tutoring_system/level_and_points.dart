import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserStats extends StatelessWidget {
  final String choice;
  final String userId;
  final double fontSize; // New parameter for font size

  // Constructor now includes fontSize
  UserStats(
      {required this.choice, required this.userId, required this.fontSize});

  // Method to fetch feedback points
  Future<num> getFeedbackPoints() async {
    num feedbackPoints = 0;
    try {
      QuerySnapshot feedbacksSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('feedbacks')
          .get();

      for (var doc in feedbacksSnapshot.docs) {
        feedbackPoints += (doc['points'] ?? 0) as num;
      }
    } catch (e) {
      print('Error fetching feedback points: $e');
    }
    return feedbackPoints;
  }

  // Method to fetch learning points
  Future<int> getLearningPoints() async {
    int learningPoints = 0;
    try {
      QuerySnapshot learningRecsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('learningRecs')
          .get();

      for (var doc in learningRecsSnapshot.docs) {
        if (doc['tchAvblt'] == true && doc['held'] == true) {
          learningPoints += 100;
        }
      }
    } catch (e) {
      print('Error fetching learning points: $e');
    }
    return learningPoints;
  }

  // Method to fetch teaching points
  Future<int> getTeachingPoints() async {
    int teachingPoints = 0;
    try {
      QuerySnapshot teachingRecsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('teachingRecs')
          .get();

      for (var doc in teachingRecsSnapshot.docs) {
        if (doc['tchAvblt'] == true && doc['held'] == true) {
          teachingPoints += 100;
        }
      }
    } catch (e) {
      print('Error fetching teaching points: $e');
    }
    return teachingPoints;
  }

  // Method to fetch focus time points
  Future<int> getFocusTimePoints() async {
    int focusTimePoints = 0;
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        var timer = userDoc.get('timer');
        if (timer != null &&
            timer is Map<String, dynamic> &&
            timer.containsKey('sumOfFocusTime')) {
          int sumOfFocusTime = (timer['sumOfFocusTime'] ?? 0).toInt();
          focusTimePoints = (sumOfFocusTime / 3600).round() * 100;
        }
      }
    } catch (e) {
      print('Error fetching focus time points: $e');
    }
    return focusTimePoints;
  }

  // Method to calculate total points
  Future<num> getTotalPoints() async {
    num feedbackPoints = await getFeedbackPoints();
    int learningPoints = await getLearningPoints();
    int teachingPoints = await getTeachingPoints();
    int focusTimePoints = await getFocusTimePoints();

    return (feedbackPoints + learningPoints + teachingPoints + focusTimePoints)
        .round();
  }

  // Method to calculate level
  Future<int> getLevel() async {
    num totalPoints = await getTotalPoints();
    return totalPoints ~/ 1000; // Integer division to get level as an integer
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: choice == 'p' ? getTotalPoints() : getLevel(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (choice == 'p') {
            return Text(
              '${snapshot.data}',
              style:
                  TextStyle(fontSize: fontSize), // Use the font size parameter
            );
          } else {
            return Text(
              '${snapshot.data}',
              style:
                  TextStyle(fontSize: fontSize), // Use the font size parameter
            );
          }
        }
      },
    );
  }
}
