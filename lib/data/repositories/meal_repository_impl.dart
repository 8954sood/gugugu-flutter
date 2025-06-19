import 'package:dio/dio.dart';
import 'package:gugugu/data/remote/datasources/meal_api.dart';
import 'package:gugugu/domain/entities/meal_review.dart';
import '../../domain/entities/meal.dart';
import '../../domain/repositories/meal_repository.dart';
import 'package:gugugu/data/local/datasources/meal_cache_datasource.dart';

const _mealTypeOrder = {
  '조식': 0,
  '중식': 1,
  '석식': 2,
};

class MealRepositoryImpl implements MealRepository {

  final MealApi _mealApi;
  final MealCacheDatasource _mealCache;

  MealRepositoryImpl(this._mealApi, this._mealCache);

  @override
  Future<List<Meal>> getMeals(DateTime startDate, DateTime endDate) async {
    final start = startDate.toString().split(' ')[0].replaceAll('-', '');
    final end = endDate.toString().split(' ')[0].replaceAll('-', '');
    final cached = await _mealCache.getMeals(start, end);
    if (cached != null) {
      return cached;
    }
    final response = await _mealApi.getMeals(
      startDate: start,
      endDate: end,
    );
    response.sort((a, b) {
      final orderA = _mealTypeOrder[a.mealType] ?? 99;
      final orderB = _mealTypeOrder[b.mealType] ?? 99;
      return orderA.compareTo(orderB);
    });
    _mealCache.setMeals(start, end, response);
    return response;
  }

  @override
  Future<List<MealReview>> getMealReviews(String mealDate, String mealType) async {
    final response = await _mealApi.getMealReviews(
      mealDate: mealDate,
      mealType: mealType,
    );
    return response;
  }

  @override
  Future<MealReview> createMealReview({
    required String mealDate,
    required String mealType,
    required String menu,
    required double rating,
    required String content,
  }) async {
    final response = await _mealApi.createMealReview(
      mealDate: mealDate,
      mealType: mealType,
      menu: menu,
      rating: rating,
      content: content,
    );
    return response;
  }

  @override
  Future<double> getAverageRating(String mealDate, String mealType) async {
    final response = await _mealApi.getAverageRating(
      mealDate: mealDate,
      mealType: mealType,
    );
    return response;
  }
} 