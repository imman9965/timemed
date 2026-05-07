import 'package:flutter/material.dart';

/// Central color palette for the Doctor module.
///
/// All values are consolidated from the existing screens — no design
/// changes have been introduced. Use these tokens going forward instead
/// of declaring private `_primary`, `_textPrimary`, etc. inside each file.
class DoctorColors {
  DoctorColors._();

  // ─────────────────────────────────────────────────────────────
  //  PRIMARY / BRAND  (blue family)
  // ─────────────────────────────────────────────────────────────
  static const Color primaryDark    = Color(0xFF1E5FBF);
  static const Color primary        = Color(0xFF2F7BE0);
  static const Color primaryLight   = Color(0xFF5EA1F0);
  static const Color primaryVivid   = Color(0xFF1A6BF5); // schedule / vitals
  static const Color primaryDeep    = Color(0xFF0473EA); // login / orbs
  static const Color primaryAccent  = Color(0xFF47A6FF);
  static const Color primarySoft    = Color(0xFFE5EFFC); // soft chip bg
  static const Color hospitalBlue   = Color(0xFF1A73FF);

  // Material blue stops (used in gradients & medical_history)
  static const Color blue900 = Color(0xFF0D47A1);
  static const Color blue800 = Color(0xFF1565C0);
  static const Color blue700 = Color(0xFF1976D2);
  static const Color blue500 = Color(0xFF2196F3);
  static const Color blue400 = Color(0xFF42A5F5);
  static const Color blue200 = Color(0xFF90CAF9);
  static const Color blue100 = Color(0xFFBBDEFB);
  static const Color blue50  = Color(0xFFE3F2FD);

  // ─────────────────────────────────────────────────────────────
  //  SURFACES / BACKGROUNDS
  // ─────────────────────────────────────────────────────────────
  static const Color background         = Color(0xFFF4F8FE);
  static const Color backgroundSky      = Color(0xFFEEF4FF);
  static const Color backgroundCool     = Color(0xFFF5F7FA);
  static const Color backgroundMist     = Color(0xFFF8F9FB);
  static const Color backgroundIce      = Color(0xFFF5F9FF);
  static const Color backgroundFrost    = Color(0xFFF5F8FF);
  static const Color backgroundCream    = Color(0xFFFAF5EC);
  static const Color backgroundPaper    = Color(0xFFFAF7F2);
  static const Color backgroundLavender = Color(0xFFF7F2FA);
  static const Color backgroundStone    = Color(0xFFF2F4F7);
  static const Color cardWhite          = Colors.white;

  // ─────────────────────────────────────────────────────────────
  //  BORDERS / DIVIDERS
  // ─────────────────────────────────────────────────────────────
  static const Color fieldBorder     = Color(0xFFD9E2F0);
  static const Color borderGreyLight = Color(0xFFD9D9D9);
  static const Color divider         = Color(0xFFE5E5E5);
  static const Color dividerCool     = Color(0xFFE5EAF2);
  static const Color dividerNeutral  = Color(0xFFE0E0E0);
  static const Color dividerSoft     = Color(0xFFD6E4FF);
  static const Color dividerDark     = Color(0xFFCFD8DC);

  // ─────────────────────────────────────────────────────────────
  //  TEXT
  // ─────────────────────────────────────────────────────────────
  static const Color textPrimary    = Color(0xFF1A2236);
  static const Color textSecondary  = Color(0xFF6B7280);
  static const Color textHint       = Color(0xFF94A3B8);
  static const Color textDark       = Color(0xFF1A1A2E);
  static const Color textBlack      = Color(0xFF111111);
  static const Color textMuted      = Color(0xFF9E9E9E);
  static const Color textHintGrey   = Color(0xFF6B6B6B);
  static const Color textDisabled   = Color(0xFFB0B0B0);

  // ─────────────────────────────────────────────────────────────
  //  SEMANTIC — SUCCESS / GREEN FAMILY
  // ─────────────────────────────────────────────────────────────
  static const Color success         = Color(0xFF4CAF50);
  static const Color successDeep     = Color(0xFF2E7D32);
  static const Color successMint     = Color(0xFF2DCE89);
  static const Color successMintDeep = Color(0xFF26B875);
  static const Color successTeal     = Color(0xFF0FA37F);
  static const Color successFresh    = Color(0xFF2BB673);
  static const Color successJade     = Color(0xFF1FA38C);

  // ─────────────────────────────────────────────────────────────
  //  SEMANTIC — ERROR / RED FAMILY
  // ─────────────────────────────────────────────────────────────
  static const Color error         = Color(0xFFE53935);
  static const Color errorRed      = Color(0xFFEF4444);
  static const Color errorRose     = Color(0xFFFF6B6B);
  static const Color errorRoseDeep = Color(0xFFEE5A5A);
  static const Color errorCrimson  = Color(0xFFFF1744);
  static const Color errorSoftBg   = Color(0xFFFEE2E2);
  static const Color errorCoral    = Color(0xFFE94B4B);

  // ─────────────────────────────────────────────────────────────
  //  SEMANTIC — WARNING / AMBER FAMILY
  // ─────────────────────────────────────────────────────────────
  static const Color warningAmber   = Color(0xFFFFC107);
  static const Color warningOrange  = Color(0xFFFFB347);
  static const Color warningGold    = Color(0xFFF5B400);
  static const Color warningBronze  = Color(0xFFB07A00);
  static const Color warningSoftBg  = Color(0xFFFFF8E1);
  static const Color warningPeach   = Color(0xFFC05A00);
  static const Color warningPeachBg = Color(0xFFFFF0E6);

  // ─────────────────────────────────────────────────────────────
  //  NEUTRALS / MISC
  // ─────────────────────────────────────────────────────────────
  static const Color inputBg         = Color(0xFFF2F2F2);
  static const Color inputBgSoft     = Color(0xFFF5F5F5);
  static const Color rowBg           = Color(0xFFF4F4F4);
  static const Color stoneTan        = Color(0xFFF1EFE8);
  static const Color stoneGrey       = Color(0xFF888780);
  static const Color stoneLight      = Color(0xFFB4B2A9);
  static const Color stonePeachLine  = Color(0xFFF0C8A0);
  static const Color avatarGrey      = Color(0xFFBDBDBD);
  static const Color avatarLight     = Color(0xFFD6DCE5);
  static const Color avatarMid       = Color(0xFFB0BAC8);
  static const Color circleBorder    = Color(0xFFB0BFD4);
  static const Color callDarkBg      = Color(0xFF1C1C1E);
  static const Color callDarkSurface = Color(0xFF2C2C2E);
}
