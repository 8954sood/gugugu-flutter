class Comment {
  final int id;
  final double rating;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({required this.id, required this.rating, required this.content, required this.createdAt, required this.updatedAt,});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      rating: (json['rating'] as num).toDouble(),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}