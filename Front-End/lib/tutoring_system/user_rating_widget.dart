import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserRatingWidget {
  final String userId;

  UserRatingWidget({required this.userId});

  Future<double> _calculateAverageRating() async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final feedbacksCollection = userDoc.collection('feedbacks');

    // Get all documents from the 'feedbacks' sub-collection
    final feedbackDocs = await feedbacksCollection.get();

    // If no feedbacks, return 0.0
    if (feedbackDocs.docs.isEmpty) {
      return 0.0;
    }

    // Calculate the sum of all ratings
    double totalRating = 0.0;
    for (var doc in feedbackDocs.docs) {
      final rating = doc['rating'];
      totalRating += rating;
    }

    // Calculate the average rating
    double averageRating = totalRating / feedbackDocs.docs.length;

    // Round to one decimal place
    return double.parse(averageRating.toStringAsFixed(1));
  }

  Widget buildAverageRatingWidget() {
    return FutureBuilder<double>(
      future: _calculateAverageRating(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final averageRating = snapshot.data ?? 0.0;
          return Text(
            '$averageRating★',
            style: const TextStyle(fontSize: 18, color: Colors.black),
          );
        }
      },
    );
  }
}
