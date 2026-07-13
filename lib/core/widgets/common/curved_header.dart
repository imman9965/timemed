import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../modules/doctor/theme/doctor_colors.dart';
import '../../constants/app_dimens.dart';

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
    this.badgeCount = 0,
    this.showBackButton = true,
    this.onBackTap,
  });

  final String title;
  final Widget? trailing;
  final double? height;
  final TextStyle? titleStyle;
  final TextAlign titleAlignment;

  final VoidCallback? onNotificationTap;
  final bool showNotification;

  /// Unread notification count shown on the bell. When 0, no badge is drawn.
  final int badgeCount;

  final bool showBackButton;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 100,
      width: double.infinity,
      color: DoctorColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.screenHPadding),
      child: Stack(
        children: [
          if (showBackButton && context.canPop())
            Positioned(
              left: 0,
              top: 41,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: onBackTap ?? () => context.pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 60,
            right: 60,
            bottom: 26,
            child: Text(
              title,
              textAlign: titleAlignment,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  titleStyle ??
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
          ),
          if (showNotification)
            Positioned(
              right: 0,
              top: 41,
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: onNotificationTap,
                  ),

                  if (badgeCount > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            badgeCount > 99 ? '99+' : '$badgeCount',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          /// Trailing Widget
          if (trailing != null)
            Positioned(
              right: 0,
              bottom:26 ,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}

/// Optional Clipper
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 50.0;

    final path = Path();

    path.lineTo(0, radius);

    path.quadraticBezierTo(0, 0, radius, 0);

    path.lineTo(size.width - radius, 0);

    path.quadraticBezierTo(size.width, 0, size.width, radius);

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
