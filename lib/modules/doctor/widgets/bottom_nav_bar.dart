import 'package:flutter/material.dart';
import '../theme/doctor_theme.dart';
import '../calendar/calendar_page.dart';

class CalendarBottomNav extends StatefulWidget {
  final int activeIndex;
  final void Function(int) onTap;

  const CalendarBottomNav({
    Key? key,
    required this.activeIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CalendarBottomNav> createState() => _CalendarBottomNavState();
}

class _CalendarBottomNavState extends State<CalendarBottomNav> {
  late final ScrollController _scrollController;



  static const List<NavItem> _navItems = [
    NavItem(iconPath: 'assets/bottom_nav_icon/dashboard.png', label: 'Dashboard'),
    NavItem(iconPath: 'assets/bottom_nav_icon/calendar.png', label: 'Calendar'),
    NavItem(iconPath: 'assets/bottom_nav_icon/person.png', label: 'Waiting'),
    NavItem(iconPath: 'assets/bottom_nav_icon/call_logs.png', label: 'Calls'),
    NavItem(iconPath: 'assets/bottom_nav_icon/call_direct.png', label: 'Missed'),
  ];

  // Icons for items without PNG assets
  static const List<IconData?> _fallbackIcons = [
    null, // Dashboard — has PNG
    null, // Calendar — has PNG
    null, // Waiting — has PNG
    null, // Calls — has PNG
    null, // Missed — has PNG
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(covariant CalendarBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeIndex != widget.activeIndex) {
      _scrollToActive();
    }
  }

  void _scrollToActive() {
    const itemWidth = 80.0;
    final screenWidth = MediaQuery.of(context).size.width - 32; // minus margins
    final targetOffset =
        (widget.activeIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      height: 74,
      decoration: BoxDecoration(
        color: DoctorColors.primaryBrand,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: DoctorColors.primaryBrand.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: ScrollConfiguration(
          behavior: _NoGlowScrollBehavior(),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: _navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final active = index == widget.activeIndex;
                final fallbackIcon = _fallbackIcons[index];
                return GestureDetector(
                  onTap: () => widget.onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.bounceInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    padding: active
                        ? const EdgeInsets.symmetric(horizontal: 14, vertical: 6)
                        : const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (item.iconPath.isNotEmpty)
                          Image.asset(
                            item.iconPath,
                            width: 22,
                            height: 22,
                            color: active ? DoctorColors.primaryBrand : Colors.white,
                          )
                        else if (fallbackIcon != null)
                          Icon(
                            fallbackIcon,
                            size: 22,
                            color: active ? DoctorColors.primaryBrand : Colors.white,
                          ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                            color: active ? DoctorColors.primaryBrand : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Removes the overscroll glow effect
class _NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
