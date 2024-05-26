import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';


import '../models/Flashcard.dart';
import '../widgets/flashcard_widget.dart';

class FlashcardScreen extends StatefulWidget {
  final List<Flashcard> flashcards;
  const FlashcardScreen({
    Key? key,
    required this.flashcards,
  }) : super(key: key);
  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  
  int _currIndex = 0;
  bool marked = false;

  @override
  Widget build(BuildContext context) {
    // List<Flashcard> flashcards = widget.flashcards;
    return Scaffold(
      appBar: AppBar(title: Text("Flashcards"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: FlipCard(
                fill: Fill.fillBack,
                front: FlashcardWidget(flashcard: widget.flashcards[_currIndex]),
                back: FlashcardWidget(flashcard: widget.flashcards[_currIndex]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                    onPressed: previousCard,
                    icon: Icon(Icons.chevron_left),
                    label: Text("prev")),
                OutlinedButton.icon(
                    onPressed: nextCard,
                    icon: Icon(Icons.chevron_right),
                    label: Text("next")),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                    label: Text("Edit")),
                OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        marked = !marked;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: marked
                          ? MaterialStatePropertyAll(
                              const Color.fromARGB(255, 127, 230, 131))
                          : MaterialStatePropertyAll(Colors.transparent),
                    ),
                    icon: Icon(Icons.check),
                    label: Text("Mark")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void nextCard() {
    // List<Flashcard> flashcards = widget.flashcards;
    setState(() {
      _currIndex = (_currIndex + 1 < widget.flashcards.length) ? _currIndex + 1 : 0;
    });
  }

  void previousCard() {
    // List<Flashcard> flashcards = widget.flashcards;
    setState(() {
      _currIndex =
          (_currIndex - 1 >= 0) ? _currIndex - 1 : widget.flashcards.length - 1;
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Flashcards/models/Flashcard.dart';
// import 'package:flutter_application_1/Flashcards/generate_flashcard.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FlashcardScreen extends StatelessWidget {
//   final List<Flashcard> flashcards;
//   final String flashcardSetId;

//   FlashcardScreen({required this.flashcards, required this.flashcardSetId});

//   @override
//   Widget build(BuildContext context) {
//     final uid = FirebaseAuth.instance.currentUser?.uid;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flashcards'),
//       ),
//       body: ListView.builder(
//         itemCount: flashcards.length,
//         itemBuilder: (context, index) {
//           final flashcard = flashcards[index];
//           return ListTile(
//             title: Text(flashcard.topic),
//             subtitle: Text(flashcard.content),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(flashcard.isMarked ? Icons.check_box : Icons.check_box_outline_blank),
//                   onPressed: () {
//                     if (uid != null) {
//                       Provider.of<GenerateFlashcard>(context, listen: false)
//                           .markFlashcard(uid, flashcardSetId, flashcard.id, !flashcard.isMarked);
//                     }
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     if (uid != null) {
//                       Provider.of<GenerateFlashcard>(context, listen: false)
//                           .deleteFlashcard(uid, flashcardSetId, flashcard.id);
//                     }
//                   },
//                 ),
//               ],
//             ),
//             onLongPress: () {
//               _showEditFlashcardDialog(context, uid, flashcard, flashcardSetId);
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddFlashcardDialog(context, uid);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   void _showAddFlashcardDialog(BuildContext context, String? uid) {
//     final TextEditingController titleController = TextEditingController();
//     final TextEditingController contentController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Add Flashcard'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: InputDecoration(labelText: 'Title'),
//               ),
//               TextField(
//                 controller: contentController,
//                 decoration: InputDecoration(labelText: 'Content'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (uid != null) {
//                   final newFlashcard = Flashcard(
//                     id: const Uuid().v4(),
//                     subject: 'subject', // Set appropriate subject
//                     topic: titleController.text,
//                     content: contentController.text,
//                   );

//                   Provider.of<GenerateFlashcard>(context, listen: false)
//                       .addFlashcard(uid, flashcardSetId, newFlashcard)
//                       .then((_) {
//                     Navigator.pop(context);
//                   });
//                 }
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showEditFlashcardDialog(BuildContext context, String? uid, Flashcard flashcard, String flashcardSetId) {
//     final TextEditingController titleController = TextEditingController(text: flashcard.topic);
//     final TextEditingController contentController = TextEditingController(text: flashcard.content);

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit Flashcard'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: InputDecoration(labelText: 'Title'),
//               ),
//               TextField(
//                 controller: contentController,
//                 decoration: InputDecoration(labelText: 'Content'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (uid != null) {
//                   final editedFlashcard = Flashcard(
//                     id: flashcard.id,
//                     subject: flashcard.subject,
//                     topic: titleController.text,
//                     content: contentController.text,
//                     isMarked: flashcard.isMarked,
//                   );

//                   Provider.of<GenerateFlashcard>(context, listen: false)
//                       .editFlashcard(uid, flashcardSetId, editedFlashcard)
//                       .then((_) {
//                     Navigator.pop(context);
//                   });
//                 }
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

