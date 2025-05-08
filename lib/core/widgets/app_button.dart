import 'package:flutter/material.dart';
import 'package:gugugu/core/theme/app_colors.dart';
import 'package:gugugu/core/theme/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isOutlined = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final button = isOutlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: textColor ?? AppColors.primary,
              side: BorderSide(color: textColor ?? AppColors.primary),
            ),
            child: Text(text, style: AppTextStyles.labelMedium),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? AppColors.primary,
              foregroundColor: textColor ?? Colors.white,
            ),
            child: Text(text, style: AppTextStyles.labelMedium),
          );

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
} 