

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Flashcards/models/Flashcard.dart';
import 'package:flutter_application_1/Flashcards/servises/generative_ai_service.dart';
import 'package:uuid/uuid.dart';

class GenerateFlashcard with ChangeNotifier {
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
  final GenerativeAIService _aiService = GenerativeAIService();
  List<Flashcard> _flashcards = [];

  late String flashcardSetId;

  List<Flashcard> get flashcards => _flashcards;

  Future<List<Flashcard>> createFlashcard(
      String uid, String subject, String topic, String points) async {
    final content =
        await _aiService.generateFlashcardContent(subject, topic, points);

    final List<dynamic> parsedJson = jsonDecode(content);

    flashcardSetId =
        const Uuid().v4(); // Use a unique ID for the flashcard set
    final List<Flashcard> newFlashcards = [];

    for (var entry in parsedJson) {
      final String topic = entry['title'];
      final String content = entry['body'];

      final flashcard = Flashcard(
        id: const Uuid().v4(),
        subject: subject,
        topic: topic,
        content: content,
      );

      newFlashcards.add(flashcard);
    }

    _flashcards = newFlashcards;
    await _firestoreService
        .collection('users')
        .doc(uid)
        .collection('flashcardset')
        .doc(flashcardSetId)
        .set({
      'date': DateTime.now(),
      'subject': subject,
      'flashcards': newFlashcards.map((fc) => fc.toMap()).toList(),
    });
    
    notifyListeners();
    return _flashcards;
  }
  

  Future<void> _updateFirestoreFlashcards(
      String uid, String flashcardSetId) async {
    await _firestoreService
        .collection('users')
        .doc(uid)
        .collection('flashcardset')
        .doc(flashcardSetId)
        .update({
      'flashcards': _flashcards.map((fc) => fc.toMap()).toList(),
    });
  }

  Future<void> loadFlashcards(String uid, String flashcardSetId) async {
    try {
      final snapshot = await _firestoreService
          .collection('users')
          .doc(uid)
          .collection('flashcardset')
          .doc(flashcardSetId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        final flashcards = data['flashcards'] as List<dynamic>;

        _flashcards = flashcards.map((flashcard) {
          return Flashcard.fromMap(flashcard);
        }).toList();
        
        this.flashcardSetId = flashcardSetId;
        notifyListeners();
      } else {
        _flashcards = [];
        notifyListeners();
      }
    } catch (e) {
      // Handle errors
      print('Failed to load flashcards: $e');
    }
  }

  Future<void> addFlashcard(
      String uid, String flashcardSetId, Flashcard flashcard) async {
    _flashcards.add(flashcard);
    await _updateFirestoreFlashcards(uid, flashcardSetId);
    notifyListeners();
  }

  Future<void> deleteFlashcard(
      String uid, String flashcardSetId, String flashcardId) async {
    _flashcards.removeWhere((flashcard) => flashcard.id == flashcardId);
    await _updateFirestoreFlashcards(uid, flashcardSetId);
    notifyListeners();
  }

  Future<void> editFlashcard(
      String uid, String flashcardSetId, Flashcard updatedFlashcard) async {
    final index = _flashcards
        .indexWhere((flashcard) => flashcard.id == updatedFlashcard.id);
    if (index != -1) {
      _flashcards[index] = updatedFlashcard;
      await _updateFirestoreFlashcards(uid, flashcardSetId);
      notifyListeners();
    }
  }

  Future<void> markFlashcard(String uid, String flashcardSetId,
      String flashcardId, bool isMarked) async {
    final index =
        _flashcards.indexWhere((flashcard) => flashcard.id == flashcardId);
    if (index != -1) {
      _flashcards[index] = _flashcards[index].copyWith(isMarked: isMarked);
      await _updateFirestoreFlashcards(uid, flashcardSetId);
      notifyListeners();
    }
  }
}
