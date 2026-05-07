import 'package:flutter/material.dart';

import 'doctor_colors.dart';

/// Reusable gradients for the Doctor module.
///
/// All gradients are sourced from the existing screens; nothing new
/// has been introduced.
class DoctorGradients {
  DoctorGradients._();

  /// Default header gradient used by curved app bars (clinical notes,
  /// prescription, lab tests, etc.).
  static const LinearGradient header = LinearGradient(
    colors: [DoctorColors.primaryDark, DoctorColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Material-blue gradient used by medical history banners.
  static const LinearGradient medicalBlue = LinearGradient(
    colors: [DoctorColors.blue800, DoctorColors.blue400],
  );

  /// Login / OTP page accent gradient.
  static const LinearGradient loginAccent = LinearGradient(
    colors: [DoctorColors.primaryDeep, DoctorColors.blue500],
  );

  /// Login button gradient (deep → accent).
  static const LinearGradient loginButton = LinearGradient(
    colors: [DoctorColors.primaryDeep, DoctorColors.primaryAccent],
  );

  /// Mint / green action gradient (approve buttons, request cards).
  static const LinearGradient approveMint = LinearGradient(
    colors: [DoctorColors.successMint, DoctorColors.successMintDeep],
  );

  /// Reject / decline gradient.
  static const LinearGradient rejectRose = LinearGradient(
    colors: [DoctorColors.errorRose, DoctorColors.errorRoseDeep],
  );

  /// Subtle blue request-card gradient.
  static const LinearGradient requestBlue = LinearGradient(
    colors: [DoctorColors.primaryDeep, DoctorColors.primaryAccent],
  );
}
