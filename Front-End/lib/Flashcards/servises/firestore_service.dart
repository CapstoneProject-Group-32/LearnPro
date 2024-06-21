// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:LearnPro/Flashcards/models/Flashcard.dart';


// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   Future<void> addFlashcard(Flashcard flashcard) {
//     return _db.collection('flashcards').doc(flashcard.id).set(flashcard.toJson());
//   }

//   Stream<List<Flashcard>> getFlashcards() {
//     return _db.collection('flashcards').snapshots().map((snapshot) =>
//         snapshot.docs.map((doc) => Flashcard.fromJson(doc.data())).toList());
//   }
// }