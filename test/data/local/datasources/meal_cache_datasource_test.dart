import 'package:flutter_test/flutter_test.dart';
import 'package:gugugu/data/local/datasources/meal_cache_datasource.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  late MealCacheDatasource datasource;
  late String testDbPath;
  late Database db;

  setUp(() async {
    final dbDir = await getDatabasesPath();
    testDbPath = join(dbDir, 'test_meal_cache.db');
    if (File(testDbPath).existsSync()) {
      File(testDbPath).deleteSync();
    }
    db = await openDatabase(testDbPath, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE meal_cache (
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
    });
    datasource = MealCacheDatasource(db);
  });

  tearDown(() async {
    if (File(testDbPath).existsSync()) {
      await deleteDatabase(testDbPath);
    }
  });

  test('Set Meal Data and Load', () async {
    final meals = [
      mockMeal,
      mockMeal.copyWith(
        mealType: "조식"
      )
    ];
    await datasource.setMeals('20250619', '20250619', meals);
    final result = await datasource.getMeals('20250619', '20250619');
    expect(result, isNotNull);
    expect(result!.length, 2);
    expect(result[0].mealType, '조식');
    expect(result[1].mealType, "중식");
  });

  test('Expire cache return null', () async {
    final meals = [
      mockMeal
    ];
    await datasource.setMeals('20250619', '20250619', meals);
    // 15일 지난 후, 데이터 초기화 되는지 테스트

    final expiredTimestamp = DateTime.now().millisecondsSinceEpoch - (15 * 24 * 60 * 60 * 1000);
    await db.update('meal_cache', {'timestamp': expiredTimestamp}, where: 'key = ?', whereArgs: ['20250619-20250619']);
    final result = await datasource.getMeals('20250619', '20250619');
    expect(result, isNull);

    final rows = await db.query('meal_cache', where: 'key = ?', whereArgs: ['20250619-20250619']);
    expect(rows, isEmpty);
  });

  test('overwrites setMeals', () async {
    final meals1 = [
      mockMeal
    ];
    final meals2 = [
      mockMeal.copyWith(
        menu: "김치"
      )
    ];
    await datasource.setMeals('20240101', '20240101', meals1);
    await datasource.setMeals('20240101', '20240101', meals2);
    final result = await datasource.getMeals('20240101', '20240101');
    expect(result, isNotNull);
    expect(result!.length, 1);
    expect(result[0].menu, '김치');
  });
} 