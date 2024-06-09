// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_application_1/Flashcards/generate_flashcard.dart';
// import '../utill/dialog_utils.dart';
// import 'flashcard_home _screen.dart';

// import 'flashcard_library_screen.dart';

// class CreateFlashcardScreen extends StatelessWidget {
//   final TextEditingController _subjectController = TextEditingController();
//   final TextEditingController _topicController = TextEditingController();
//   final TextEditingController _pointsController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Flashcard'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.library_books),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => FlashcardLibraryScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _subjectController,
//               decoration: InputDecoration(labelText: 'Subject'),
//             ),
//             TextField(
//               controller: _topicController,
//               decoration: InputDecoration(labelText: 'Topic'),
//             ),
//             TextField(
//               controller: _pointsController,
//               decoration: InputDecoration(labelText: 'Points'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final subject = _subjectController.text;
//                 final topic = _topicController.text;
//                 final points = _pointsController.text;

//                 if (subject.isNotEmpty && topic.isNotEmpty && points.isNotEmpty) {
//                   // Get the current user's ID
//                   final User? user = FirebaseAuth.instance.currentUser;
//                   if (user != null) {
//                     final uid = user.uid;

//                     try {
//                       // Show the loading dialog
//                       showLoadingDialog(context);

//                       final flashcards = await Provider.of<GenerateFlashcard>(context, listen: false)
//                           .createFlashcard(uid, subject, topic, points);

//                       // Hide the loading dialog
//                       hideLoadingDialog(context);

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => FlashcardScreen(flashcards: flashcards),
//                         ),
//                       );
//                     } catch (e) {
//                       // Hide the loading dialog in case of an error
//                       hideLoadingDialog(context);
//                       print('Error creating flashcards: $e');
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Failed to create flashcards')),
//                       );
//                     }
//                   } else {
//                     // Handle the case when the user is not signed in
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('User not signed in')),
//                     );
//                   }
//                 }
//               },
//               child: Text('Create'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Flashcards/generate_flashcard.dart';
import '../utill/dialog_utils.dart';
import 'flashcard_home _screen.dart';
import 'flashcard_library_screen.dart';

class CreateFlashcardScreen extends StatelessWidget {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();

  CreateFlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Flashcard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FlashcardLibraryScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(labelText: 'Topic'),
            ),
            TextField(
              controller: _pointsController,
              decoration: const InputDecoration(labelText: 'Points'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final subject = _subjectController.text;
                final topic = _topicController.text;
                final points = _pointsController.text;

                if (subject.isNotEmpty &&
                    topic.isNotEmpty &&
                    points.isNotEmpty) {
                  final User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final uid = user.uid;

                    try {
                      showLoadingDialog(context);

                      final flashcards = await Provider.of<GenerateFlashcard>(
                              context,
                              listen: false)
                          .createFlashcard(uid, subject, topic, points);

                      hideLoadingDialog(context);

                      final flashcardSetID =
                          Provider.of<GenerateFlashcard>(context, listen: false)
                              .flashcardSetId;

                      // Navigate with the correct flashcardSetId
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlashcardScreen(
                              flashcards: flashcards,
                              flashcardSetId: flashcardSetID),
                        ),
                      );
                    } catch (e) {
                      hideLoadingDialog(context);
                      print('Error creating flashcards: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to create flashcards')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User not signed in')),
                    );
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
