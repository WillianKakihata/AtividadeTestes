class DiaryEntry {
  final int id;
  final String title;
  final String content;
  final DateTime date;

  DiaryEntry({required this.id, required this.title, required this.content, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
    };
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
    );
  }
}
