import 'package:flutter/material.dart';

/// Typography constants for the Doctor module.
///
/// Separate from [DoctorTextStyles] which combines these tokens with colors.
/// Import this file when you need raw size, weight, or spacing values.
class DoctorFontSize {
  DoctorFontSize._();

  static const double xs    = 10;
  static const double sm    = 11;
  static const double base  = 12;
  static const double md    = 13;
  static const double body  = 14;
  static const double lg    = 15;
  static const double xl    = 16;
  static const double xxl   = 18;
  static const double h3    = 20;
  static const double h2    = 22;
  static const double h1    = 24;
  static const double d2    = 26;
  static const double d1    = 28;

  // Semantic aliases (map logical names to scale)
  static const double label       = md;
  static const double hint        = md;
  static const double caption     = base;
  static const double chip        = sm;
  static const double bodyText    = body;
  static const double bodyLarge   = lg;
  static const double subtitle    = xl;
  static const double title       = xxl;
  static const double headerTitle = h3;
  static const double loginTitle  = d1;
  static const double otpTitle    = d2;
}

class DoctorFontWeight {
  DoctorFontWeight._();

  static const FontWeight regular   = FontWeight.w400;
  static const FontWeight medium    = FontWeight.w500;
  static const FontWeight semiBold  = FontWeight.w600;
  static const FontWeight bold      = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}

class DoctorLineHeight {
  DoctorLineHeight._();

  static const double tight   = 1.2;
  static const double normal  = 1.4;
  static const double relaxed = 1.6;
}

class DoctorLetterSpacing {
  DoctorLetterSpacing._();

  static const double tight  = -0.2;
  static const double normal = 0.0;
  static const double wide   = 0.3;
  static const double wider  = 0.5;
  static const double widest = 1.0;
}
