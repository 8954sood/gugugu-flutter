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

final mockMenu = Menu(
  name: 'Test Menu',
  price: 10000,
  createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
  updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
);

final mockComment = Comment(
  id: 1,
  content: 'Test Comment',
  rating: 4.5,
  createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
  updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
);

final mockRestaurant = Restaurant(
  id: 1,
  name: 'Test Restaurant',
  address: 'Test Address',
  latitude: 37.5665,
  longitude: 126.9780,
  description: 'Test Description',
  averageRating: 4.5,
  reviewCount: 10,
  menu: [mockMenu],
  comment: [mockComment],
  createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
  updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
);

final mockReview = Review(
  id: 1,
  menu: 'Test Menu',
  mealDate: '2024-01-01',
  rating: 4.5,
  comment: 'Test Comment',
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