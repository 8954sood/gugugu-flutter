import 'package:gugugu/domain/entities/meal.dart';
import 'package:gugugu/domain/entities/meal_review.dart';
import 'package:dio/dio.dart';

class MealApi {
  final Dio _dio;
  final String baseUrl = 'http://10.80.162.236:8080';

  MealApi() : _dio = Dio() {
    _dio.options.baseUrl = 'http://10.80.162.236:8080';
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    responseHeader: false,
    responseBody: true,
    error: true,
    logPrint: print, // 로그 출력 방식 (기본: print)
    ));
  }

  Future<List<Meal>> getMeals({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _dio.get(
        '/api/meal',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Meal.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load meals');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load meals: ${e.message}');
    }
  }

  Future<List<MealReview>> getMealReviews({
    required String mealDate,
    required String mealType,
  }) async {
    try {
      final response = await _dio.get(
        '/api/meal-reviews',
        queryParameters: {
          'mealDate': mealDate,
          'mealType': mealType,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => MealReview.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load meal reviews');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load meal reviews: ${e.message}');
    }
  }

  Future<MealReview> createMealReview({
    required String mealDate,
    required String mealType,
    required double rating,
    required String content,
  }) async {
    try {
      final response = await _dio.post(
        '/api/meal-reviews',
        queryParameters: {
          'mealDate': mealDate,
          'mealType': mealType,
        },
        data: {
          'rating': rating,
          'content': content,
        },
      );

      if (response.statusCode == 201) {
        return MealReview.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create meal review');
      }
    } on DioException catch (e) {
      throw Exception('Failed to create meal review: ${e.message}');
    }
  }

  Future<double> getAverageRating({
    required String mealDate,
    required String mealType,
  }) async {
    try {
      final response = await _dio.get(
        '/api/meal-reviews/average-rating',
        queryParameters: {
          'mealDate': mealDate,
          'mealType': mealType,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get average rating');
      }
    } on DioException catch (e) {
      throw Exception('Failed to get average rating: ${e.message}');
    }
  }
} 