import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/flashcard_model.dart';
import 'package:flutter_application_1/services/generative_ai_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:uuid/uuid.dart';

class FlashcardProvider with ChangeNotifier {
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
  final GenerativeAIService _aiService = GenerativeAIService();
  List<Flashcard> _flashcards = [];

  List<Flashcard> get flashcards => _flashcards;

  Future<void> createFlashcard(
    
      String subject, String topic, String points) async {
    final content =
        await _aiService.generateFlashcardContent(subject, topic, points);
    final flashcard = Flashcard(
        id: const Uuid().v4(),
        subject: subject,
        topic: topic,
        content: content);
    await _firestoreService
        .collection('flashcards')
        .doc(flashcard.id)
        .set(flashcard.toJson());
    _flashcards.add(flashcard);
    notifyListeners();
  }

  Stream<List<Flashcard>> fetchFlashcards() {
    return _firestoreService.collection('flashcards').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Flashcard.fromJson(doc.data() as Map<String, dynamic>)).toList()
    );
  }
}

