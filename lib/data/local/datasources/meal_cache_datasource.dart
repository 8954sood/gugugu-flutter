import 'dart:convert';
import 'package:gugugu/domain/entities/meal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MealCacheDatasource {
  static const _tableName = 'meal_cache';
  Database? _db;

  MealCacheDatasource([Database? db]): _db = db;

  Future<void> init() async {
    if (_db != null) return;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'meal_cache.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            key TEXT,
            mealDate TEXT,
            mealType TEXT,
            menu TEXT,
            calorie TEXT,
            mealInfo TEXT,
            averageRating REAL,
            timestamp INTEGER,
            PRIMARY KEY (key, mealDate, mealType)
          )
        ''');
      },
    );
  }

  Future<List<Meal>?> getMeals(String startDate, String endDate) async {
    await init();
    final key = _cacheKey(startDate, endDate);
    final result = await _db!.query(
      _tableName,
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) return null;
    // 모든 row의 timestamp가 유효해야 함
    final now = DateTime.now().millisecondsSinceEpoch;
    const expiry = 14 * 24 * 60 * 60 * 1000;
    final expired = result.any((row) => now - (row['timestamp'] as int) > expiry);
    if (expired) {
      await _db!.delete(_tableName, where: 'key = ?', whereArgs: [key]);
      return null;
    }
    return result.map((row) => Meal(
      mealDate: row['mealDate'] as String,
      mealType: row['mealType'] as String,
      menu: row['menu'] as String,
      calorie: row['calorie'] as String,
      mealInfo: row['mealInfo'] as String,
      averageRating: (row['averageRating'] as num).toDouble(),
    )).toList();
  }

  Future<void> setMeals(String startDate, String endDate, List<Meal> meals) async {
    await init();
    final key = _cacheKey(startDate, endDate);
    // 기존 캐시 삭제
    await _db!.delete(_tableName, where: 'key = ?', whereArgs: [key]);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final batch = _db!.batch();
    for (final meal in meals) {
      batch.insert(
        _tableName,
        {
          'key': key,
          'mealDate': meal.mealDate,
          'mealType': meal.mealType,
          'menu': meal.menu,
          'calorie': meal.calorie,
          'mealInfo': meal.mealInfo,
          'averageRating': meal.averageRating,
          'timestamp': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  String _cacheKey(String startDate, String endDate) => '$startDate-$endDate';
} 