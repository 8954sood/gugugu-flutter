import 'package:flutter/foundation.dart';
import 'package:gugugu/domain/entities/meal.dart';
import 'package:gugugu/domain/entities/meal_review.dart';
import 'package:gugugu/domain/repositories/meal_repository.dart';

class MealDetailProvider with ChangeNotifier {
  final MealRepository _mealRepository;
  List<MealReview> _comments = [];
  bool _isLoading = false;
  String? _error;

  MealDetailProvider(this._mealRepository);

  List<MealReview> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get rating => _comments.isEmpty
      ? 0.0
      : _comments.fold(0.0, (sum, review) => sum + review.rating) / _comments.length;

  Future<void> loadComments(Meal meal) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _comments = await _mealRepository.getMealReviews(meal.mealDate, meal.mealType);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitRating(Meal meal, double rating, String content) async {
    try {
      final res = await _mealRepository.createMealReview(
        mealDate: meal.mealDate,
        mealType: meal.mealType,
        menu: meal.menu,
        rating: rating,
        content: content,
      );
      _comments.add(res);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}