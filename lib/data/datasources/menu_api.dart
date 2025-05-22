import 'package:dio/dio.dart';
import 'package:gugugu/core/network/dio_client.dart';
import 'package:gugugu/domain/entities/menu.dart';

class MenuApi {
  final Dio _dio;

  MenuApi() : _dio = DioClient().dio;

  Future<Menu> getMenu(int id) async {
    try {
      final response = await _dio.get('/api/menus/$id');

      if (response.statusCode == 200) {
        return Menu.fromJson(response.data);
      } else {
        throw Exception('Failed to load menu');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load menu: ${e.message}');
    }
  }

  Future<List<Menu>> getRestaurantMenus(int restaurantId) async {
    try {
      final response = await _dio.get('/api/menus/restaurant/$restaurantId');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Menu.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load restaurant menus');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load restaurant menus: ${e.message}');
    }
  }

  Future<Menu> createMenu(Menu menu) async {
    try {
      final response = await _dio.post(
        '/api/menus',
        data: menu.toJson(),
      );

      if (response.statusCode == 200) {
        return Menu.fromJson(response.data);
      } else {
        throw Exception('Failed to create menu');
      }
    } on DioException catch (e) {
      throw Exception('Failed to create menu: ${e.message}');
    }
  }

  Future<Menu> updateMenu(Menu menu) async {
    try {
      final response = await _dio.put(
        '/api/menus/${menu}',
        data: menu.toJson(),
      );

      if (response.statusCode == 200) {
        return Menu.fromJson(response.data);
      } else {
        throw Exception('Failed to update menu');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update menu: ${e.message}');
    }
  }

  Future<void> deleteMenu(int id) async {
    try {
      final response = await _dio.delete('/api/menus/$id');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete menu');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete menu: ${e.message}');
    }
  }
} 