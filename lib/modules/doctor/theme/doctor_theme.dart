import 'package:flutter/material.dart';

import 'doctor_colors.dart';
import 'doctor_dark_colors.dart';
import 'doctor_dimensions.dart';
import 'doctor_text_styles.dart';
import 'doctor_typography.dart';

export 'doctor_colors.dart';
export 'doctor_dark_colors.dart';
export 'doctor_dimensions.dart';
export 'doctor_gradients.dart';
export 'doctor_shadows.dart';
export 'doctor_text_styles.dart';
export 'doctor_theme_controller.dart';
export 'doctor_typography.dart';

/// ThemeData factory for the Doctor module.
///
/// Wrap the doctor shell with:
///   Theme(data: DoctorTheme.light, child: ...)   // light
///   Theme(data: DoctorTheme.dark,  child: ...)   // dark
///
/// The [DoctorThemeController] + [DoctorShellScreen] handle switching
/// automatically — individual screens need no changes.
class DoctorTheme {
  DoctorTheme._();

  // ─────────────────────────────────────────────────────────────
  //  LIGHT  (existing design — nothing changed)
  // ─────────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: false,
        brightness: Brightness.light,
        primaryColor: DoctorColors.primary,
        scaffoldBackgroundColor: DoctorColors.background,
        canvasColor: DoctorColors.cardWhite,
        dividerColor: DoctorColors.divider,
        colorScheme: const ColorScheme.light(
          primary: DoctorColors.primary,
          onPrimary: Colors.white,
          secondary: DoctorColors.primaryAccent,
          onSecondary: Colors.white,
          surface: DoctorColors.cardWhite,
          onSurface: DoctorColors.textPrimary,
          error: DoctorColors.errorRed,
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: DoctorColors.primary,
          foregroundColor: Colors.white,
          titleTextStyle: DoctorTextStyles.headerTitle,
        ),
        textTheme: const TextTheme(
          titleLarge: DoctorTextStyles.sectionTitle,
          titleMedium: DoctorTextStyles.cardTitle,
          titleSmall: DoctorTextStyles.cardSubtitle,
          bodyLarge: DoctorTextStyles.bodyLarge,
          bodyMedium: DoctorTextStyles.body,
          bodySmall: DoctorTextStyles.bodySmall,
          labelLarge: DoctorTextStyles.buttonPrimary,
          labelMedium: DoctorTextStyles.label,
          labelSmall: DoctorTextStyles.hint,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: DoctorColors.cardWhite,
          contentPadding: DoctorSpacing.fieldPadding,
          hintStyle: DoctorTextStyles.hint,
          labelStyle: DoctorTextStyles.label,
          border: OutlineInputBorder(
            borderRadius: DoctorRadii.brMd,
            borderSide: const BorderSide(color: DoctorColors.fieldBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: DoctorRadii.brMd,
            borderSide: const BorderSide(color: DoctorColors.fieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: DoctorRadii.brMd,
            borderSide:
                const BorderSide(color: DoctorColors.primary, width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: DoctorRadii.brMd,
            borderSide: const BorderSide(color: DoctorColors.errorRed),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: DoctorColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: DoctorSpacing.xl,
              vertical: DoctorSpacing.md,
            ),
            shape:
                const RoundedRectangleBorder(borderRadius: DoctorRadii.brMd),
            textStyle: DoctorTextStyles.buttonPrimary,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: DoctorColors.primary,
            side: const BorderSide(color: DoctorColors.primary),
            padding: const EdgeInsets.symmetric(
              horizontal: DoctorSpacing.xl,
              vertical: DoctorSpacing.md,
            ),
            shape:
                const RoundedRectangleBorder(borderRadius: DoctorRadii.brMd),
            textStyle: DoctorTextStyles.buttonSecondary,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: DoctorColors.primary,
            textStyle: DoctorTextStyles.buttonSecondary,
          ),
        ),
        cardTheme: const CardThemeData(
          color: DoctorColors.cardWhite,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: DoctorRadii.brLg),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: DoctorColors.primarySoft,
          selectedColor: DoctorColors.primary,
          labelStyle: DoctorTextStyles.statusChip.copyWith(
            color: DoctorColors.primary,
          ),
          shape:
              const RoundedRectangleBorder(borderRadius: DoctorRadii.brSm),
          padding: const EdgeInsets.symmetric(
            horizontal: DoctorSpacing.sm,
            vertical: DoctorSpacing.xs,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: DoctorColors.divider,
          thickness: 1,
          space: DoctorSpacing.lg,
        ),
        iconTheme: const IconThemeData(color: DoctorColors.primary),
      );

  // ─────────────────────────────────────────────────────────────
  //  DARK  (new — no screen changed)
  // ─────────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,
        primaryColor: DoctorDarkColors.primary,
        scaffoldBackgroundColor: DoctorDarkColors.background,
        canvasColor: DoctorDarkColors.cardWhite,
        dividerColor: DoctorDarkColors.divider,
        colorScheme: const ColorScheme.dark(
          primary: DoctorDarkColors.primary,
          onPrimary: Colors.white,
          secondary: DoctorDarkColors.primaryAccent,
          onSecondary: Colors.white,
          surface: DoctorDarkColors.cardWhite,
          onSurface: DoctorDarkColors.textPrimary,
          error: DoctorDarkColors.errorRed,
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: DoctorDarkColors.cardWhite,
          foregroundColor: DoctorDarkColors.textPrimary,
          titleTextStyle: TextStyle(
            fontSize: DoctorFontSize.headerTitle,
            fontWeight: DoctorFontWeight.bold,
            color: DoctorDarkColors.textPrimary,
            letterSpacing: DoctorLetterSpacing.wide,
          ),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: DoctorFontSize.subtitle,
            fontWeight: DoctorFontWeight.bold,
            color: DoctorDarkColors.textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: DoctorFontSize.bodyLarge,
            fontWeight: DoctorFontWeight.semiBold,
            color: DoctorDarkColors.textPrimary,
          ),
          titleSmall: TextStyle(
            fontSize: DoctorFontSize.md,
            fontWeight: DoctorFontWeight.regular,
            color: DoctorDarkColors.textSecondary,
          ),
          bodyLarge: TextStyle(
            fontSize: DoctorFontSize.bodyLarge,
            color: DoctorDarkColors.textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: DoctorFontSize.bodyText,
            color: DoctorDarkColors.textPrimary,
          ),
          bodySmall: TextStyle(
            fontSize: DoctorFontSize.md,
            color: DoctorDarkColors.textSecondary,
          ),
          labelLarge: const TextStyle(
            fontSize: DoctorFontSize.bodyLarge,
            fontWeight: DoctorFontWeight.semiBold,
            color: Colors.white,
            letterSpacing: DoctorLetterSpacing.wide,
          ),
          labelMedium: TextStyle(
            fontSize: DoctorFontSize.label,
            fontWeight: DoctorFontWeight.medium,
            color: DoctorDarkColors.textSecondary,
          ),
          labelSmall: TextStyle(
            fontSize: DoctorFontSize.hint,
            color: DoctorDarkColors.textHint,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: DoctorDarkColors.inputBg,
          contentPadding: DoctorSpacing.fieldPadding,
          hintStyle: TextStyle(
            fontSize: DoctorFontSize.hint,
            color: DoctorDarkColors.textHint,
          ),
          labelStyle: TextStyle(
            fontSize: DoctorFontSize.label,
            fontWeight: DoctorFontWeight.medium,
            color: DoctorDarkColors.textSecondary,
          ),
          border: OutlineInputBorder(
            borderRadius: DoctorRadii.brMd,
            borderSide:
                const BorderSide(color: DoctorDarkColors.fieldBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: DoctorRadii.brMd,
            borderSide:
                const BorderSide(color: DoctorDarkColors.fieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: DoctorRadii.brMd,
            borderSide: const BorderSide(
                color: DoctorDarkColors.primary, width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: DoctorRadii.brMd,
            borderSide:
                const BorderSide(color: DoctorDarkColors.errorRed),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: DoctorDarkColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: DoctorSpacing.xl,
              vertical: DoctorSpacing.md,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: DoctorRadii.brMd),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: DoctorDarkColors.primary,
            side: const BorderSide(color: DoctorDarkColors.primary),
            padding: const EdgeInsets.symmetric(
              horizontal: DoctorSpacing.xl,
              vertical: DoctorSpacing.md,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: DoctorRadii.brMd),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: DoctorDarkColors.primary,
          ),
        ),
        cardTheme: const CardThemeData(
          color: DoctorDarkColors.cardWhite,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: DoctorRadii.brLg),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: DoctorDarkColors.primarySoft,
          selectedColor: DoctorDarkColors.primary,
          labelStyle: TextStyle(
            fontSize: DoctorFontSize.chip,
            fontWeight: DoctorFontWeight.semiBold,
            color: DoctorDarkColors.primary,
            letterSpacing: DoctorLetterSpacing.wide,
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: DoctorRadii.brSm),
          padding: const EdgeInsets.symmetric(
            horizontal: DoctorSpacing.sm,
            vertical: DoctorSpacing.xs,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: DoctorDarkColors.divider,
          thickness: 1,
          space: DoctorSpacing.lg,
        ),
        iconTheme:
            const IconThemeData(color: DoctorDarkColors.primary),
      );
}
