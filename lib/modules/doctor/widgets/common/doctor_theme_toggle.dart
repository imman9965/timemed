import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/doctor_theme.dart';

/// Sun / moon icon button that toggles [DoctorThemeController].
///
/// Drop this anywhere inside the doctor shell — typically in an
/// AppBar action or profile screen header.
///
/// ```dart
/// const DoctorThemeToggle()          // uses controller from Get.find
/// DoctorThemeToggle(iconColor: DoctorColors.primaryBrand)
/// ```
class DoctorThemeToggle extends StatelessWidget {
  final Color? iconColor;

  const DoctorThemeToggle({super.key, this.iconColor});

  @override
  Widget build(BuildContext context) {
    final ctrl = DoctorThemeController.to;
    return Obx(() {
      final isDark = ctrl.isDark;
      return IconButton(
        tooltip: isDark ? 'Switch to Light' : 'Switch to Dark',
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) =>
              RotationTransition(turns: anim, child: child),
          child: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            key: ValueKey(isDark),
            color: iconColor ?? Colors.white,
            size: 22,
          ),
        ),
        onPressed: ctrl.toggle,
      );
    });
  }
}
