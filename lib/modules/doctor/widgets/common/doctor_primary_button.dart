import 'package:flutter/material.dart';
import '../../theme/doctor_theme.dart';

/// Full-width or fixed-width primary button for the doctor module.
///
/// Color defaults to [Theme.of(context).colorScheme.primary] so it
/// adapts to light / dark theme automatically.
class DoctorPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final double height;
  final double? width;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? leadingIcon;
  final double borderRadius;

  const DoctorPrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.height = 50,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.leadingIcon,
    this.borderRadius = DoctorRadii.md,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).colorScheme.primary;
    final fg = foregroundColor ?? Colors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              leadingIcon!,
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: DoctorFontSize.bodyLarge,
                fontWeight: DoctorFontWeight.bold,
                color: fg,
                letterSpacing: DoctorLetterSpacing.wide,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
