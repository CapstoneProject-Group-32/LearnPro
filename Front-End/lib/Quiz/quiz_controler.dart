import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'models/question.dart';
import 'servises/quiz_ai_servise.dart';

class QuizController with ChangeNotifier {
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
  final AIQuizService _aiService = AIQuizService();
  List<Question> _questions = [];

  late String quizId;

  List<Question> get questions => _questions;

  Future<List<Question>> createQuiz(String uid, String flashcardSetId) async {
    final snapshot = await _firestoreService
        .collection('users')
        .doc(uid)
        .collection('flashcardset')
        .doc(flashcardSetId)
        .get();

    final data = snapshot.data()!;
    final flashcardContent = data['flashcards'] as List<dynamic>;
    final content = await _aiService.generateQuizContent(flashcardContent.toString());
    final List<dynamic> parsedJson = jsonDecode(content);

    quizId = const Uuid().v4();
    final List<Question> newQuestions = [];

    for (var entry in parsedJson) {
      final question = Question(
        id: entry['id'],
        questionText: entry['questionText'],
        options: List<String>.from(entry['options']),
        correctOptionIndex: entry['correctOptionIndex'],
      );

      newQuestions.add(question);
    }

    _questions = newQuestions;
    await _firestoreService
        .collection('users')
        .doc(uid)
        .collection('flashcardset')
        .doc(flashcardSetId)
        .collection('quizes')
        .doc(quizId)
        .set({
      'date': DateTime.now(),
      'questions': newQuestions.map((q) => q.toMap()).toList(),
    });

    notifyListeners();
    return _questions ;
  }
  Future<List<Question>> fetchQuiz(String uid, String flashcardSetId,String quizId) async {
    final snapshot = await _firestoreService
        .collection('users')
        .doc(uid)
        .collection('flashcardset')
        .doc(flashcardSetId)
        .collection('quizes')
        .doc(quizId)
        .get();

    if (!snapshot.exists) {
      throw Exception('Quiz not found');
    }

    final data = snapshot.data()!;
    final questions = data['questions'] as List<dynamic>;
    final _questions = questions.map((q) {
          return Question.fromMap(q);
        }).toList();
    return _questions;
  }
}
