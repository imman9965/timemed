import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

/// PAID / UNPAID badge — a money-bag glyph plus colored text label.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.paid,
  });

  final bool paid;

  @override
  Widget build(BuildContext context) {
    final color = paid ? AppColors.paid : AppColors.unpaid;
    final label = paid ? 'PAID' : 'UNPAID';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            const Text('💰', style: TextStyle(fontSize: 20)),
            if (!paid)
              const Positioned(
                right: -2,
                top: -2,
                child: Icon(Icons.close,
                    size: 12, color: AppColors.unpaid),
              ),
          ],
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

/// Small colored chip for e.g. "Type: Own", "Type: Instant" etc.
class MiniBadge extends StatelessWidget {
  const MiniBadge({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.softBlueBg,
    this.textColor = AppColors.textPrimary,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
