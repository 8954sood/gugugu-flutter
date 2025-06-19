import 'package:gugugu/domain/entities/comment.dart';
import 'package:gugugu/domain/entities/menu.dart';

class Restaurant {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String description;
  final String? imageUrl;
  final double averageRating;
  final int reviewCount;
  final List<Menu> menu;
  final List<Comment> comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.description,
    this.imageUrl,
    required this.averageRating,
    required this.reviewCount,
    required this.menu,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      averageRating: (json['averageRating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      menu: (json['menus'] as List<dynamic>)
          .map((e) => Menu.fromJson(e as Map<String, dynamic>))
          .toList(),
      comment: (json['reviews'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'imageUrl': imageUrl,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'menus': menu.map((e) => e.toJson()).toList(),
      'reviews': comment.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Restaurant copyWith({
    int? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? description,
    String? imageUrl,
    double? averageRating,
    int? reviewCount,
    List<Menu>? menu,
    List<Comment>? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      menu: menu ?? this.menu,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 