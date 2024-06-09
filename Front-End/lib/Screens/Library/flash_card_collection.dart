import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Flashcards/models/Flashcard.dart';
import 'package:flutter_application_1/Flashcards/screen/flashcard_home%20_screen.dart';

class FlashCardCollectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        // appBar: AppBar(
        //   title: Text('Flashcard yyyy '),
        // ),
        body: Center(
          child: Text('User not signed in'),
        ),
      );
    }

    final uid = user.uid;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('flashcardset')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
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

              return GestureDetector(
                onLongPress: () {
                  _showDeleteDialog(context, uid, flashcardSetId);
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(
                      subject,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, String uid, String flashcardSetId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Flashcard Set'),
          content: Text('Are you sure you want to delete this flashcard set?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('flashcardset')
                    .doc(flashcardSetId)
                    .delete()
                    .then((_) {
                  Navigator.of(context).pop(); // Close the dialog
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Failed to delete flashcard set: $error')),
                  );
                });
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
