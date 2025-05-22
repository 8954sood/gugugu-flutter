import 'package:gugugu/domain/entities/meal.dart';

class MealReview {
  final int id;
  final String menu;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MealReview({
    required this.id,
    required this.menu,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MealReview.fromJson(Map<String, dynamic> json) {
    return MealReview(
      id: json['id'] as int,
      menu: json['menu'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
} 