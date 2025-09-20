class NewsItem {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final String author;

  const NewsItem({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.author,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'date': date.toIso8601String(),
      'author': author,
    };
  }

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      author: json['author'] ?? '',
    );
  }
}
