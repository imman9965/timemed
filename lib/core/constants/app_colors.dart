import 'dart:ui';

class AppColors {
  AppColors._(); // prevents instantiation

  /// 🌟 Primary Theme Colors
  static const Color primary = Color(0xff0f674a);
  static const Color primaryColor = Color(0xff1a434e);
  static const Color secondary = Color(0xff2f6f7e);

  /// ❌ Error & Alert Colors
  static const Color error = Color(0xffc72c41);
  static const Color warning = Color(0xfff9a825);
  static const Color success = Color(0xff2e7d32);

  /// ⚪ Background Colors
  static const Color background = Color(0xfff5f7fa);
  static const Color scaffold = Color(0xffffffff);
  static const Color card = Color(0xfffdfdfd);

  /// 🔤 Text Colors
  static const Color textDark = Color(0xff000000);
  static const Color textLight = Color(0xffffffff);
  static const Color textPrimary = Color(0xff212121);
  static const Color textSecondary = Color(0xff757575);
  static const Color textHint = Color(0xff9e9e9e);

  /// ➖ Border & Divider
  static const Color border = Color(0xffe0e0e0);
  static const Color divider = Color(0xffeeeeee);

  /// 🌫 Disabled / Grey
  static const Color disabled = Color(0xffbdbdbd);
}
