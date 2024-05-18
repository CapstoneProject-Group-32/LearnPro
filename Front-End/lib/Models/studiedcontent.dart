class Studiedcontent {
  String subject1 = '';
  String mainTopic1 = '';
  Map<String, List<String>> dataSetMap = {};
  Studiedcontent({
    required this.subject1,
    required this.mainTopic1,
    required this.dataSetMap,
  });

  Map<String, dynamic> toJson() => {
        'subject': subject1,
        'mainTopic': mainTopic1,
        'dataSetMap': dataSetMap,
      };

  factory Studiedcontent.fromJson(Map<String, dynamic> json) {
    return Studiedcontent(
      subject1: json['subject1'],
      mainTopic1: json['mainTopic1'],
      dataSetMap: Map<String, List<String>>.from(json['dataSetMap']),
    );
  }
}
