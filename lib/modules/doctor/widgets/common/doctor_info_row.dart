import 'package:flutter/material.dart';
import '../../theme/doctor_theme.dart';

/// Horizontal label / value pair row.
///
/// ```dart
/// DoctorInfoRow(label: 'Patient', value: 'John Doe')
/// DoctorInfoRow(label: 'Fee',     value: '₹500', icon: Icons.currency_rupee)
/// ```
class DoctorInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;
  final bool bold;

  const DoctorInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: DoctorFontWeight.medium,
        );
    final valueStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: valueColor,
          fontWeight:
              bold ? DoctorFontWeight.semiBold : DoctorFontWeight.regular,
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 15, color: onSurface.withOpacity(0.45)),
          const SizedBox(width: 5),
        ],
        Text('$label: ', style: labelStyle),
        Expanded(
          child: Text(value, style: valueStyle, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
