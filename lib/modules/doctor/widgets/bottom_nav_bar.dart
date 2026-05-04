import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
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
    NavItem(iconPath: 'assets/bottom_nav_icon/calendar.png', label: 'Calendar'),
    NavItem(iconPath: 'assets/bottom_nav_icon/person.png', label: 'Waiting'),
    NavItem(iconPath: 'assets/bottom_nav_icon/call_logs.png', label: 'Calls'),
    NavItem(iconPath: 'assets/bottom_nav_icon/call_direct.png', label: 'Missed'),
    NavItem(iconPath: 'assets/bottom_nav_icon/dashboard.png', label: 'Dashboard'),
    NavItem(iconPath: '', label: 'Patient List'),
    // NavItem(iconPath: '', label: 'Notes'),
    // NavItem(iconPath: '', label: 'Appts'),
    // NavItem(iconPath: '', label: 'Alerts'),
  ];

  // Icons for items without PNG assets
  static const List<IconData?> _fallbackIcons = [
    null, // Calendar — has PNG
    null, // Waiting — has PNG
    null, // Calls — has PNG
    null, // Missed — has PNG
    null, // Dashboard — has PNG
    Icons.person_add_alt_sharp,       // Prescription
    // Icons.note_alt_rounded,         // Clinical Notes
    // Icons.event_note_rounded,       // Appointments
    // Icons.notifications_rounded,    // Notifications
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
    // Each item is ~68 wide, scroll to center the active one
    const itemWidth = 68.0;
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
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
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
                        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                        : const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon — PNG or fallback Material icon
                        if (item.iconPath.isNotEmpty)
                          Image.asset(
                            item.iconPath,
                            width: 22,
                            height: 22,
                            color: active ? AppColors.primary : Colors.white,
                          )
                        else if (fallbackIcon != null)
                          Icon(
                            fallbackIcon,
                            size:  28,
                            color: active ? AppColors.primary : Colors.white,
                          ),
                        // if (active) ...[
                        //   const SizedBox(width: 8),
                        //   Text(
                        //     item.label,
                        //     style: TextStyle(
                        //       fontSize: 13,
                        //       fontWeight: FontWeight.w700,
                        //       color: AppColors.primary,
                        //     ),
                        //   ),
                        // ],

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
