// import 'package:flutter/material.dart';
// import 'package:flip_card/flip_card.dart';

// import '../models/Flashcard.dart';
// import '../widgets/flashcard_widget.dart';

// class FlashcardScreen extends StatefulWidget {
//   final List<Flashcard> flashcards;
//   const FlashcardScreen({
//     Key? key,
//     required this.flashcards,
//   }) : super(key: key);
//   @override
//   State<FlashcardScreen> createState() => _FlashcardScreenState();
// }

// class _FlashcardScreenState extends State<FlashcardScreen> {

//   int _currIndex = 0;
//   bool marked = false;

//   @override
//   Widget build(BuildContext context) {
//     // List<Flashcard> flashcards = widget.flashcards;
//     return Scaffold(
//       appBar: AppBar(title: Text("Flashcards"),),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               child: FlipCard(
//                 fill: Fill.fillBack,
//                 front: FlashcardWidget(flashcard: widget.flashcards[_currIndex]),
//                 back: FlashcardWidget(flashcard: widget.flashcards[_currIndex]),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 OutlinedButton.icon(
//                     onPressed: previousCard,
//                     icon: Icon(Icons.chevron_left),
//                     label: Text("prev")),
//                 OutlinedButton.icon(
//                     onPressed: nextCard,
//                     icon: Icon(Icons.chevron_right),
//                     label: Text("next")),
//               ],
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 OutlinedButton.icon(
//                     onPressed: () {},
//                     icon: Icon(Icons.edit),
//                     label: Text("Edit")),
//                 OutlinedButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         marked = !marked;
//                       });
//                     },
//                     style: ButtonStyle(
//                       backgroundColor: marked
//                           ? MaterialStatePropertyAll(
//                               const Color.fromARGB(255, 127, 230, 131))
//                           : MaterialStatePropertyAll(Colors.transparent),
//                     ),
//                     icon: Icon(Icons.check),
//                     label: Text("Mark")),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void nextCard() {
//     // List<Flashcard> flashcards = widget.flashcards;
//     setState(() {
//       _currIndex = (_currIndex + 1 < widget.flashcards.length) ? _currIndex + 1 : 0;
//     });
//   }

//   void previousCard() {
//     // List<Flashcard> flashcards = widget.flashcards;
//     setState(() {
//       _currIndex =
//           (_currIndex - 1 >= 0) ? _currIndex - 1 : widget.flashcards.length - 1;
//     });
//   }
// }

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Flashcards/generate_flashcard.dart';
import '../models/Flashcard.dart';
import 'package:uuid/uuid.dart';

import 'flashcard_library_screen.dart';

class FlashcardScreen extends StatelessWidget {
  final List<Flashcard> flashcards;
  final String flashcardSetId;

  const FlashcardScreen({super.key, required this.flashcards, required this.flashcardSetId});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
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
      body: Consumer<GenerateFlashcard>(
          builder: (context, generateFlashcard, child) {
        return Swiper(
          itemBuilder: (BuildContext context, int index) {
            final flashcard = flashcards[index];
            return Card(
              color: const Color.fromARGB(255, 69, 248, 233),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      flashcard.topic,
                      style:
                          const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(flashcard.content),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(
                            flashcard.isMarked
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
                          onPressed: () {
                            if (uid != null) {
                              Provider.of<GenerateFlashcard>(context,
                                      listen: false)
                                  .markFlashcard(uid, flashcardSetId,
                                      flashcard.id, !flashcard.isMarked);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditFlashcardDialog(
                                context, uid, flashcard, flashcardSetId);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            if (uid != null) {
                              Provider.of<GenerateFlashcard>(context,
                                      listen: false)
                                  .deleteFlashcard(
                                      uid, flashcardSetId, flashcard.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: flashcards.length,
          itemWidth: MediaQuery.of(context).size.width * 0.8,
          itemHeight: MediaQuery.of(context).size.height * 0.6,
          layout: SwiperLayout.STACK,
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFlashcardDialog(context, uid);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddFlashcardDialog(BuildContext context, String? uid) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Flashcard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (uid != null) {
                  final newFlashcard = Flashcard(
                    id: const Uuid().v4(),
                    subject: 'subject', // Set appropriate subject
                    topic: titleController.text,
                    content: contentController.text,
                  );

                  Provider.of<GenerateFlashcard>(context, listen: false)
                      .addFlashcard(uid, flashcardSetId, newFlashcard)
                      .then((_) {
                    Navigator.pop(context);
                  });
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditFlashcardDialog(BuildContext context, String? uid,
      Flashcard flashcard, String flashcardSetId) {
    final TextEditingController titleController =
        TextEditingController(text: flashcard.topic);
    final TextEditingController contentController =
        TextEditingController(text: flashcard.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Flashcard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (uid != null) {
                  final editedFlashcard = Flashcard(
                    id: flashcard.id,
                    subject: flashcard.subject,
                    topic: titleController.text,
                    content: contentController.text,
                    isMarked: flashcard.isMarked,
                  );

                  Provider.of<GenerateFlashcard>(context, listen: false)
                      .editFlashcard(uid, flashcardSetId, editedFlashcard)
                      .then((_) {
                    Navigator.pop(context);
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
