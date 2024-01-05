class Comment {
  final String id;
  final String text;
  final String blogId; // assuming blogId is a String in your Node.js model
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    required this.id,
    required this.text,
    required this.blogId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      text: json['text'],
      blogId: json['blog'], // Make sure to adjust this based on your Node.js model
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
