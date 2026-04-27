import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../calendar/calendar_page.dart';

class CalendarBottomNav extends StatelessWidget {
  final int activeIndex;
  final void Function(int) onTap;

  const CalendarBottomNav({
    Key? key,
    required this.activeIndex,
    required this.onTap,
  }) : super(key: key);

  static const List<NavItem> _navItems = [
    NavItem(iconPath: 'assets/bottom_nav_icon/calendar.png', label: 'Calendar'),
    NavItem(iconPath: 'assets/bottom_nav_icon/person.png', label: 'Profile'),
    NavItem(iconPath: 'assets/bottom_nav_icon/call_logs.png', label: 'Contacts'),
    NavItem(iconPath: 'assets/bottom_nav_icon/call_direct.png', label: 'Verified'),
    NavItem(iconPath: 'assets/bottom_nav_icon/dashboard.png', label: 'Dashboard'),

  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _navItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final active = index == activeIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: active
                    ? Colors.white
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(70),
              ),
              child: Center(
                child: Image.asset(
                  item.iconPath,
                  width: 24,
                  height: 24,
                  color: active?Colors.blue:Colors.white, // Tints the PNG white
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
