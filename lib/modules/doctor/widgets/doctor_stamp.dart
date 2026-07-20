import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/doctor_colors.dart';
import '../../../routes/app_routes.dart';

/// Hamburger + profile badge shown in the doctor app bar.
///
/// Tapping it opens a popup menu (Basic Details, Hospital List, Profile,
/// Logout) with a profile-photo header.
class DoctorBadge extends StatelessWidget {
  final String doctor;
  final String? photoUrl;
  final String? subtitle;

  const DoctorBadge({
    super.key,
    required this.doctor,
    this.photoUrl,
    this.subtitle,
  });

  // Menu action values
  static const String _basicDetails = 'basic';
  static const String _doctors = 'doctors';
  static const String _hospitalList = 'hospital';
  static const String _profile = 'profile';
  static const String _notification = 'notification';
  static const String _logout = 'logout';

  /// Initials derived from the doctor's name (strips a leading "Dr").
  String get _initials {
    var name = doctor.trim();
    name = name.replaceFirst(RegExp(r'^Dr\.?\s*', caseSensitive: false), '');
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'Dr';
    if (parts.length == 1) {
      final p = parts.first;
      return (p.length >= 2 ? p.substring(0, 2) : p).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  Widget _avatar(double radius, {double fontSize = 13}) {
    final url = photoUrl;
    final hasPhoto = url != null && url.isNotEmpty;
    return CircleAvatar(
      radius: radius,
      backgroundColor: DoctorColors.primarySoft,
      backgroundImage: hasPhoto ? NetworkImage(url) : null,
      child: hasPhoto
          ? null
          : Text(
              _initials,
              style: TextStyle(
                color: DoctorColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: fontSize,
              ),
            ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case _basicDetails:
        context.push(AppRoutes.basicDetails);
        break;
      case _doctors:
        context.push(AppRoutes.doctorList);
        break;
      case _hospitalList:
        context.push(AppRoutes.hospitalList);
        break;
      case _profile:
        context.push(AppRoutes.doctorProfile);
        break;
      case _notification:
        context.push(AppRoutes.doctorNotifications);
        break;
      case _logout:
        _confirmLogout(context);
        break;

    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    await showDialog<bool>(
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
            onPressed: () {
              Navigator.of(ctx).pop(true);
              context.go(AppRoutes.doctorLogin);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: DoctorColors.error),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _menuItem(
    String value,
    IconData icon,
    String label, {
    Color? color,
  }) {
    final c = color ?? DoctorColors.textPrimary;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? DoctorColors.primary),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: c, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      offset: const Offset(0, 52),
      onSelected: (value) => _handleMenuSelection(context, value),
      itemBuilder: (context) => [
        /// 🔹 Profile header (photo + name)
        PopupMenuItem<String>(
          value: _profile,
          child: Row(
            children: [
              _avatar(22, fontSize: 16),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      doctor,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: DoctorColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle ?? 'View Profile',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: DoctorColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        _menuItem(_basicDetails, Icons.person_outline, 'Basic Details'),
        _menuItem(_doctors, Icons.groups_outlined, 'Doctors'),
        _menuItem(_hospitalList, Icons.local_hospital_outlined, 'Hospital List'),
        _menuItem(_profile, Icons.perm_identity_rounded, 'Profile'),
        _menuItem(_notification, Icons.notifications_none_rounded, 'Notifications'),
        const PopupMenuDivider(),
        _menuItem(_logout, Icons.logout, 'Logout', color: DoctorColors.error),
      ],

      /// 🔹 Hamburger trigger
      child: Container(
        padding: const EdgeInsets.only(top: 18, bottom: 20, right: 12, left: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(
              Icons.menu,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
