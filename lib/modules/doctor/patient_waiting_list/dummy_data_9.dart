import 'package:flutter/material.dart';

enum AppointmentType { instant, schedule }
enum PaymentStatus  { paid, unpaid }
enum WaitingStatus  { waiting, inProgress, done }

class Doctor {
  final String name;
  const Doctor({required this.name});
}

class WaitingPatient {
  final String appointmentId;
  final AppointmentType type;
  final String name;
  final String phone;
  final PaymentStatus paymentStatus;
  final WaitingStatus waitingStatus;
  final String date;
  final String time;

  const WaitingPatient({
    required this.appointmentId,
    required this.type,
    required this.name,
    required this.phone,
    required this.paymentStatus,
    required this.waitingStatus,
    required this.date,
    required this.time,
  });
}

class NavItem {
  final IconData icon;
  final bool hasAvatar;
  const NavItem({required this.icon, this.hasAvatar = false});
}

// ════════════════════════════════════════════════════════
//  STATIC DATA
// ════════════════════════════════════════════════════════


final List<WaitingPatient> onlinePatients = [
  const WaitingPatient(
    appointmentId: '259226',
    type:          AppointmentType.instant,
    name:          'Mr. Andrew',
    phone:         '805XXXXXX4',
    paymentStatus: PaymentStatus.paid,
    waitingStatus: WaitingStatus.waiting,
    date:          '1/7/2026',
    time:          '12:20 PM',
  ),
  // const WaitingPatient(
  //   appointmentId: '259227',
  //   type:          AppointmentType.schedule,
  //   name:          'Ms. Priya',
  //   phone:         '901XXXXXX2',
  //   paymentStatus: PaymentStatus.unpaid,
  //   waitingStatus: WaitingStatus.inProgress,
  //   date:          '1/7/2026',
  //   time:          '01:00 PM',
  // ),
];

final List<WaitingPatient> inPersonPatients = [
  const WaitingPatient(
    appointmentId: '259230',
    type:          AppointmentType.schedule,
    name:          'Mr. Raj Kumar',
    phone:         '700XXXXXX9',
    paymentStatus: PaymentStatus.paid,
    waitingStatus: WaitingStatus.waiting,
    date:          '1/7/2026',
    time:          '02:30 PM',
  ),
];

const List<NavItem> navItems = [
  NavItem(icon: Icons.calendar_month_rounded),
  NavItem(icon: Icons.person_search_rounded, hasAvatar: true),
  NavItem(icon: Icons.contact_phone_rounded),
  NavItem(icon: Icons.cut_rounded),
  NavItem(icon: Icons.grid_view_rounded),
];