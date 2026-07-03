import 'package:flutter/material.dart';
import '../../theme/doctor_theme.dart';

/// White / dark-surface card container used across the doctor module.
///
/// Picks its surface color from [Theme.of(context).colorScheme.surface]
/// so it adapts automatically when dark theme is active.
class DoctorSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final bool showBorder;
  final Color? color;

  const DoctorSectionCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = DoctorRadii.md,
    this.showBorder = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final surface =
        color ?? Theme.of(context).colorScheme.surface;
    final border = Theme.of(context).dividerColor;
    return Container(
      margin: margin,
      padding: padding ?? DoctorSpacing.cardPadding,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(color: border.withOpacity(0.6))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
