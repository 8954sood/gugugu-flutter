import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gugugu/domain/entities/comment.dart';
import 'package:gugugu/domain/entities/restaurant.dart';
import 'package:gugugu/domain/repositories/restaurant_repository.dart';

class HotPlaceProvider with ChangeNotifier {
  final RestaurantRepository _restaurantRepository;
  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  String? _error;

  HotPlaceProvider(this._restaurantRepository);

  List<Restaurant> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadHotPlace() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _restaurants = await _restaurantRepository.getHotPlaces(limit: 10);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Comment> createComment({required int restaurantId, required double rating, required String content, }) async {
    try {
      final newComment = await _restaurantRepository.createComment(restaurantId: restaurantId, rating: rating, content: content);
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