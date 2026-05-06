
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesmed_project/routes/app_pages.dart';

import '../../../routes/app_routes.dart';
class MenuItem {
  // final IconData icon;
  final String icon;
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
    icon: "assets/icons/img.png",
    label: 'Lab Test',
    route: AppRoutes.labTest, // ✅ use constant
  ),
  MenuItem(
    icon: "assets/icons/img_1.png",
    label: 'Move to Queue',
    route: AppRoutes.queue,
  ),
  MenuItem(
    icon: "assets/icons/img_10.png",
    label: 'Prescription',
    route: AppRoutes.prescription,
  ),
  MenuItem(
    icon: "assets/icons/img_5.png",
    label: 'History',
    route: AppRoutes.medicalRecordHistory,
  ),
  MenuItem(
    icon: "assets/icons/img_7.png",
    label: 'Notes',
    route: AppRoutes.notes,
  ),
  MenuItem(
    icon: "assets/icons/img_9.png",
    label: 'Medical Records',
    route: AppRoutes.medicalRecords, // ✅ match router
  ),
];

final callControls = [
   CallControl(icon:"assets/icons/img_12.png" ,isRed: false),
   CallControl(icon: "assets/icons/img_13.png", isRed: false),
   CallControl(icon:"assets/icons/img_17.png", isRed: true),
   CallControl(icon: "assets/icons/img_14.png", isRed: false),
   CallControl(icon: "assets/icons/img_15.png", isRed: false),
];

class CallControl {
  final String icon;
  final bool isRed;
   CallControl({required this.icon, required this.isRed});
}


var test = "Iman the greatest";
