import 'package:gugugu/data/remote/datasources/restaurant_api.dart';
import 'package:gugugu/domain/entities/comment.dart';
import 'package:gugugu/domain/entities/restaurant.dart';
import 'package:gugugu/domain/repositories/restaurant_repository.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantApi _restaurantApi;

  RestaurantRepositoryImpl(this._restaurantApi);

  @override
  Future<List<Restaurant>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double? distance,
  }) async {
    return _restaurantApi.getNearbyRestaurants(latitude: latitude, longitude: longitude);
  }

  @override
  Future<List<Restaurant>> getHotPlaces({int? limit}) async {
    return _restaurantApi.getHotPlaces(limit: limit);
  }

  @override
  Future<Restaurant> createRestaurant(Restaurant restaurant) async {
    return _restaurantApi.createRestaurant(restaurant);
  }

  @override
  Future<Restaurant> updateRestaurant(Restaurant restaurant) async {
    return _restaurantApi.updateRestaurant(restaurant);
  }

  @override
  Future<void> deleteRestaurant(int id) async {
    return _restaurantApi.deleteRestaurant(id);
  }

  @override
  Future<void> createMenu({required int restaurantId, required String name, required String description, required int price}) {
    return _restaurantApi.createMenu(restaurantId: restaurantId, name: name, description: description, price: price);
  }


  @override
  Future<Comment> createComment({required int restaurantId, required double rating, required String content}) async {
    return await _restaurantApi.createComment(restaurantId: restaurantId, rating: rating, content: content);
  }
} 