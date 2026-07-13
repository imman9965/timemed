import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized typography. All screens pull from here so that a single
/// edit to a style propagates everywhere.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto';

  // Headers (white text over blue header banner)
  static const TextStyle headerTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.2,
  );

  static const TextStyle headerTitleSmall = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryBlue,
  );

  // Body
  static const TextStyle bodyBold = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleBody = TextStyle(
    fontSize: 11.8,
    fontWeight: FontWeight.bold,
    color: AppColors.blackPrimary,
  );


  static const TextStyle titleBodyblue = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // Form
  static const TextStyle inputLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle inputHint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // Buttons
  static const TextStyle buttonWhite = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
