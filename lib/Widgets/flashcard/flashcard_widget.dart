// lib/widgets/flashcard_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/flashcard_model.dart';

class FlashcardWidget extends StatelessWidget {
  final Flashcard flashcard;

  FlashcardWidget({required this.flashcard});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              flashcard.subject,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              flashcard.topic,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(flashcard.content),
          ],
        ),
      ),
    );
  }
}
