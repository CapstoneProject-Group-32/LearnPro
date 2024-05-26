// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Flashcards/generate_flashcard.dart';
import 'package:flutter_application_1/Flashcards/widgets/flashcard_widget.dart';
import 'package:provider/provider.dart';

import 'create_flashcard_screen.dart';



class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final flashcardProvider = Provider.of<GenerateFlashcard>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateFlashcardScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
