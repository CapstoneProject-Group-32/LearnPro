class Flashcard {
  final String id;
  final String subject;
  final String topic;
  final String content;

  Flashcard(
      {required this.id,
      required this.subject,
      required this.topic,
      required this.content});

  
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'],
      subject: json['subject'],
      topic: json['topic'],
      content: json['content'],
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

}
