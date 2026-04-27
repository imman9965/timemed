import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';

/// ════════════════════════════════════════════════════════
///  DOCTOR SHELL — persistent bottom nav across all tabs
/// ════════════════════════════════════════════════════════
class DoctorShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DoctorShellScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // Main content — each branch renders here
          Padding(
            padding: const EdgeInsets.only(bottom: 90),
            child: navigationShell,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CalendarBottomNav(
              activeIndex: navigationShell.currentIndex,
              onTap: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
