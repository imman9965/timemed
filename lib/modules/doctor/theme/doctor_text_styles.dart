import 'package:flutter/material.dart';

import 'doctor_colors.dart';

/// Common text styles used throughout the Doctor module.
///
/// Values mirror what the existing screens already render — these are
/// just centralised so future widgets can share them without being
/// re-declared in every file.
class DoctorTextStyles {
  DoctorTextStyles._();

  // ───────────── Headings (used in headers / app bar titles) ─────────────
  static const TextStyle headerTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static const TextStyle headerSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
  );

  // ───────────── Section / Card titles ─────────────
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: DoctorColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: DoctorColors.textPrimary,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: DoctorColors.textSecondary,
  );

  // ───────────── Body ─────────────
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    color: DoctorColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: DoctorColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    color: DoctorColors.textSecondary,
  );

  // ───────────── Labels / Hints ─────────────
  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: DoctorColors.textSecondary,
  );

  static const TextStyle hint = TextStyle(
    fontSize: 13,
    color: DoctorColors.textHint,
  );

  // ───────────── Buttons ─────────────
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.4,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: DoctorColors.primary,
  );

  // ───────────── Status chips ─────────────
  static const TextStyle statusChip = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );
}
