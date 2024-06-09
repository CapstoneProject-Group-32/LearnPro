import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Flashcard.dart';
import 'flashcard_home _screen.dart';

class FlashcardLibraryScreen extends StatelessWidget {
  const FlashcardLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Flashcard Library'),
        ),
        body: const Center(
          child: Text('User not signed in'),
        ),
      );
    }

    final uid = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Library yyyyyyyy'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('flashcardset')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final flashcardSets = snapshot.data!.docs;

          return ListView.builder(
            itemCount: flashcardSets.length,
            itemBuilder: (context, index) {
              final flashcardSet = flashcardSets[index];
              final flashcards = flashcardSet['flashcards'] as List<dynamic>;
              final subject = flashcardSet['subject'];
              final date = flashcardSet['date'].toDate();
              final flashcardSetId = flashcardSet.id;

              List<Flashcard> flashcardList = flashcards
                  .map((flashcard) => Flashcard.fromMap(flashcard))
                  .toList();

              return ListTile(
                title: Text(subject),
                subtitle: Text('Created on: $date'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlashcardScreen(
                        flashcards: flashcardList,
                        flashcardSetId: flashcardSetId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
