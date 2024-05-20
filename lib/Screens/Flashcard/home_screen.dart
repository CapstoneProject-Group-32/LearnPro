// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/flashcard/flashcard_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/flashcard_provider.dart';
import 'package:flutter_application_1/Screens/Flashcard/create_flashcard_screen.dart';
import 'package:flutter_application_1/Models/flashcard_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final flashcardProvider = Provider.of<FlashcardProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards'),
      ),
      body: ListView.builder(
        itemCount: flashcardProvider.flashcards.length,
        itemBuilder: (context, index) {
          return FlashcardWidget(flashcard: flashcardProvider.flashcards[index] ,);
        },
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
