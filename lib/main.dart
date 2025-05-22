import 'package:flutter/material.dart';
import 'package:gugugu/data/repositories/meal_repository_impl.dart';
import 'package:gugugu/domain/repositories/meal_repository.dart';
import 'package:gugugu/presentation/features/meal/providers/meal_detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:gugugu/presentation/features/meal/providers/meal_provider.dart';
import 'package:gugugu/data/datasources/meal_api.dart';
import 'package:gugugu/presentation/features/meal/screens/meal_screen.dart';
import 'package:gugugu/presentation/features/restaurant/screens/restaurant_map_screen.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

void main() {
  AuthRepository.initialize(appKey: "25d04b8d0417941faf58ab75220d93ff");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MealApi>(
          create: (_) => MealApi(),
        ),
        Provider<MealRepository>(
          create: (context) => MealRepositoryImpl(context.read<MealApi>()),
        ),
        ChangeNotifierProvider<MealProvider>(
          create: (context) => MealProvider(context.read<MealRepository>()),
        ),
        ChangeNotifierProvider<MealDetailProvider>(
          create: (context) => MealDetailProvider(context.read<MealRepository>()),
        )
      ],
      child: MaterialApp(
        title: '밥먹자구구구',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MealScreen(),
      ),
    );
  }
}
