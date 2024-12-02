class News {
  final String id;
  final String title;
  final String body;
  final String date;
  final String imageUrl;

  News({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.imageUrl,
  });

  News.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        body = res["body"],
        date = res["date"],
        imageUrl = res["imageUrl"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'date': date,
      'imageUrl': imageUrl,
    };
  }
}
