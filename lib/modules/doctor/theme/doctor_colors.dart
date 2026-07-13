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
  static const Color primaryBrand   = Color(0xFF0673DE); // app-wide brand primary

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
  static const Color backgroundWarm     = Color(0xFFFDFBF3); // warm scaffold bg
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
  static const Color successLightBg  = Color(0xFFC8E6C9); // green.shade100
  static const Color successLight    = Color(0xFF81C784); // green.shade300
  static const Color successMidGreen = Color(0xFF66BB6A); // green.shade400

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
  static const Color errorPink     = Color(0xFFFCEBEB);
  static const Color errorDeep     = Color(0xFFA32D2D);
  static const Color errorDeeper   = Color(0xFF791F1F);

  // ─────────────────────────────────────────────────────────────
  //  SEMANTIC — WARNING / AMBER FAMILY
  // ─────────────────────────────────────────────────────────────
  static const Color warningAmber   = Color(0xFFFFC107);
  static const Color warningOrange  = Color(0xFFFFB347);
  static const Color warningGold    = Color(0xFFF5B400);
  static const Color warningPending = Color(0xFFF59E0B); // pending/waiting chip colour
  static const Color warningBronze  = Color(0xFFB07A00);
  static const Color warningSoftBg  = Color(0xFFFFF8E1);
  static const Color warningPeach   = Color(0xFFC05A00);
  static const Color warningPeachBg = Color(0xFFFFF0E6);

  // ─────────────────────────────────────────────────────────────
  //  MEDICAL BLUE FAMILY (medical_records / disconnect)
  // ─────────────────────────────────────────────────────────────
  static const Color medicalNavy    = Color(0xFF0C447C);
  static const Color medicalBlue    = Color(0xFF185FA5);
  static const Color medicalBlueMed = Color(0xFF378ADD);
  static const Color medicalBlueSoft = Color(0xFFE6F1FB);

  // ─────────────────────────────────────────────────────────────
  //  CALL PAGE — GREEN / STONE TONES
  // ─────────────────────────────────────────────────────────────
  static const Color callGreenDark   = Color(0xFF27500A);
  static const Color callGreenLight  = Color(0xFFC0DD97);
  static const Color callGreenSoft   = Color(0xFFE1F5EE);
  static const Color callGreenDeep   = Color(0xFF0F6E56);
  static const Color callGreenSoftBg = Color(0xFFEAF3DE);
  static const Color callGreenText   = Color(0xFF3B6D11);
  static const Color callAmber       = Color(0xFFBA7517);
  static const Color callStoneWarm   = Color(0xFFD3D1C7);
  static const Color callStoneMid    = Color(0xFF5F5E5A);
  static const Color callStoneDark   = Color(0xFF2C2C2A);

  // ─────────────────────────────────────────────────────────────
  //  MISC BRAND COLORS
  // ─────────────────────────────────────────────────────────────
  static const Color purple      = Color(0xFF6B4FBE);
  static const Color greyLight   = Color(0xFFEEEEEE); // grey.shade200
  static const Color greyMedium  = Color(0xFF757575); // grey.shade600

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

  // ─────────────────────────────────────────────────────────────
  //  BADGE BACKGROUNDS
  // ─────────────────────────────────────────────────────────────
  static const Color badgeIndigo     = Color(0xFFE8EAF6); // type / specialty badge
  static const Color badgeGreen      = Color(0xFFD4EDDA);
  static const Color badgeGreenText  = Color(0xFF2E7D32);
  static const Color badgeBlue       = Color(0xFFDCEAFE);
  static const Color badgeBlueText   = Color(0xFF1A6BF5);
}


class DoctorColors1 {
  DoctorColors1._();

  // ── Brand ──────────────────────────────────────────────────────
  static const Color primary       = Color(0xFF1E7BE9);
  static const Color primaryDark   = Color(0xFF0A4FB2);
  static const Color primarySoft   = Color(0xFFE8F1FC);


  // ── Status / accents ───────────────────────────────────────────
  static const Color success       = Color(0xFF2A6E2D);
  static const Color successTeal   = Color(0xFF1ABC9C);
  static const Color successMint   = Color(0xFF24B89A);
  static const Color warningAmber  = Color(0xFFF1A641);
  static const Color warningOrange = Color(0xFFFFB661);
  static const Color error         = Color(0xFFE53935);
  static const Color errorRose     = Color(0xFFFF6A6A);
  static const Color purple        = Color(0xFFB14FB5);
  static const Color sky           = Color(0xFF3FB6D5);
  static const Color olive         = Color(0xFFA8C947);
  static const Color navy          = Color(0xFF424B5A);

  // ── Surfaces ───────────────────────────────────────────────────
  static const Color scaffoldBg    = Color(0xFFF6F7FB);
  static const Color inputBgSoft   = Color(0xFFF1F3F8);
  static const Color cardBg        = Colors.white;
  static const Color stroke        = Color(0xFFE6E8EE);

  // ── Text ───────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A1A2E);
  static const Color textMuted     = Color(0xFF9AA0A6);
  static const Color textSecond    = Color(0xFF6B7280);

  // ── Card gradient pairs (for stunning stat cards) ──────────────
  static const List<Color> gradScheduled = [Color(0xFF22C9A8), Color(0xFF14A789)];
  static const List<Color> gradWaiting   = [Color(0xFF4CC3E0), Color(0xFF2EA8C8)];
  static const List<Color> gradChecked   = [Color(0xFFFF6A6A), Color(0xFFE54848)];
  static const List<Color> gradCancel    = [Color(0xFFFFB661), Color(0xFFF09030)];
  static const List<Color> gradOnline    = [Color(0xFFC964CE), Color(0xFF8E3FB0)];
  static const List<Color> gradOt        = [Color(0xFFBBD968), Color(0xFF8FB23A)];
  static const List<Color> gradFollow    = [Color(0xFF5FCBE3), Color(0xFF3DA9CB)];
  static const List<Color> gradMissed    = [Color(0xFFFFB661), Color(0xFFF09030)];
  static const List<Color> gradConfirm   = [Color(0xFF2ECCAE), Color(0xFF14A789)];
  static const List<Color> gradNavy      = [Color(0xFF566077), Color(0xFF353C4D)];
  static const List<Color> gradGreen     = [Color(0xFF36B07C), Color(0xFF1B8557)];
  static const List<Color> gradPrimary   = [Color(0xFF1E7BE9), Color(0xFF0A4FB2)];
  static const List<Color> gradAmber     = [Color(0xFFFFB661), Color(0xFFF09030)];
}