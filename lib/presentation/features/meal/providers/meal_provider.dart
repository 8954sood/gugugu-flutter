import 'package:flutter/foundation.dart';
import 'package:gugugu/domain/entities/meal.dart';
import 'package:gugugu/domain/entities/meal_review.dart';
import 'package:gugugu/domain/repositories/meal_repository.dart';

class MealProvider with ChangeNotifier {
  final MealRepository _mealRepository;

  List<Meal> _meals = [];
  bool _isLoading = false;
  String? _error;

  MealProvider(this._mealRepository);

  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMeals(DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _meals = await _mealRepository.getMeals(startDate, endDate);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<double> getAverageRating(String mealDate, String mealType) async {
    try {
      return await _mealRepository.getAverageRating(mealDate, mealType);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
} 