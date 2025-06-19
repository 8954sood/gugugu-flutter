import 'package:dio/dio.dart';
import 'package:gugugu/domain/entities/meal.dart';
import 'package:gugugu/domain/entities/meal_review.dart';
import 'package:gugugu/domain/entities/restaurant.dart';
import 'package:gugugu/domain/entities/menu.dart';
import 'package:gugugu/domain/entities/review.dart';
import 'package:gugugu/domain/entities/comment.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([Dio])
class MockDioHelper  {

}

const mockMeal = Meal(
  mealDate: '20240619',
  mealType: '중식',
  menu: 'Test',
  calorie: 'Test',
  mealInfo: 'Test Info',
  averageRating: 0.0,
);

final mockMealReview = MealReview(
  id: 0,
  menu: "Test",
  rating: 4.5,
  comment: "comment",
  createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
  updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
);

Response<T> successResponse<T>(T data, {int statusCode = 200}) {
  return Response(
    data: data,
    statusCode: statusCode,
    requestOptions: RequestOptions(path: ''),
  );
}

Response<T> errorResponse<T>({int statusCode = 400}) {
  return Response(
    data: null,
    statusCode: statusCode,
    requestOptions: RequestOptions(path: ''),
  );
} 