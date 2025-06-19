import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:gugugu/data/remote/datasources/meal_api.dart';
import 'package:gugugu/domain/entities/meal.dart';
import 'package:gugugu/domain/entities/meal_review.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/test_helpers.mocks.dart';

void main() {
  late MockDio mockDio;
  late MealApi mealApi;

  setUp(() {
    mockDio = MockDio();
    mealApi = MealApi(mockDio);
  });

  group('MealApi', () {
    test('load meal', () async {
      when(mockDio.get(
        '/api/meal',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => successResponse([mockMeal.toJson()]));

      final result = await mealApi.getMeals(startDate: '20250619', endDate: '20250619');
      expect(result, isA<List<Meal>>());
      expect(result.first.menu, mockMeal.menu);
    });

    test('load meal review data', () async {
      when(mockDio.get(
        '/api/meal-reviews',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => successResponse([mockMealReview.toJson()]));

      final result = await mealApi.getMealReviews(mealDate: '20250619', mealType: '중식');
      expect(result, isA<List<MealReview>>());
      expect(result.first.menu, mockMeal.menu);
    });

    test('create meal review', () async {
      when(mockDio.post(
        '/api/meal-reviews',
        queryParameters: anyNamed('queryParameters'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => successResponse(mockMealReview.toJson()));

      final result = await mealApi.createMealReview(
        mealDate: '20250619',
        mealType: '중식',
        rating: 4.5,
        content: 'content',
        menu: 'test',
      );
      expect(result, isA<MealReview>());
      expect(result.menu, mockMealReview.menu);
    });

    test('get meal average rating', () async {
      when(mockDio.get(
        '/api/meal-reviews/average-rating',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => successResponse(4.5));

      final result = await mealApi.getAverageRating(mealDate: '2024-01-01', mealType: 'lunch');
      expect(result, 4.5);
    });
  });
} 