import 'package:flutter/material.dart';
import 'package:gugugu/domain/entities/meal.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final String? comments;
  final Function() onTap;

  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
    this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meal.mealType,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  RatingBar.builder(
                    initialRating: meal.averageRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 16,
                    ignoreGestures: true,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                meal.menu,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (comments != null) ...[
                const SizedBox(height: 8),
                Text(
                  comments!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 