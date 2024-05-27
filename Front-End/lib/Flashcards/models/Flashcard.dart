class Flashcard {
  final String id;
  final String subject;
  final String topic;
  final String content;
  bool isMarked;

  Flashcard(
      {required this.id,
      required this.subject,
      required this.topic,
      required this.content,
      this.isMarked = false, 
      });

  factory Flashcard.fromJson(String id, subject, Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'],
      subject: json['subject'],
      topic: json['title'] as String,
      content: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'topic': topic,
      'content': content,
    };
  }


  // Method to create a copy of the flashcard with updated fields
  Flashcard copyWith({
    String? id,
    String? subject,
    String? topic,
    String? content,
    bool? isMarked,
  }) {
    return Flashcard(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      content: content ?? this.content,
      isMarked: isMarked ?? this.isMarked,
    );
  }


  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      subject: map['subject'],
      topic: map['topic'],
      content: map['content'],
      isMarked: map['isMarked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'topic': topic,
      'content': content,
      'isMarked': isMarked,
    };
  }
}
