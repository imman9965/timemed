import 'package:flutter/material.dart';

/// Shared spacing, radii and sizing tokens for the Doctor module.
///
/// Pulled from recurring values across existing screens so the design
/// stays consistent without altering anything visually.
class DoctorSpacing {
  DoctorSpacing._();

  static const double xxs = 2;
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 12;
  static const double lg  = 16;
  static const double xl  = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  // Common page paddings used across screens
  static const EdgeInsets pagePadding   = EdgeInsets.all(lg);
  static const EdgeInsets cardPadding   = EdgeInsets.all(md);
  static const EdgeInsets cardPaddingLg = EdgeInsets.all(lg);
  static const EdgeInsets fieldPadding  =
      EdgeInsets.symmetric(horizontal: lg, vertical: md);
}

class DoctorRadii {
  DoctorRadii._();

  static const double xs  = 6;
  static const double sm  = 8;
  static const double md  = 12;
  static const double lg  = 16;
  static const double xl  = 20;
  static const double xxl = 24;
  static const double pill = 999;

  static const BorderRadius brXs  = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius brSm  = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd  = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg  = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl  = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brXxl = BorderRadius.all(Radius.circular(xxl));
}

class DoctorSizes {
  DoctorSizes._();

  // Avatars
  static const double avatarSm = 32;
  static const double avatarMd = 40;
  static const double avatarLg = 56;
  static const double avatarXl = 80;

  // Icon buttons
  static const double iconBtnSm = 32;
  static const double iconBtnMd = 40;
  static const double iconBtnLg = 48;

  // App bar / header
  static const double headerCurveHeight = 160;
}
