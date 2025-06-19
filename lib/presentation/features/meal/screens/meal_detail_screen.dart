import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gugugu/core/widgets/app_button.dart';
import 'package:gugugu/core/widgets/app_card.dart';
import 'package:gugugu/presentation/features/meal/providers/meal_detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:gugugu/core/theme/app_colors.dart';
import 'package:gugugu/core/theme/app_text_styles.dart';
import 'package:gugugu/domain/entities/meal.dart';
import 'package:gugugu/domain/entities/meal_review.dart';
import 'package:gugugu/presentation/features/meal/providers/meal_provider.dart';

class MealDetailScreen extends StatefulWidget {
  final Meal meal;

  const MealDetailScreen({
    super.key,
    required this.meal,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final _commentController = TextEditingController();
  double _userRating = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MealDetailProvider>().loadComments(widget.meal));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_userRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('평점을 선택해주세요')),
      );
      return;
    }

    context.read<MealDetailProvider>().submitRating(
      widget.meal,
      _userRating,
      _commentController.text,
    );
    _commentController.clear();
  }

  Widget _buildCommentItem(MealReview review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingBar.builder(
                initialRating: review.rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 16,
                ignoreGestures: true,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: AppColors.warning,
                ),
                onRatingUpdate: (rating) {},
              ),
              Text("대소고인${review.id}")
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.comment,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  review.createdAt.toString(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.meal.mealType} 급식'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.meal.mealDate.substring(0, 4)}년 ${widget.meal.mealDate.substring(4, 6)}월 ${widget.meal.mealDate.substring(6, 8)}일',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.meal.menu,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '평점: ',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      RatingBar.builder(
                        initialRating: context.watch<MealDetailProvider>().rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20,
                        ignoreGestures: true,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: AppColors.warning,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.watch<MealDetailProvider>().rating.toStringAsFixed(1),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Consumer<MealDetailProvider>(
              builder: (context, provider, child) {
                final comments = provider.comments;
                if (comments.isEmpty) {
                  return const SizedBox.shrink();
                }

                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '댓글',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...comments.map(_buildCommentItem),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '평가하기',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RatingBar.builder(
                    initialRating: _userRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: AppColors.warning,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _userRating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: '코멘트를 입력하세요',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textHint,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: '평가 등록',
                    isFullWidth: true,
                    onPressed: _submitReview,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 