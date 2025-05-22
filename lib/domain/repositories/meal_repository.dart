import 'package:gugugu/domain/entities/meal_review.dart';

import '../entities/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> getMeals(DateTime startDate, DateTime endDate);

  Future<List<MealReview>> getMealReviews(String mealDate, String mealType);

  Future<MealReview> createMealReview({
    required String mealDate,
    required String mealType,
    required double rating,
    required String content,
  });

  Future<double> getAverageRating(String mealDate, String mealType);
}