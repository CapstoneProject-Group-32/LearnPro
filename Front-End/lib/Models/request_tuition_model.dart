class TuitionModel {
  final String uid; // User ID of the sender
  final String receiverUid; // User ID of the receiver
  final String subject;
  final String lesson;
  final String date;
  final String time;
  final String
      senderUserName; // UserName of the sender (receiver's perspective)

  TuitionModel({
    required this.uid,
    required this.receiverUid,
    required this.subject,
    required this.lesson,
    required this.date,
    required this.time,
    required this.senderUserName,
  });

  Map<String, dynamic> toJSON() {
    return {
      'uid': uid,
      'receiverUid': receiverUid,
      'subject': subject,
      'lesson': lesson,
      'date': date,
      'time': time,
      'senderUserName': senderUserName,
    };
  }

  factory TuitionModel.fromJSON(Map<String, dynamic> json) {
    return TuitionModel(
      uid: json['uid'],
      receiverUid: json['receiverUid'],
      subject: json['subject'],
      lesson: json['lesson'],
      date: json['date'],
      time: json['time'],
      senderUserName: json['senderUserName'],
    );
  }
}
