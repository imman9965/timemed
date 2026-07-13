import 'package:flutter/material.dart';

import 'doctor_colors.dart';
import 'doctor_typography.dart';

/// Common text styles used throughout the Doctor module.
///
/// Built from [DoctorFontSize] and [DoctorFontWeight] tokens so that
/// individual screens never hard-code raw font values.
class DoctorTextStyles {
  DoctorTextStyles._();

  // ─────────────────────────────────────────────────────────────
  //  Headings — headers / app-bar titles
  // ─────────────────────────────────────────────────────────────
  static const TextStyle headerTitle = TextStyle(
    fontSize: DoctorFontSize.headerTitle,
    fontWeight: DoctorFontWeight.bold,
    color: Colors.white,
    letterSpacing: DoctorLetterSpacing.wide,
  );

  static const TextStyle headerSubtitle = TextStyle(
    fontSize: DoctorFontSize.md,
    fontWeight: DoctorFontWeight.regular,
    color: Colors.white70,
  );

  // ─────────────────────────────────────────────────────────────
  //  Login / Auth page
  // ─────────────────────────────────────────────────────────────
  static const TextStyle loginTitle = TextStyle(
    fontSize: DoctorFontSize.loginTitle,
    fontWeight: DoctorFontWeight.extraBold,
    color: Colors.white,
    letterSpacing: DoctorLetterSpacing.wider,
  );

  static const TextStyle loginSubtitle = TextStyle(
    fontSize: DoctorFontSize.bodyLarge,
    fontWeight: DoctorFontWeight.regular,
    color: Colors.white60,
  );

  static const TextStyle otpTitle = TextStyle(
    fontSize: DoctorFontSize.otpTitle,
    fontWeight: DoctorFontWeight.extraBold,
    color: Colors.white,
    letterSpacing: DoctorLetterSpacing.wider,
  );

  // ─────────────────────────────────────────────────────────────
  //  Section / Card titles
  // ─────────────────────────────────────────────────────────────
  static const TextStyle sectionTitle = TextStyle(
    fontSize: DoctorFontSize.subtitle,
    fontWeight: DoctorFontWeight.bold,
    color: DoctorColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: DoctorFontSize.bodyLarge,
    fontWeight: DoctorFontWeight.semiBold,
    color: DoctorColors.textPrimary,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: DoctorFontSize.md,
    fontWeight: DoctorFontWeight.regular,
    color: DoctorColors.textSecondary,
  );

  // ─────────────────────────────────────────────────────────────
  //  Body
  // ─────────────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontSize: DoctorFontSize.bodyLarge,
    color: DoctorColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: DoctorFontSize.bodyText,
    color: DoctorColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: DoctorFontSize.md,
    color: DoctorColors.textSecondary,
  );

  // ─────────────────────────────────────────────────────────────
  //  Labels / Hints
  // ─────────────────────────────────────────────────────────────
  static const TextStyle label = TextStyle(
    fontSize: DoctorFontSize.label,
    fontWeight: DoctorFontWeight.medium,
    color: DoctorColors.textSecondary,
  );

  static const TextStyle hint = TextStyle(
    fontSize: DoctorFontSize.hint,
    color: DoctorColors.textHint,
  );

  static const TextStyle caption = TextStyle(
    fontSize: DoctorFontSize.caption,
    fontWeight: DoctorFontWeight.semiBold,
    color: DoctorColors.textPrimary,
  );

  // ─────────────────────────────────────────────────────────────
  //  Buttons
  // ─────────────────────────────────────────────────────────────
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: DoctorFontSize.bodyLarge,
    fontWeight: DoctorFontWeight.semiBold,
    color: Colors.white,
    letterSpacing: DoctorLetterSpacing.wide,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontSize: DoctorFontSize.bodyText,
    fontWeight: DoctorFontWeight.semiBold,
    color: DoctorColors.primary,
  );

  static const TextStyle loginButton = TextStyle(
    fontSize: DoctorFontSize.subtitle,
    fontWeight: DoctorFontWeight.bold,
    color: Colors.black,
    letterSpacing: DoctorLetterSpacing.widest,
  );

  // ─────────────────────────────────────────────────────────────
  //  Status chips
  // ─────────────────────────────────────────────────────────────
  static const TextStyle statusChip = TextStyle(
    fontSize: DoctorFontSize.chip,
    fontWeight: DoctorFontWeight.semiBold,
    letterSpacing: DoctorLetterSpacing.wide,
  );

  // ─────────────────────────────────────────────────────────────
  //  Medical Records / compact body styles
  // ─────────────────────────────────────────────────────────────
  static const TextStyle titleBody = TextStyle(
    fontSize: 11.8,
    fontWeight: DoctorFontWeight.bold,
    color: DoctorColors.textBlack,
  );

  static const TextStyle titleBodyBlue = TextStyle(
    fontSize: DoctorFontSize.base,
    fontWeight: DoctorFontWeight.bold,
    color: DoctorColors.primaryBrand,
  );

  static const TextStyle sectionTitleLarge = TextStyle(
    fontSize: DoctorFontSize.title,
    fontWeight: DoctorFontWeight.bold,
    color: DoctorColors.primaryVivid,
  );
}
