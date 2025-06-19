import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gugugu/core/theme/app_colors.dart';
import 'package:gugugu/core/theme/app_text_styles.dart';
import 'package:gugugu/core/widgets/app_card.dart';
import 'package:gugugu/core/widgets/app_button.dart';
import 'package:gugugu/domain/entities/restaurant.dart';
import 'package:gugugu/presentation/features/hot_place/providers/hot_place_provider.dart';
import 'package:provider/provider.dart';

class HotPlaceDetailScreen extends StatefulWidget {
  final Restaurant place;

  const HotPlaceDetailScreen({
    super.key,
    required this.place,
  });

  @override
  State<HotPlaceDetailScreen> createState() => _HotPlaceDetailScreenState();
}

class _HotPlaceDetailScreenState extends State<HotPlaceDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  late Restaurant _place;
  double _userRating = 0;

  @override
  void initState() {
    super.initState();
    _place = widget.place;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_place.name, style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _place.imageUrl ?? "",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '주소',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _place.address,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '메뉴',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_place.menu.isEmpty)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("등록된 메뉴가 없습니다.")],
                    ),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final menu in _place.menu)
                        Chip(
                          label: Text(
                            "${menu.name} ${menu.price}원",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '리뷰',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_place.comment.isEmpty)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("리뷰가 없습니다.")],
                    ),
                  for (final comment in _place.comment)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "대소고인${comment.id}",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.star,
                                color: AppColors.warning,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                comment.rating.toStringAsFixed(2),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment.content,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    '리뷰 작성',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: _userRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
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
                      hintText: '리뷰를 입력하세요',
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
                    text: '리뷰 등록',
                    isFullWidth: true,
                    onPressed: () async {
                      final newComment = await context.read<HotPlaceProvider>().createComment(restaurantId: _place.id, rating: _userRating, content: _commentController.text);
                      _commentController.clear();
                      _userRating = 0;
                      setState(() {
                        _place = _place.copyWith(
                          comment: _place.comment..add(newComment)
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}