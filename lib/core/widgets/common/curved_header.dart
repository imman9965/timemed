import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_dimens.dart';
import '../../constants/app_text_styles.dart';


/// The blue header banner used on every screen. It sits flush to the top
/// of the scaffold body and curves on its bottom edge.
///
/// Supports single- or two-line titles and an optional trailing widget
/// (e.g. the "On call 02:39" indicator on the video call screen).
class CurvedHeader extends StatelessWidget {
  const CurvedHeader({
    super.key,
    required this.title,
    this.trailing,
    this.height,
    this.titleStyle,
    this.titleAlignment = TextAlign.center,
    this.onNotificationTap,
    this.showNotification = false,
  });

  final String title;
  final Widget? trailing;
  final double? height;
  final TextStyle? titleStyle;
  final TextAlign titleAlignment;

  /// 🔔 NEW
  final VoidCallback? onNotificationTap;
  final bool showNotification;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HeaderClipper(),
      child: Container(
        height: height ?? 80,
        width: double.infinity,
        color: AppColors.primaryBlue,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.screenHPadding,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// 🏷 TITLE
            Center(
              child: Text(
                title,
                textAlign: titleAlignment,
                style: titleStyle ?? AppTextStyles.headerTitle,
              ),
            ),

            /// 🔔 NOTIFICATION BUTTON
            if (showNotification)
              Positioned(
                right: AppDimens.l,
                top: 17,
                child: Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none,
                          color: Colors.white),
                      onPressed: onNotificationTap,
                    ),

                    /// 🔴 Badge
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            /// 👉 EXISTING TRAILING (kept safe)
            if (trailing != null)
              Positioned(
                right: AppDimens.l,
                bottom: AppDimens.headerBottomRadius + 4,
                child: trailing!,
              ),
          ],
        ),
      ),
    );
  }
}
/// Carves a generous rounded bottom on the header, matching the mockups.
class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 32.0;
    final path = Path()
      ..lineTo(0, size.height - radius)
      ..quadraticBezierTo(0, size.height, radius, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
