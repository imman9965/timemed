/// Spacing, radii, and common sizes. Using constants avoids magic numbers
/// scattered across widgets and keeps spacing rhythm consistent.
class AppDimens {
  AppDimens._();

  // Spacing scale
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  // Screen horizontal padding
  static const double screenHPadding = 16;

  // Radii
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusPill = 999;

  // Header
  static const double headerHeight = 110;
  static const double headerBottomRadius = 28;

  // Bottom nav
  static const double bottomNavHeight = 64;
  static const double bottomNavMargin = 16;
}
