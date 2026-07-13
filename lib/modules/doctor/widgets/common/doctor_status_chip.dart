import 'package:flutter/material.dart';
import '../../theme/doctor_theme.dart';

/// Small rounded status label.
///
/// Pass explicit [backgroundColor] and [textColor] to match each
/// status variant (Active / Completed / Pending / Cancelled …).
///
/// Example:
/// ```dart
/// DoctorStatusChip(
///   label: 'Active',
///   backgroundColor: DoctorColors.successDeep.withOpacity(0.12),
///   textColor: DoctorColors.successDeep,
/// )
/// ```
class DoctorStatusChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final EdgeInsets? padding;

  const DoctorStatusChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.fontSize = DoctorFontSize.chip,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: DoctorRadii.brSm,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: DoctorFontWeight.semiBold,
          color: textColor,
          letterSpacing: DoctorLetterSpacing.wide,
        ),
      ),
    );
  }
}
