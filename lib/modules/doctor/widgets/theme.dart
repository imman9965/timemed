import 'package:flutter/material.dart';

/// Blue-white theme constants for the Clinical Notes module.
class AppColors100 {
  // Header gradient (deep blue → soft sky)
  static const Color primaryDark = Color(0xFF1E5FBF);
  static const Color primary = Color(0xFF2F7BE0);
  static const Color primaryLight = Color(0xFF5EA1F0);

  // Surfaces
  static const Color background = Color(0xFFF4F8FE);
  static const Color cardWhite = Colors.white;
  static const Color fieldBorder = Color(0xFFD9E2F0);

  // Accents
  static const Color iconBlue = Color(0xFF2F7BE0);
  static const Color iconBlueSoft = Color(0xFFE5EFFC);
  static const Color editTeal = Color(0xFF2F7BE0);
  static const Color editTealBg = Color(0xFFE5EFFC);
  static const Color deleteRed = Color(0xFFEF4444);
  static const Color deleteRedBg = Color(0xFFFEE2E2);

  // Text
  static const Color textPrimary = Color(0xFF1A2236);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF94A3B8);

  // Buttons
  static const Color cancelRed = Color(0xFFEF4444);
  static const Color submitBlue = Color(0xFF2F7BE0);
}

class AppGradients {
  static const LinearGradient header = LinearGradient(
    colors: [AppColors100.primaryDark, AppColors100.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
