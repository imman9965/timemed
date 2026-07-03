import 'package:flutter/material.dart';
import '../../theme/doctor_theme.dart';

/// Circular avatar — shows a network image when [imageUrl] is provided,
/// otherwise falls back to [initials] text on a tinted background.
class DoctorAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  const DoctorAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = DoctorSizes.avatarMd,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final bg = backgroundColor ?? primary.withOpacity(0.12);
    final fg = textColor ?? primary;

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: bg,
      backgroundImage:
          imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
              ((initials ?? '?').isNotEmpty
                      ? initials![0]
                      : '?')
                  .toUpperCase(),
              style: TextStyle(
                fontSize: size * 0.38,
                fontWeight: DoctorFontWeight.bold,
                color: fg,
              ),
            )
          : null,
    );
  }
}
