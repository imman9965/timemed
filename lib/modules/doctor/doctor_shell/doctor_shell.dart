import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';

class DoctorShellScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const DoctorShellScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);

  @override
  State<DoctorShellScreen> createState() => _DoctorShellScreenState();
}

class _DoctorShellScreenState extends State<DoctorShellScreen> {
  /// Stack of visited tab indices — most recent on top
  final List<int> _tabHistory = [0];

  void _onTabTapped(int index) {
    if (index != widget.navigationShell.currentIndex) {
      // Remove if already in history to avoid duplicates, then push on top
      _tabHistory.remove(index);
      _tabHistory.add(index);
    }

    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  /// Returns true if we handled the back press (went to previous tab)
  bool _onBackPressed() {
    if (_tabHistory.length > 1) {
      // Remove current tab from history
      _tabHistory.removeLast();
      // Navigate to the previous tab
      final previousIndex = _tabHistory.last;
      widget.navigationShell.goBranch(previousIndex);
      return true; // consumed the back press
    }
    return false; // let system handle it (exit app)
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _tabHistory.length <= 1,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onBackPressed();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: widget.navigationShell,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CalendarBottomNav(
                activeIndex: widget.navigationShell.currentIndex,
                onTap: _onTabTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
