class History {
  DateTime dateTime;
  int focusedSecs;

  History({
    required this.dateTime,
    required this.focusedSecs,
  });

  Map<String, dynamic> toJson() => {
        "dateTime": dateTime.toIso8601String(), // Store as ISO 8601 string
        "focusedSecs": focusedSecs,
      };

  History.fromJson(Map<String, dynamic> json)
      : dateTime =
            DateTime.parse(json['dateTime']), // Parse from ISO 8601 string
        focusedSecs = json['focusedSecs'];

  @override
  String toString() {
    return "\n{\n    dateTime: ${dateTime.toIso8601String()},\n    focusedSecs: $focusedSecs\n},\n";
  }
}
