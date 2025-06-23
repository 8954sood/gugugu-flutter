import 'package:flutter/material.dart';
import 'package:gugugu/core/theme/app_colors.dart';
import 'package:gugugu/core/theme/app_text_styles.dart';
import 'package:gugugu/core/widget/bottom_navigation.dart';
import 'package:gugugu/presentation/features/meal/screens/meal_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gugugu/presentation/features/meal/providers/meal_provider.dart';
import 'package:gugugu/presentation/features/meal/widgets/meal_card.dart';
import 'package:gugugu/domain/entities/meal.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  static final DateTime _firstDay = DateTime.utc(2025, 1, 1);
  static final DateTime _lastDay = DateTime.utc(2025, 12, 31);
  
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    if (_focusedDay.isAfter(_lastDay)) {
      _focusedDay = _lastDay;
    }
    if (_focusedDay.isBefore(_firstDay)) {
      _focusedDay = _firstDay;
    }
    Future.microtask(() => _loadMeals());
  }

  void _loadMeals() {
    context.read<MealProvider>().loadMeals(_selectedDay, _selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('급식'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              locale: 'ko_KR',
              firstDay: _firstDay,
              lastDay: _lastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                context.read<MealProvider>().loadMeals(selectedDay, selectedDay);
              },
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: AppTextStyles.titleSmall,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Expanded(
              child: Consumer<MealProvider>(
                builder: (context, mealProvider, child) {
                  if (mealProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (mealProvider.error != null) {
                    return Center(child: Text(mealProvider.error!));
                  }

                  final meals = mealProvider.meals;
                  if (meals.isEmpty) {
                    return const Center(child: Text('급식 정보가 없습니다.'));
                  }

                  return ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return MealCard(
                        meal: meal,
                        comments: null,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return MealDetailScreen(meal: meal);
                          }));
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: 0),
    );
  }
}