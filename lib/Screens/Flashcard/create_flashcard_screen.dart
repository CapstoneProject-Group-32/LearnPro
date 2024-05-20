// lib/screens/create_flashcard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/flashcard_provider.dart';

class CreateFlashcardScreen extends StatelessWidget {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Flashcard'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: _topicController,
              decoration: InputDecoration(labelText: 'Topic'),
            ),
            TextField(
              controller: _pointsController,
              decoration: InputDecoration(labelText: 'Points'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final subject = _subjectController.text;
                final topic = _topicController.text;
                final points = _pointsController.text;

                if (subject.isNotEmpty && topic.isNotEmpty && points.isNotEmpty) {
                  Provider.of<FlashcardProvider>(context, listen: false)
                      .createFlashcard(subject, topic, points)
                      .then((_) {
                    Navigator.pop(context);
                  });
                }
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
