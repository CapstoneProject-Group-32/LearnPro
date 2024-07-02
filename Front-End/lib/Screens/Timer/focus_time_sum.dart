import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FocusTimeSum extends StatelessWidget {
  final String userId;
  double _sumOfFocusTimeInHours = 0.0;

  FocusTimeSum({super.key, required this.userId}) {
    _initializeSumOfFocusTime();
  }

  Future<void> _initializeSumOfFocusTime() async {
    _sumOfFocusTimeInHours = await getSumOfFocusTimeInHours();
  }

  Future<double> getSumOfFocusTimeInHours() async {
    double sumOfFocusTimeInSeconds = 0.0;

    try {
      // Reference to the user's document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if the document exists and has the 'timer' field
      if (userDoc.exists && userDoc.data() != null) {
        var timer = userDoc.get('timer');
        if (timer != null &&
            timer is Map<String, dynamic> &&
            timer.containsKey('sumOfFocusTime')) {
          sumOfFocusTimeInSeconds = (timer['sumOfFocusTime'] ?? 0).toDouble();
        }
      }
    } catch (e) {
      print('Error fetching sumOfFocusTime: $e');
    }

    // Convert seconds to hours and round to one decimal place
    double sumOfFocusTimeInHours = sumOfFocusTimeInSeconds / 3600;
    return double.parse(sumOfFocusTimeInHours.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: getSumOfFocusTimeInHours(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text('${snapshot.data ?? 0.0} h');
        }
      },
    );
  }
}
