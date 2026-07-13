import 'package:flutter/material.dart';

import 'doctor_colors.dart';

/// Reusable elevation / shadow tokens for the Doctor module.
class DoctorShadows {
  DoctorShadows._();

  /// Subtle shadow used for list cards and tiles.
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Slightly stronger shadow used for elevated/sticky widgets.
  static List<BoxShadow> get cardElevated => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];

  /// Soft brand-tinted shadow used on primary CTA buttons.
  static List<BoxShadow> get primaryButton => [
        BoxShadow(
          color: DoctorColors.primary.withOpacity(0.25),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  /// Soft brand glow for request / highlight cards.
  static List<BoxShadow> get brandGlow => [
        BoxShadow(
          color: DoctorColors.primaryDeep.withOpacity(0.06),
          blurRadius: 20,
          spreadRadius: 1,
          offset: const Offset(0, 6),
        ),
      ];
}
