
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesmed_project/routes/app_pages.dart';

import '../../../routes/app_routes.dart';
class MenuItem {
  final IconData icon;
  final String label;
  final String route;

  MenuItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

final menuItems = [
  MenuItem(
    icon: Icons.biotech_outlined,
    label: 'Lab Test',
    route: AppRoutes.labTest, // ✅ use constant
  ),
  MenuItem(
    icon: Icons.groups_outlined,
    label: 'Move to Queue',
    route: AppRoutes.queue,
  ),
  MenuItem(
    icon: Icons.assignment_outlined,
    label: 'Prescription',
    route: AppRoutes.prescription,
  ),
  MenuItem(
    icon: Icons.history_outlined,
    label: 'History',
    route: AppRoutes.history,
  ),
  MenuItem(
    icon: Icons.note_add_outlined,
    label: 'Notes',
    route: AppRoutes.notes,
  ),
  MenuItem(
    icon: Icons.folder_shared_outlined,
    label: 'Medical Records',
    route: AppRoutes.medicalRecords, // ✅ match router
  ),
];

final callControls = [
  CallControl(icon: Icons.flip_camera_ios_outlined, isRed: false),
   CallControl(icon: Icons.videocam_outlined, isRed: false),
   CallControl(icon: Icons.call_end_rounded, isRed: true),
   CallControl(icon: Icons.mic_outlined, isRed: false),
   CallControl(icon: Icons.volume_up_outlined, isRed: false),
];

class CallControl {
  final IconData icon;
  final bool isRed;
   CallControl({required this.icon, required this.isRed});
}


var test = "Iman the greatest";
