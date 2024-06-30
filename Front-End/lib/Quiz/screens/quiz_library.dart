import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Quiz/models/question.dart';
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
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(134, 255, 255, 255)
        : const Color.fromARGB(120, 0, 0, 0);
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
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return  const Center(child: Text('No quizzes available.'));
            } else {
              final flashcardSets = snapshot.data!.docs;

              return ListView.builder(
                controller: _outerScrollController,
                itemCount: flashcardSets.length,
                itemBuilder: (context, index) {
                  final flashcardSet = flashcardSets[index];
                  final subject = flashcardSet['subject'];
                  final flashcardSetId = flashcardSet.id;

                  return StreamBuilder<QuerySnapshot>(
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
                      } else if (!quizSnapshot.hasData ||
                          quizSnapshot.data!.docs.isEmpty) {
                        return const SizedBox
                            .shrink(); // Hide the flashcard set if there are no quizzes
                      } else {
                        final quizes = quizSnapshot.data!.docs;
                        final ScrollController _innerScrollController =
                            ScrollController();

                        return GestureDetector(
                          child: Card(
                            color: Theme.of(context).colorScheme.primary,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // Add this line
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(
                                      8.0), // Add padding to the subject
                                  child: Text(
                                    subject,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17),
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(maxHeight: 200),
                                  child: RawScrollbar(
                                    controller: _innerScrollController,
                                    thumbVisibility: true,
                                    thickness: 6.0,
                                    radius: const Radius.circular(10),
                                    thumbColor: textColor,
                                    child: ListView.builder(
                                      controller: _innerScrollController,
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: quizes.length,
                                      itemBuilder: (context, index) {
                                        final quiz = quizes[index];
                                        final questions =
                                            quiz['questions'] as List<dynamic>;

                                        List<Question> questionList =
                                            questions.map((q) {
                                          return Question.fromMap(
                                              q as Map<String, dynamic>);
                                        }).toList();

                                        return Container(
                                          height: 45,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          margin: const EdgeInsets.fromLTRB(
                                              8, 4, 12, 4),
                                          child: ListTile(
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 2, 0, 7),
                                              child: Text(
                                                'Quiz ${index + 1}',
                                                style: TextStyle(fontSize: 13),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuizScreen(
                                                          questions:
                                                              questionList),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }
          }),
    );
  }

  @override
  void dispose() {
    _outerScrollController.dispose();
    super.dispose();
  }
}
