import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Quiz/models/question.dart';
import '../../Flashcards/models/Flashcard.dart';
import 'quiz_screen.dart';

class QuizLibraryWidget extends StatefulWidget {
  const QuizLibraryWidget({super.key});

  @override
  _QuizLibraryWidgetState createState() => _QuizLibraryWidgetState();
}

class _QuizLibraryWidgetState extends State<QuizLibraryWidget> {
  final ScrollController _outerScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
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
            return const Center(child: CircularProgressIndicator());
          }

          final flashcardSets = snapshot.data!.docs;

          return Scrollbar(
            controller: _outerScrollController,
            thumbVisibility: true,
            child: ListView.builder(
              controller: _outerScrollController,
              itemCount: flashcardSets.length,
              itemBuilder: (context, index) {
                final flashcardSet = flashcardSets[index];
                final flashcards = flashcardSet['flashcards'] as List<dynamic>;
                final subject = flashcardSet['subject'];
                final date = flashcardSet['date'].toDate();
                final flashcardSetId = flashcardSet.id;
                final formattedDate = DateFormat('yyyy-MM-dd').format(date);

                List<Flashcard> flashcardList = flashcards
                    .map((flashcard) => Flashcard.fromMap(flashcard))
                    .toList();

                return GestureDetector(
                  child: Card(
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            subject,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .collection('flashcardset')
                              .doc(flashcardSetId)
                              .collection('quizes')
                              .snapshots(),
                          builder: (context, quizSnapshot) {
                            if (quizSnapshot.hasError) {
                              return Text('Error: ${quizSnapshot.error}');
                            } else if (!quizSnapshot.hasData || quizSnapshot.data!.docs.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('No quizzes available'),
                              );
                            } else {
                              final quizes = quizSnapshot.data!.docs;
                              final ScrollController _innerScrollController = ScrollController();

                              return Container(
                                constraints: BoxConstraints(maxHeight: 200),
                                child: Scrollbar(
                                  controller: _innerScrollController,
                                  thumbVisibility: true,
                                  thickness: 10.0, 
                                  child: ListView.builder(
                                    controller: _innerScrollController,
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: quizes.length,
                                    itemBuilder: (context, index) {
                                      final quiz = quizes[index];
                                      final questions = quiz['questions'] as List<dynamic>;
                                      final Timestamp timestamp = quiz['date'];
                                      final DateTime date = timestamp.toDate();
                                      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

                                      List<Question> questionList = questions.map((q) {
                                        return Question.fromMap(q as Map<String, dynamic>);
                                      }).toList();

                                      return Card(
                                        elevation: 2,
                                        color: Theme.of(context).colorScheme.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        child: ListTile(
                                          title: Text('Quiz ${index + 1}', ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => QuizScreen(questions: questionList),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _outerScrollController.dispose();
    super.dispose();
  }
}

