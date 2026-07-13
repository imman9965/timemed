import 'package:flutter/material.dart';

/// Dark-mode color palette for the Doctor module.
/// Mirrors every token in [DoctorColors] — swap to get dark theme.
/// All values are new; no light-theme color is modified.
class DoctorDarkColors {
  DoctorDarkColors._();

  // ─────────────────────────────────────────────────────────────
  //  PRIMARY / BRAND
  // ─────────────────────────────────────────────────────────────
  static const Color primaryDark    = Color(0xFF2A7FE8);
  static const Color primary        = Color(0xFF4D96F0);
  static const Color primaryLight   = Color(0xFF7BB5F5);
  static const Color primaryVivid   = Color(0xFF3D82F7);
  static const Color primaryDeep    = Color(0xFF2485F5);
  static const Color primaryAccent  = Color(0xFF60B4FF);
  static const Color primarySoft    = Color(0xFF162340);
  static const Color hospitalBlue   = Color(0xFF3D82F7);
  static const Color primaryBrand   = Color(0xFF2485F5);

  static const Color blue900 = Color(0xFF1A5DC5);
  static const Color blue800 = Color(0xFF1E6ED4);
  static const Color blue700 = Color(0xFF2279E0);
  static const Color blue500 = Color(0xFF42A5F5);
  static const Color blue400 = Color(0xFF64B5F6);
  static const Color blue200 = Color(0xFF90CAF9);
  static const Color blue100 = Color(0xFFBBDEFB);
  static const Color blue50  = Color(0xFF121E2C);

  // ─────────────────────────────────────────────────────────────
  //  SURFACES / BACKGROUNDS
  // ─────────────────────────────────────────────────────────────
  static const Color background         = Color(0xFF0F1624);
  static const Color backgroundSky      = Color(0xFF0D1520);
  static const Color backgroundCool     = Color(0xFF111822);
  static const Color backgroundMist     = Color(0xFF131A27);
  static const Color backgroundIce      = Color(0xFF0E1928);
  static const Color backgroundFrost    = Color(0xFF101828);
  static const Color backgroundCream    = Color(0xFF141520);
  static const Color backgroundPaper    = Color(0xFF131520);
  static const Color backgroundWarm     = Color(0xFF0F1220);
  static const Color backgroundLavender = Color(0xFF16132A);
  static const Color backgroundStone    = Color(0xFF141822);
  static const Color cardWhite          = Color(0xFF1C2333);

  // ─────────────────────────────────────────────────────────────
  //  BORDERS / DIVIDERS
  // ─────────────────────────────────────────────────────────────
  static const Color fieldBorder     = Color(0xFF2A3550);
  static const Color borderGreyLight = Color(0xFF303850);
  static const Color divider         = Color(0xFF2D3748);
  static const Color dividerCool     = Color(0xFF2A3550);
  static const Color dividerNeutral  = Color(0xFF303848);
  static const Color dividerSoft     = Color(0xFF1E2F48);
  static const Color dividerDark     = Color(0xFF3A4560);

  // ─────────────────────────────────────────────────────────────
  //  TEXT
  // ─────────────────────────────────────────────────────────────
  static const Color textPrimary    = Color(0xFFE8EFF8);
  static const Color textSecondary  = Color(0xFF94A3B8);
  static const Color textHint       = Color(0xFF64748B);
  static const Color textDark       = Color(0xFFE8E8F0);
  static const Color textBlack      = Color(0xFFEEEEEE);
  static const Color textMuted      = Color(0xFF708090);
  static const Color textHintGrey   = Color(0xFF8898AA);
  static const Color textDisabled   = Color(0xFF505870);

  // ─────────────────────────────────────────────────────────────
  //  SUCCESS
  // ─────────────────────────────────────────────────────────────
  static const Color success         = Color(0xFF4CAF50);
  static const Color successDeep     = Color(0xFF43A047);
  static const Color successMint     = Color(0xFF2DCE89);
  static const Color successMintDeep = Color(0xFF26B875);
  static const Color successTeal     = Color(0xFF0FA37F);
  static const Color successFresh    = Color(0xFF2BB673);
  static const Color successJade     = Color(0xFF1FA38C);

  // ─────────────────────────────────────────────────────────────
  //  ERROR
  // ─────────────────────────────────────────────────────────────
  static const Color error         = Color(0xFFEF5350);
  static const Color errorRed      = Color(0xFFEF4444);
  static const Color errorRose     = Color(0xFFFF6B6B);
  static const Color errorRoseDeep = Color(0xFFEE5A5A);
  static const Color errorCrimson  = Color(0xFFFF1744);
  static const Color errorSoftBg   = Color(0xFF2D1515);
  static const Color errorCoral    = Color(0xFFE94B4B);

  // ─────────────────────────────────────────────────────────────
  //  WARNING
  // ─────────────────────────────────────────────────────────────
  static const Color warningAmber   = Color(0xFFFFC107);
  static const Color warningOrange  = Color(0xFFFFB347);
  static const Color warningGold    = Color(0xFFF5B400);
  static const Color warningPending = Color(0xFFF59E0B);
  static const Color warningBronze  = Color(0xFFB07A00);
  static const Color warningSoftBg  = Color(0xFF2A2010);
  static const Color warningPeach   = Color(0xFFC05A00);
  static const Color warningPeachBg = Color(0xFF271A0A);

  // ─────────────────────────────────────────────────────────────
  //  NEUTRALS
  // ─────────────────────────────────────────────────────────────
  static const Color inputBg         = Color(0xFF1A2236);
  static const Color inputBgSoft     = Color(0xFF1E2640);
  static const Color rowBg           = Color(0xFF1A2030);
  static const Color stoneTan        = Color(0xFF1E2030);
  static const Color stoneGrey       = Color(0xFF607080);
  static const Color stoneLight      = Color(0xFF4A5568);
  static const Color stonePeachLine  = Color(0xFF5A4030);
  static const Color avatarGrey      = Color(0xFF4A5568);
  static const Color avatarLight     = Color(0xFF2D3A50);
  static const Color avatarMid       = Color(0xFF3A4860);
  static const Color circleBorder    = Color(0xFF3A4F6A);
  static const Color callDarkBg      = Color(0xFF0A0A0E);
  static const Color callDarkSurface = Color(0xFF18181E);

  // ─────────────────────────────────────────────────────────────
  //  BADGES
  // ─────────────────────────────────────────────────────────────
  static const Color badgeIndigo    = Color(0xFF1A1E3A);
  static const Color badgeGreen     = Color(0xFF0F2A18);
  static const Color badgeGreenText = Color(0xFF4CAF50);
  static const Color badgeBlue      = Color(0xFF0F2040);
  static const Color badgeBlueText  = Color(0xFF4D96F0);
}
