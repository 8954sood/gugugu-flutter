import 'package:gugugu/domain/entities/restaurant.dart';

class Menu {
  final String name;
  final int price;
  final DateTime createdAt;
  final DateTime updatedAt;

  Menu({
    required this.name,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      name: json['name'] as String,
      price: json['price'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
} 