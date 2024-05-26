
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Flashcards/models/Flashcard.dart';

import 'package:uuid/uuid.dart';

import 'servises/generative_ai_service.dart';

class GenerateFlashcard with ChangeNotifier {
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
  final GenerativeAIService _aiService = GenerativeAIService();
  List<Flashcard> _flashcards = [];

  List<Flashcard> get flashcards => _flashcards;

  Future<List<Flashcard>> createFlashcard(String uid, String subject, String topic, String points) async {
    final content = await _aiService.generateFlashcardContent(subject, topic, points);

    try {
      // Parse the JSON array
      final List<dynamic> parsedJson = jsonDecode(content);

      // Clear existing flashcards
      _flashcards.clear();

      for (var entry in parsedJson) {
        final String topic = entry['title'];
        final String content = entry['body'];

        final flashcard = Flashcard(
          id: const Uuid().v4(),
          subject: subject,
          topic: topic,
          content: content,
        );

        _flashcards.add(flashcard);
      }

      // Save the flashcard set to Firestore
      final flashcardSetId = const Uuid().v4();
      final flashcardSetData = {
        'date': DateTime.now(),
        'subject': subject,
        'flashcards': _flashcards.map((f) => f.toMap()).toList(),
      };

      await _firestoreService
          .collection('users')
          .doc(uid)
          .collection('flashcardset')
          .doc(flashcardSetId)
          .set(flashcardSetData);

      notifyListeners();
      return _flashcards;
    } catch (e) {
      print('Error parsing flashcard content: $e');
      throw FormatException('Error parsing flashcard content');
    }
  }
}

// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Flashcards/models/Flashcard.dart';
// import 'package:flutter_application_1/Flashcards/servises/generative_ai_service.dart';
// import 'package:uuid/uuid.dart';

// class GenerateFlashcard with ChangeNotifier {
//   final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
//   final GenerativeAIService _aiService = GenerativeAIService();
//   List<Flashcard> _flashcards = [];

//   List<Flashcard> get flashcards => _flashcards;

//   Future<List<Flashcard>> createFlashcard(String subject, String topic, String points) async {
//     final content = await _aiService.generateFlashcardContent(subject, topic, points);

//     final List<dynamic> parsedJson = jsonDecode(content);

//     for (var entry in parsedJson) {
//       final String title = entry['title'];
//       final String body = entry['body'];

//       final flashcard = Flashcard(
//         id: const Uuid().v4(),
//         subject: subject,
//         topic: title,
//         content: body,
//       );

//       _flashcards.add(flashcard);
//       notifyListeners();
//     }
//     return _flashcards;
//   }

//   Future<void> _updateFirestoreFlashcards(String uid, String flashcardSetId) async {
//     final flashcardSetRef = _firestoreService
//         .collection('users')
//         .doc(uid)
//         .collection('flashcardset')
//         .doc(flashcardSetId);

//     final flashcardsData = _flashcards.map((flashcard) => flashcard.toMap()).toList();

//     await flashcardSetRef.update({
//       'flashcards': flashcardsData,
//     });
//   }

//   Future<void> addFlashcard(String uid, String flashcardSetId, Flashcard newFlashcard) async {
//     _flashcards.add(newFlashcard);
//     await _updateFirestoreFlashcards(uid, flashcardSetId);
//     notifyListeners();
//   }

//   Future<void> editFlashcard(String uid, String flashcardSetId, Flashcard editedFlashcard) async {
//     final index = _flashcards.indexWhere((flashcard) => flashcard.id == editedFlashcard.id);
//     if (index != -1) {
//       _flashcards[index] = editedFlashcard;
//       await _updateFirestoreFlashcards(uid, flashcardSetId);
//       notifyListeners();
//     }
//   }

//   Future<void> deleteFlashcard(String uid, String flashcardSetId, String flashcardId) async {
//     _flashcards.removeWhere((flashcard) => flashcard.id == flashcardId);
//     await _updateFirestoreFlashcards(uid, flashcardSetId);
//     notifyListeners();
//   }

//   Future<void> markFlashcard(String uid, String flashcardSetId, String flashcardId, bool isMarked) async {
//     final index = _flashcards.indexWhere((flashcard) => flashcard.id == flashcardId);
//     if (index != -1) {
//       _flashcards[index].isMarked = isMarked;
//       await _updateFirestoreFlashcards(uid, flashcardSetId);
//       notifyListeners();
//     }
//   }
// }

