import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/question.dart';
import '../quiz_controler.dart';
import 'quiz_screen.dart';

class QuizHomescreen extends StatelessWidget {
  final String flashcardSetId;
  const QuizHomescreen({super.key, required this.flashcardSetId});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quizes'),
        ),
        body: const Center(
          child: Text('User not signed in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('flashcardset')
            .doc(flashcardSetId)
            .collection('quizes')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final quizes = snapshot.data!.docs;

          return ListView.builder(
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
                color: Theme.of(context).colorScheme.primary,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  title: Text('Quiz ${index + 1}'),
                  subtitle: Text('Created on: $formattedDate'),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: textColor,
                    ),
                    onPressed: () async {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete Quiz'),
                            content: const Text(
                                'Are you sure you want to delete this quiz?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldDelete == true) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('flashcardset')
                            .doc(flashcardSetId)
                            .collection('quizes')
                            .doc(quiz.id)
                            .delete();
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuizScreen(questions: questionList),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: TextButton(
      //   style: ButtonStyle(
      //     backgroundColor:  MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary),
      //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //       RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(10),
      //       ),
      //     ),
      //     shadowColor: MaterialStateProperty.all<Color>(Color(0x3F000000)),
      //     elevation: MaterialStateProperty.all<double>(4),
      //   ),
      //   onPressed: () async {
      //     showDialog(
      //       context: context,
      //       barrierDismissible: false,
      //       builder: (BuildContext context) {
      //         return const Dialog(
      //           child: Padding(
      //             padding: EdgeInsets.all(16.0),
      //             child: Row(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 CircularProgressIndicator(),
      //                 SizedBox(width: 16),
      //                 Text("Generating Quiz..."),
      //               ],
      //             ),
      //           ),
      //         );
      //       },
      //     );

      //     List<Question> questions;
      //     questions = await Provider.of<QuizController>(context, listen: false)
      //         .createQuiz(uid!, flashcardSetId);

      //     Navigator.pop(context);

      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => QuizScreen(questions: questions),
      //       ),
      //     );
      //   },
      //   child: Text(
      //     'Generate Quiz',
      //     style: TextStyle(
      //       color: textColor,
      //       fontSize: 17,
      //       fontFamily: 'Work Sans',
      //       fontWeight: FontWeight.w400,
      //     ),
      //   ),
      // ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Dialog(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text("Generating Quiz..."),
                    ],
                  ),
                ),
              );
            },
          );

          List<Question> questions;
          questions = await Provider.of<QuizController>(context, listen: false)
              .createQuiz(uid!, flashcardSetId);

          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(questions: questions),
            ),
          );
        },
        child: Container(
          width: 200,
          height: 50,
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: const Center(
            child: Text(
              'Generate Quiz',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
