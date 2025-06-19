class Meal {
  final String mealDate;
  final String mealType;
  final String menu;
  final String calorie;
  final String mealInfo;
  final double averageRating;

  const Meal({
    required this.mealDate,
    required this.mealType,
    required this.menu,
    required this.calorie,
    required this.mealInfo,
    required this.averageRating,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealDate: json['mealDate'] as String,
      mealType: json['mealType'] as String,
      menu: json['menu'] as String,
      calorie: json['calorie'] as String,
      mealInfo: json['mealInfo'] as String,
      averageRating: ((json['averageRating'] as num?) ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mealDate': mealDate,
      'mealType': mealType,
      'menu': menu,
      'calorie': calorie,
      'mealInfo': mealInfo,
      'averageRating': averageRating,
    };
  }

  Meal copyWith({
    String? mealDate,
    String? mealType,
    String? menu,
    String? calorie,
    String? mealInfo,
    double? averageRating,
  }) {
    return Meal(
      mealDate: mealDate ?? this.mealDate,
      mealType: mealType ?? this.mealType,
      menu: menu ?? this.menu,
      calorie: calorie ?? this.calorie,
      mealInfo: mealInfo ?? this.mealInfo,
      averageRating: averageRating ?? this.averageRating,
    );
  }

} 