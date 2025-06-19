import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gugugu/data/remote/datasources/restaurant_api.dart';
import 'package:gugugu/domain/entities/restaurant.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/test_helpers.mocks.dart';

void main() {
  late RestaurantApi restaurantApi;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    restaurantApi = RestaurantApi(mockDio);
  });

  group('createRestaurant', () {
    test('should return created restaurant when API call is successful', () async {
      // arrange
      when(mockDio.post(
        '/api/restaurants',
        data: mockRestaurant.toJson(),
      )).thenAnswer(
        (_) async => successResponse(mockRestaurant.toJson(), statusCode: 201),
      );

      // act
      final result = await restaurantApi.createRestaurant(mockRestaurant);

      // assert
      expect(result, isA<Restaurant>());
      expect(result.id, mockRestaurant.id);
      verify(mockDio.post(
        '/api/restaurants',
        data: mockRestaurant.toJson(),
      )).called(1);
    });

    test('should throw exception when API call is unsuccessful', () async {
      // arrange
      when(mockDio.post(
        '/api/restaurants',
        data: mockRestaurant.toJson(),
      )).thenAnswer(
        (_) async => errorResponse(),
      );

      // act & assert
      expect(() => restaurantApi.createRestaurant(mockRestaurant), throwsException);
      verify(mockDio.post(
        '/api/restaurants',
        data: mockRestaurant.toJson(),
      )).called(1);
    });
  });

  group('updateRestaurant', () {
    test('should return updated restaurant when API call is successful', () async {
      // arrange
      when(mockDio.put(
        '/api/restaurants/1',
        data: mockRestaurant.toJson(),
      )).thenAnswer(
        (_) async => successResponse(mockRestaurant.toJson()),
      );

      // act
      final result = await restaurantApi.updateRestaurant(mockRestaurant);

      // assert
      expect(result, isA<Restaurant>());
      expect(result.id, mockRestaurant.id);
      verify(mockDio.put(
        '/api/restaurants/1',
        data: mockRestaurant.toJson(),
      )).called(1);
    });

    test('should throw exception when API call is unsuccessful', () async {
      // arrange
      when(mockDio.put(
        '/api/restaurants/1',
        data: mockRestaurant.toJson(),
      )).thenAnswer(
        (_) async => errorResponse(),
      );

      // act & assert
      expect(() => restaurantApi.updateRestaurant(mockRestaurant), throwsException);
      verify(mockDio.put(
        '/api/restaurants/1',
        data: mockRestaurant.toJson(),
      )).called(1);
    });
  });

  group('deleteRestaurant', () {
    test('should not throw exception when API call is successful', () async {
      // arrange
      when(mockDio.delete('/api/restaurants/1')).thenAnswer(
        (_) async => successResponse(null, statusCode: 204),
      );

      // act & assert
      expect(() => restaurantApi.deleteRestaurant(1), returnsNormally);
      verify(mockDio.delete('/api/restaurants/1')).called(1);
    });

    test('should throw exception when API call is unsuccessful', () async {
      // arrange
      when(mockDio.delete('/api/restaurants/1')).thenAnswer(
        (_) async => errorResponse(),
      );

      // act & assert
      expect(() => restaurantApi.deleteRestaurant(1), throwsException);
      verify(mockDio.delete('/api/restaurants/1')).called(1);
    });
  });
} 