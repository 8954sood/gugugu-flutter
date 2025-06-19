import 'package:gugugu/domain/entities/comment.dart';

import '../entities/restaurant.dart';

abstract class RestaurantRepository {

  Future<List<Restaurant>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double? distance,
  });

  Future<List<Restaurant>> getHotPlaces({int? limit});

  Future<Restaurant> createRestaurant(Restaurant restaurant);

  Future<Restaurant> updateRestaurant(Restaurant restaurant);

  Future<void> deleteRestaurant(int id);

  Future<void> createMenu({required int restaurantId, required String name, required String description, required int price});

  Future<Comment> createComment({required int restaurantId, required double rating, required String content,});
} 