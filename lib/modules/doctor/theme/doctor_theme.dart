import 'package:flutter/material.dart';

import 'doctor_colors.dart';
import 'doctor_dimensions.dart';
import 'doctor_text_styles.dart';

export 'doctor_colors.dart';
export 'doctor_dimensions.dart';
export 'doctor_gradients.dart';
export 'doctor_shadows.dart';
export 'doctor_text_styles.dart';

/// `ThemeData` factory for the Doctor module.
///
/// Wrap the doctor shell (or individual doctor screens) with `Theme(
/// data: DoctorTheme.light, child: ...)` to apply this theme without
/// affecting the rest of the app. The visual language of the existing
/// screens is preserved — this only centralises the tokens.
class DoctorTheme {
  DoctorTheme._();

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
            borderSide: const BorderSide(color: DoctorColors.primary, width: 1.4),
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
            shape: const RoundedRectangleBorder(borderRadius: DoctorRadii.brMd),
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
            shape: const RoundedRectangleBorder(borderRadius: DoctorRadii.brMd),
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
          shape: const RoundedRectangleBorder(borderRadius: DoctorRadii.brSm),
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
}
