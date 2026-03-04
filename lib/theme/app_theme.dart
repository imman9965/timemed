import 'package:flutter/material.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';

class AppTextTheme {
  static const TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.textDark,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textDark,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.textDark),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textLight,
    ),
  );
}
