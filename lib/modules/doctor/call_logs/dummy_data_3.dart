import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



enum AppointmentType { instant, schedule }
enum CallStatus      { success, pending, failed }

class Doctor {
  final String name;
  const Doctor({required this.name});
}

class CallLogTask {
  final String label;
  final bool   completed;
  const CallLogTask({required this.label, required this.completed});
}

class CallLog {
  final String          patientName;
  final String          phone;
  final String          fee;
  final AppointmentType type;
  final CallStatus      status;
  final DateTime        dateTime;
  final String          progressNote;
  final List<CallLogTask> tasks;

  const CallLog({
    required this.patientName,
    required this.phone,
    required this.fee,
    required this.type,
    required this.status,
    required this.dateTime,
    required this.progressNote,
    required this.tasks,
  });
}

class NavItem {
  final IconData icon;
  final bool     isCircle;
  const NavItem({required this.icon, this.isCircle = false});
}

final List<CallLog> allCallLogs = [
  CallLog(
    patientName:  'Mr. Andrew',
    phone:        '805XXXXXX4',
    fee:          '₹550',
    type:         AppointmentType.instant,
    status:       CallStatus.success,
    dateTime:     DateTime(2026, 01, 7, 12, 20),
    progressNote: 'Call pending',
    tasks: const [
      CallLogTask(label: 'PRESCRIPTION',  completed: false),
      CallLogTask(label: 'LAB TEST',      completed: false),
      CallLogTask(label: 'CLINICAL NOTES',completed: false),
    ],
  ),
  CallLog(
    patientName:  'Mr. Andrew',
    phone:        '805XXXXXX4',
    fee:          '₹550',
    type:         AppointmentType.instant,
    status:       CallStatus.pending,
    dateTime:     DateTime(2026, 01, 7, 12, 20),
    progressNote: 'Call pending',
    tasks: const [
      CallLogTask(label: 'PRESCRIPTION',  completed: false),
      CallLogTask(label: 'LAB TEST',      completed: false),
      CallLogTask(label: 'CLINICAL NOTES',completed: false),
    ],
  ),

  // CallLog(
  //   patientName:  'Ms. Priya',
  //   phone:        '901XXXXXX2',
  //   fee:          '₹300',
  //   type:         AppointmentType.schedule,
  //   status:       CallStatus.pending,
  //   dateTime:     DateTime(2026, 1, 7, 14, 0),
  //   progressNote: 'Call scheduled',
  //   tasks: const [
  //     CallLogTask(label: 'PRESCRIPTION',  completed: true),
  //     CallLogTask(label: 'LAB TEST',      completed: false),
  //     CallLogTask(label: 'CLINICAL NOTES',completed: false),
  //   ],
  // ),
  // CallLog(
  //   patientName:  'Mr. Raj Kumar',
  //   phone:        '700XXXXXX9',
  //   fee:          '₹450',
  //   type:         AppointmentType.instant,
  //   status:       CallStatus.failed,
  //   dateTime:     DateTime(2026, 1, 15, 10, 30),
  //   progressNote: 'Call failed – retry',
  //   tasks: const [
  //     CallLogTask(label: 'PRESCRIPTION',  completed: false),
  //     CallLogTask(label: 'LAB TEST',      completed: false),
  //     CallLogTask(label: 'CLINICAL NOTES',completed: false),
  //   ],
  // ),
  // CallLog(
  //   patientName:  'Dr. Sunita',
  //   phone:        '800XXXXXX1',
  //   fee:          '₹700',
  //   type:         AppointmentType.schedule,
  //   status:       CallStatus.success,
  //   dateTime:     DateTime(2026, 02, 3, 9, 0),
  //   progressNote: 'Completed successfully',
  //   tasks: const [
  //     CallLogTask(label: 'PRESCRIPTION',  completed: true),
  //     CallLogTask(label: 'LAB TEST',      completed: true),
  //     CallLogTask(label: 'CLINICAL NOTES',completed: true),
  //   ],
  // ),
];

const List<NavItem> navItems = [
  NavItem(icon: Icons.calendar_month_rounded),
  NavItem(icon: Icons.person_search_rounded),
  NavItem(icon: Icons.contact_phone_rounded, isCircle: true),
  NavItem(icon: Icons.cut_rounded),
  NavItem(icon: Icons.grid_view_rounded),
];


String formatDate(DateTime dt) =>
    '${dt.day}/${dt.month}/${dt.year}';

String formatTime(DateTime dt) {
  final h  = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
  final m  = dt.minute.toString().padLeft(2, '0');
  final ampm = dt.hour >= 12 ? 'PM' : 'AM';
  return '$h:$m $ampm';
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;