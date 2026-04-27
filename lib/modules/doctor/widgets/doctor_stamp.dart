import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';

class DoctorBadge extends StatefulWidget {
  final String doctor;

  const DoctorBadge({super.key, required this.doctor});

  @override
  State<DoctorBadge> createState() => _DoctorBadgeState();
}

class _DoctorBadgeState extends State<DoctorBadge> {
  // Menu action values
  static const String _basicDetails = 'basic';
  static const String _hospitalList = 'hospital';
  static const String _logout = 'logout';

  void _handleMenuSelection(String value) {
    switch (value) {
      case _basicDetails:
        context.push(AppRoutes.basicDetails);
        break;
      case _hospitalList:
        context.push(AppRoutes.hospitalList);
        break;
      case _logout:
        _confirmLogout();
        break;
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      // TODO: Clear user session / tokens here before navigating
      // context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      offset: const Offset(0, 45),
      onSelected: _handleMenuSelection,
      itemBuilder: (context) => const [
        PopupMenuItem<String>(
          value: _basicDetails,
          child: Row(
            children: [
              Icon(Icons.person_outline, size: 20),
              SizedBox(width: 10),
              Text('Basic Details'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: _hospitalList,
          child: Row(
            children: [
              Icon(Icons.local_hospital_outlined, size: 20),
              SizedBox(width: 10),
              Text('Hospital List'),
            ],
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem<String>(
          value: _logout,
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red, size: 20),
              SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],

      /// 🔹 Custom button UI
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.green2,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                widget.doctor,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}