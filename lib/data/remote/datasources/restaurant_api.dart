import 'dart:math';

import 'package:dio/dio.dart';
import 'package:gugugu/core/network/dio_client.dart';
import 'package:gugugu/domain/entities/comment.dart';
import 'package:gugugu/domain/entities/menu.dart';
import 'package:gugugu/domain/entities/restaurant.dart';

class RestaurantApi {
  final Dio _dio;

  RestaurantApi() : _dio = DioClient().dio;

  Future<List<Restaurant>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double? distance,
  }) async {
    // TODO(서버 구현 안됨)
    // try {
    //   final response = await _dio.get(
    //     '/api/restaurants/nearby',
    //     queryParameters: {
    //       'latitude': latitude,
    //       'longitude': longitude,
    //       if (distance != null) 'distance': distance,
    //     },
    //   );
    //
    //   if (response.statusCode == 200) {
    //     final List<dynamic> data = response.data;
    //     print(data);
    //     return data.map((json) => Restaurant.fromJson(json)).toList();
    //   } else {
    //     throw Exception('Failed to load nearby restaurants');
    //   }
    // } on DioException catch (e) {
    //   throw Exception('Failed to load nearby restaurants: ${e.message}');
    // }
    return [Restaurant(id: 1, name: "dgsw", address: "address", latitude: 35.663286, longitude: 128.41362558244387, description: "description", imageUrl: null, averageRating: 3, reviewCount: 0, menu: [], comment: [], createdAt: DateTime.now(), updatedAt: DateTime.now())];
  }

  Future<List<Restaurant>> getHotPlaces({int? limit}) async {
    // try {
    //   final response = await _dio.get(
    //     '/api/restaurants/hot-places',
    //     queryParameters: {
    //       if (limit != null) 'limit': limit,
    //     },
    //   );
    //
    //   if (response.statusCode == 200) {
    //     final List<dynamic> data = response.data;
    //     return data.map((json) => Restaurant.fromJson(json)).toList();
    //   } else {
    //     throw Exception('Failed to load hot places');
    //   }
    // } on DioException catch (e) {
    //   throw Exception('Failed to load hot places: ${e.message}');
    // }
    return [
      Restaurant(
          id: 1,
          name: "dgsw",
          address: "address",
          latitude: 35.663286,
          longitude: 128.41362558244387,
          description: "description",
          imageUrl: "https://picsum.photos/200",
          averageRating: 3,
          reviewCount: 1,
          menu: [
            Menu(name: "비빔밥", price: 3000, createdAt: DateTime.now(), updatedAt: DateTime.now()),
          ],
          comment: [
            Comment(id: Random.secure().nextInt(3000), rating: 3, content: "무난무난한 식당", createdAt: DateTime.now(), updatedAt: DateTime.now()),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now()
      )];
  }

  Future<Restaurant> createRestaurant(Restaurant restaurant) async {
    // TODO(서버 구현 안됨)
    // try {
    //   final response = await _dio.post(
    //     '/api/restaurants',
    //     data: restaurant.toJson(),
    //   );
    //
    //   if (response.statusCode == 200) {
    //     return Restaurant.fromJson(response.data);
    //   } else {
    //     throw Exception('Failed to create restaurant');
    //   }
    // } on DioException catch (e) {
    //   throw Exception('Failed to create restaurant: ${e.message}');
    // }
    
    return restaurant;
  }

  Future<Restaurant> updateRestaurant(Restaurant restaurant) async {
    try {
      final response = await _dio.put(
        '/api/restaurants/${restaurant.id}',
        data: restaurant.toJson(),
      );

      if (response.statusCode == 200) {
        return Restaurant.fromJson(response.data);
      } else {
        throw Exception('Failed to update restaurant');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update restaurant: ${e.message}');
    }
  }

  Future<void> deleteRestaurant(int id) async {
    try {
      final response = await _dio.delete('/api/restaurants/$id');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete restaurant');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete restaurant: ${e.message}');
    }
  }

  Future<void> createMenu({required int restaurantId, required String name, required String description, required int price}) async {
    // TODO(서버 구현 안됨)
    // try {
    //   final response = await _dio.post("/api/restaurants/$restaurantId/menus");
    //
    //   if (response.statusCode != 201) {
    //     throw Exception('Failed to delete restaurant');
    //   }
    // } on DioException catch (e) {
    //   throw Exception('Failed to delete restaurant: ${e.message}');
    // }
  }

  Future<void> createComment({required int restaurantId, required double rating, required String content,}) async {
    // TODO(서버 구현 안됨)
  }

}
