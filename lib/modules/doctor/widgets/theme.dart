import 'package:flutter/material.dart';

import '../theme/doctor_colors.dart';
import '../theme/doctor_gradients.dart';

/// ⚠️ Legacy shim — kept for backward compatibility.
///
/// All real tokens now live in `lib/modules/doctor/theme/`.
/// New code should import from there:
///
///   import 'package:timesmed_project/modules/doctor/theme/doctor_theme.dart';
///
/// This file simply forwards the old `AppColors100` / `AppGradients`
/// names to the new central palette, so existing screens keep
/// rendering exactly as before.
class AppColors100 {
  // Header gradient (deep blue → soft sky)
  static const Color primaryDark  = DoctorColors.primaryDark;
  static const Color primary      = DoctorColors.primary;
  static const Color primaryLight = DoctorColors.primaryLight;

  // Surfaces
  static const Color background   = DoctorColors.background;
  static const Color cardWhite    = DoctorColors.cardWhite;
  static const Color fieldBorder  = DoctorColors.fieldBorder;

  // Accents
  static const Color iconBlue     = DoctorColors.primary;
  static const Color iconBlueSoft = DoctorColors.primarySoft;
  static const Color editTeal     = DoctorColors.primary;
  static const Color editTealBg   = DoctorColors.primarySoft;
  static const Color deleteRed    = DoctorColors.errorRed;
  static const Color deleteRedBg  = DoctorColors.errorSoftBg;

  // Text
  static const Color textPrimary   = DoctorColors.textPrimary;
  static const Color textSecondary = DoctorColors.textSecondary;
  static const Color textHint      = DoctorColors.textHint;

  // Buttons
  static const Color cancelRed  = DoctorColors.errorRed;
  static const Color submitBlue = DoctorColors.primary;
}

class AppGradients {
  static const LinearGradient header = DoctorGradients.header;
}
