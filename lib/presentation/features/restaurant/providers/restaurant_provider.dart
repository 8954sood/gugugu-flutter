import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:gugugu/domain/entities/comment.dart';
import 'package:gugugu/domain/entities/menu.dart';
import 'package:gugugu/domain/entities/restaurant.dart';
import 'package:gugugu/domain/repositories/restaurant_repository.dart';

class RestaurantProvider with ChangeNotifier {
  final RestaurantRepository _restaurantRepository;
  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  String? _error;

  RestaurantProvider(this._restaurantRepository);

  List<Restaurant> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get error => _error;


  Future<void> loadNearbyRestaurants({
    required double latitude,
    required double longitude,
    double? distance,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _restaurants = await _restaurantRepository.getNearbyRestaurants(
        latitude: latitude,
        longitude: longitude,
        distance: distance,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHotPlaces({int? limit}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _restaurants = await _restaurantRepository.getHotPlaces(limit: limit);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Restaurant> createRestaurant(Restaurant restaurant) async {
    try {
      final created = await _restaurantRepository.createRestaurant(restaurant);
      _restaurants.add(created);
      notifyListeners();
      return created;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<Restaurant> updateRestaurant(Restaurant restaurant) async {
    try {
      final updated = await _restaurantRepository.updateRestaurant(restaurant);
      final index = _restaurants.indexWhere((r) => r.id == restaurant.id);
      if (index != -1) {
        _restaurants[index] = updated;
        notifyListeners();
      }
      return updated;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteRestaurant(int id) async {
    try {
      await _restaurantRepository.deleteRestaurant(id);
      _restaurants.removeWhere((r) => r.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<Menu> createMenu({required int restaurantId, required String name, required String description, required int price, }) async {
    try {
      await _restaurantRepository.createMenu(restaurantId: restaurantId, name: name, description: description, price: price, );
      final newMenu = Menu(name: name, price: price, createdAt: DateTime.now(), updatedAt: DateTime.now(),);
      _restaurants.map((item) {
        if (item.id != restaurantId) return item;

        return item.copyWith(
          menu: item.menu..add(newMenu),
        );
      });
      notifyListeners();
      return newMenu;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<Comment> createComment({required int restaurantId, required double rating, required String content, }) async {
    try {
      await _restaurantRepository.createComment(restaurantId: restaurantId, rating: rating, content: content);
      final newComment = Comment(id: Random.secure().nextInt(3000), rating: rating, content: content, createdAt: DateTime.now(), updatedAt: DateTime.now());
      _restaurants.map((item) {
        if (item.id != restaurantId) return item;

        return item.copyWith(
          comment: item.comment..add(newComment),
        );
      });
      notifyListeners();
      return newComment;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }


} 