import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../theme/doctor_theme.dart';
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
  late final DoctorThemeController _themeCtrl;

  /// Stack of visited tab indices — most recent on top
  final List<int> _tabHistory = [0];

  @override
  void initState() {
    super.initState();
    _themeCtrl = Get.put(DoctorThemeController(), permanent: false);
  }

  @override
  void dispose() {
    Get.delete<DoctorThemeController>();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index != widget.navigationShell.currentIndex) {
      _tabHistory.remove(index);
      _tabHistory.add(index);
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  bool _onBackPressed() {
    if (_tabHistory.length > 1) {
      _tabHistory.removeLast();
      final previousIndex = _tabHistory.last;
      widget.navigationShell.goBranch(previousIndex);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = _themeCtrl.isDark;
      return Theme(
        data: isDark ? DoctorTheme.dark : DoctorTheme.light,
        child: PopScope(
          canPop: _tabHistory.length <= 1,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) _onBackPressed();
          },
          child: Scaffold(
            backgroundColor: isDark
                ? DoctorDarkColors.backgroundWarm
                : DoctorColors.backgroundWarm,
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
        ),
      );
    });
  }
}
