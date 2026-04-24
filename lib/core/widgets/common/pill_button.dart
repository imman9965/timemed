import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_dimens.dart';


/// A fully-rounded button. The design uses these almost exclusively —
/// green for positive actions, blue for primary, red for destructive,
/// light grey for secondary.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = AppColors.accentGreen,
    this.textColor = Colors.white,
    this.height = 38,
    this.horizontalPadding = 18,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
  });

  /// Blue variant
  factory PillButton.blue({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
  }) =>
      PillButton(
        label: label,
        onPressed: onPressed,
        icon: icon,
        color: AppColors.primaryBlue,
      );

  /// Green positive action
  factory PillButton.green({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
  }) =>
      PillButton(
        label: label,
        onPressed: onPressed,
        icon: icon,
        color: AppColors.accentGreen,
      );

  /// Red destructive action
  factory PillButton.red({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
  }) =>
      PillButton(
        label: label,
        onPressed: onPressed,
        icon: icon,
        color: AppColors.accentRed,
      );

  /// Light grey secondary
  factory PillButton.light({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
  }) =>
      PillButton(
        label: label,
        onPressed: onPressed,
        icon: icon,
        color: const Color(0xFFE5E7EB),
        textColor: AppColors.textPrimary,
      );

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color color;
  final Color textColor;
  final double height;
  final double horizontalPadding;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: textColor),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
