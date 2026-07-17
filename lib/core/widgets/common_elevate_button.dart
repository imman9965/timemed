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
  final bool isOutlined;

  const CommonButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width,
    this.height,
    this.color,
    this.borderRadius = 10,
    this.textStyle,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 40,
      child: isOutlined
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color ?? AppColors.secondaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                title,
                style: textStyle ??
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color ?? AppColors.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                title,
                style: textStyle ??
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
    );
  }
}
