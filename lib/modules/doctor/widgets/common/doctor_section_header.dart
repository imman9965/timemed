import 'package:flutter/material.dart';
import '../../theme/doctor_theme.dart';

/// Section title row with an optional trailing action widget.
///
/// ```dart
/// DoctorSectionHeader(title: 'Lab Test Records')
/// DoctorSectionHeader(
///   title: 'Appointments',
///   action: TextButton(onPressed: _seeAll, child: Text('See All')),
/// )
/// ```
class DoctorSectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  final EdgeInsets? padding;

  const DoctorSectionHeader({
    super.key,
    required this.title,
    this.action,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

/// Thin colored left-border accent used inside cards.
class DoctorAccentLabel extends StatelessWidget {
  final String text;
  final Color? accentColor;
  final TextStyle? style;

  const DoctorAccentLabel({
    super.key,
    required this.text,
    this.accentColor,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final color = accentColor ?? primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: DoctorRadii.brXs,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: style ??
              TextStyle(
                fontSize: DoctorFontSize.bodyText,
                fontWeight: DoctorFontWeight.semiBold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }
}
