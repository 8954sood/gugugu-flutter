import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Gugugu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RestaurantMapScreen(),
    );
  }
}
