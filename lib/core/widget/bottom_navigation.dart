import 'package:flutter/material.dart';
import 'package:gugugu/presentation/features/hot_place/screens/hot_place_screen.dart';
import 'package:gugugu/presentation/features/meal/screens/meal_screen.dart';
import 'package:gugugu/presentation/features/restaurant/screens/restaurant_map_screen.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => switch (index) {
              0 => const MealScreen(),
              1 => const RestaurantMapScreen(),
              2 => const HotPlaceScreen(),
              int() => throw UnimplementedError(),
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: '급식',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: '맛집',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_fire_department),
          label: '핫플레이스',
        ),
      ],
    );
  }
} 