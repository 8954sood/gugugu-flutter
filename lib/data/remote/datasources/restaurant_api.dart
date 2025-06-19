import 'dart:math';

import 'package:dio/dio.dart';
import 'package:gugugu/core/network/dio_client.dart';
import 'package:gugugu/domain/entities/comment.dart';
import 'package:gugugu/domain/entities/menu.dart';
import 'package:gugugu/domain/entities/restaurant.dart';

class RestaurantApi {
  final Dio _dio;

  RestaurantApi([Dio? dio]) : _dio = dio ?? DioClient().dio;

  Future<List<Restaurant>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double? distance,
  }) async {
    try {
      final response = await _dio.get(
        '/api/restaurants/nearby',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          if (distance != null) 'distance': distance,
        },
      );
      print("dd");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print(data);
        return data.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load nearby restaurants');
      }
    } on DioException catch (e) {
      print(e);
      throw Exception('Failed to load nearby restaurants: ${e.message}');
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Restaurant>> getHotPlaces({int? limit}) async {
    try {
      final response = await _dio.get(
        '/api/restaurants/hot-places',
        queryParameters: {
          if (limit != null) 'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load hot places');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load hot places: ${e.message}');
    }
  }

  Future<Restaurant> createRestaurant(Restaurant restaurant) async {
    try {
      final response = await _dio.post(
        '/api/restaurants',
        data: restaurant.toJson(),
      );

      if (response.statusCode == 201) {
        return Restaurant.fromJson(response.data);
      } else {
        throw Exception('Failed to create restaurant');
      }
    } on DioException catch (e) {
      throw Exception('Failed to create restaurant: ${e.message}');
    }
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

      if (response.statusCode != 204) {
        throw Exception('Failed to delete restaurant');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete restaurant: ${e.message}');
    }
  }

  Future<void> createMenu({required int restaurantId, required String name, required String description, required int price}) async {
    try {
      final response = await _dio.post("/api/restaurant-menus", data: {
        "restaurantId": restaurantId,
        "name": name,
        "price": price,
        "description": description,
        "imageUrl": "https://picsum.photos/500",
      });

      if (response.statusCode != 201) {
        throw Exception('Failed to create menu');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete restaurant: ${e.message}');
    }
  }

  Future<Comment> createComment({required int restaurantId, required double rating, required String content,}) async {
    try {
      final response = await _dio.post("/api/reviews", data: {
        "restaurantId": restaurantId,
        "menu": "",
        "mealDate": DateTime.now().toIso8601String(),
        "rating": rating,
        "comment": content,
      });

      if (response.statusCode != 200) {
        throw Exception('Failed to create menu');
      }
      return Comment.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to delete restaurant: ${e.message}');
    }
  }

}