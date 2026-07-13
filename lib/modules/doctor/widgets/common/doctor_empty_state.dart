import 'package:flutter/material.dart';
import '../../theme/doctor_theme.dart';

/// Centered empty-state placeholder used on list / record screens.
///
/// Matches the existing visual pattern (circle icon + label).
class DoctorEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? iconColor;
  final double iconSize;

  const DoctorEmptyState({
    super.key,
    this.message = 'No records yet',
    this.icon = Icons.inbox_outlined,
    this.iconColor,
    this.iconSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final color = iconColor ?? primary;
    final textStyle = Theme.of(context).textTheme.bodySmall;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: iconSize),
          ),
          const SizedBox(height: 8),
          Text(message, style: textStyle),
        ],
      ),
    );
  }
}
