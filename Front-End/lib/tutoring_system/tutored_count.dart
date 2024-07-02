import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TutoredCount extends StatelessWidget {
  final String userId;
  final double fontSize; // New parameter for font size

  // Constructor now includes fontSize
  TutoredCount({required this.userId, required this.fontSize}) {
    _initializeCount();
  }

  int _count = 0;

  // Method to initialize count
  Future<void> _initializeCount() async {
    _count = await getTutoredCount();
  }

  // Method to get tutored count
  Future<int> getTutoredCount() async {
    int count = 0;

    // Reference to the user's document
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Check if the teachingRecs collection exists
    CollectionReference teachingRecsCollection =
        userDoc.collection('teachingRecs');
    QuerySnapshot querySnapshot = await teachingRecsCollection.get();

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        bool held = doc['held'] ?? false;
        bool tchAvblt = doc['tchAvblt'] ?? false;

        if (held && tchAvblt) {
          count++;
        }
      }
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: getTutoredCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text(
            '${snapshot.data ?? 0}',
            style: TextStyle(
              // Updated line to use fontSize
              fontSize: fontSize, // Use the font size parameter
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          );
        }
      },
    );
  }
}
