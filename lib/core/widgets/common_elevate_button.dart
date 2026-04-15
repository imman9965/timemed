import 'package:flutter/material.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final double borderRadius;
  final TextStyle? textStyle;

  const CommonButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width,
    this.height,
    this.color,
    this.borderRadius = 8,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, // default full width
      height: height ?? 50, // default height
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style:
              textStyle ??
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
