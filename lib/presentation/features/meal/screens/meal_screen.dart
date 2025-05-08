import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gugugu/core/theme/app_colors.dart';
import 'package:gugugu/core/theme/app_text_styles.dart';
import 'package:gugugu/core/widgets/app_card.dart';
import 'package:gugugu/core/widgets/app_button.dart';
import 'package:gugugu/core/widget/bottom_navigation.dart';
import 'package:gugugu/presentation/features/meal/widgets/meal_item_widget.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _meals = [
    {
      'date': '2024-03-20',
      'menu': '아침: 샌드위치\n점심: 비빔밥\n저녁: 스테이크',
      'rating': 4.5,
      'comments': '오늘 점심이 특히 맛있었어요!',
    },
    {
      'date': '2024-03-19',
      'menu': '아침: 토스트\n점심: 김치찌개\n저녁: 피자',
      'rating': 4.0,
      'comments': null,
    },
    {
      'date': '2024-03-18',
      'menu': '아침: 시리얼\n점심: 돈까스\n저녁: 파스타',
      'rating': 3.5,
      'comments': '저녁 파스타가 좀 짰어요.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('급식', style: AppTextStyles.titleMedium),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: AppTextStyles.titleSmall,
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _meals.length,
              itemBuilder: (context, index) {
                final meal = _meals[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: MealItemWidget(meal: meal),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentIndex: 0,
      ),
    );
  }
}