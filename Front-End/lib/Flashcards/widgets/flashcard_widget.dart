import 'package:flutter/material.dart';
import 'package:flutter_application_1/Flashcards/models/Flashcard.dart';

class FlashcardWidget extends StatelessWidget {

  final Flashcard flashcard;
  const FlashcardWidget({super.key, required this.flashcard});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              flashcard.subject,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              flashcard.topic,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(flashcard.content),
          ],
        ),
      ),
    );
  }
}