import 'package:flutter/cupertino.dart';



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

