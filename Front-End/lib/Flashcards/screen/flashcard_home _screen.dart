import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Flashcards/generate_flashcard.dart';
import 'package:uuid/uuid.dart';
import '../models/Flashcard.dart';

class FlashcardScreen extends StatelessWidget {
  final String flashcardSetId;

  const FlashcardScreen({super.key, required this.flashcardSetId});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    Provider.of<GenerateFlashcard>(context, listen: false)
        .loadFlashcards(uid!, flashcardSetId);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const NavigationBarBottom(
                    initialIndex: 1,
                    learningTabBarIndex: 1,
                  )),
        );
        return false; // Prevent the default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Flash Cards",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavigationBarBottom(
                    initialIndex: 1,
                    learningTabBarIndex: 1,
                  ),
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('flashcardset')
                .doc(flashcardSetId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final flashcardSet = snapshot.data!;
              final flashcards = flashcardSet['flashcards'] as List<dynamic>;

              List<Flashcard> flashcardList = flashcards
                  .map((flashcard) => Flashcard.fromMap(flashcard))
                  .toList();

              if (flashcardList.isEmpty) {
                return const Center(
                  child: Text('No flashcards available'),
                );
              }

              return Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      final flashcard = flashcardList[index];
                      return Card(
                        elevation: 8,
                        color: const Color(0Xff93cec3),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Text(
                                  flashcard.topic,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                flashcard.content,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      flashcard.isMarked
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                    ),
                                    onPressed: () {
                                      Provider.of<GenerateFlashcard>(context,
                                              listen: false)
                                          .markFlashcard(
                                              uid,
                                              flashcardSetId,
                                              flashcard.id,
                                              !flashcard.isMarked);
                                                                        },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _showEditFlashcardDialog(context, uid,
                                          flashcard, flashcardSetId);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      Provider.of<GenerateFlashcard>(context,
                                              listen: false)
                                          .deleteFlashcard(uid,
                                              flashcardSetId, flashcard.id);
                                                                        },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: flashcardList.length,
                    itemWidth: MediaQuery.of(context).size.width * 0.9,
                    itemHeight: MediaQuery.of(context).size.height * 0.68,
                    layout: SwiperLayout.STACK,
                  ),
                  const SizedBox(),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddFlashcardDialog(context, uid);
          },
          child: const Icon(Icons.add),
        ),
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
              // TextField(
              //   controller: titleController,
              //   decoration: InputDecoration(labelText: 'Title'),
              // ),
              // TextField(
              //   controller: contentController,
              //   decoration: InputDecoration(labelText: 'Content'),
              // ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              TextField(
                controller: contentController,
                maxLines:
                    null, // Allows the TextField to expand vertically as needed
                keyboardType: TextInputType.multiline,
                minLines:
                    1, // Minimum number of lines the TextField should have
                decoration: InputDecoration(
                  labelText: 'Content',
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
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
