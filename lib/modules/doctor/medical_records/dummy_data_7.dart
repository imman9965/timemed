
import 'dart:ui';

import 'package:flutter/material.dart';


// ════════════════════════════════════════════════════════
//  DATA MODELS
// ════════════════════════════════════════════════════════

class Hospital {
  final String id;
  String name;
  String phone;
  String type;

  Hospital({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
  });
}

class HospitalSchedule {
  final String id;
  String hospitalName;
  String fee;
  int intervalMins;
  HospitalSchedule({
    required this.id,
    required this.hospitalName,
    required this.fee,
    required this.intervalMins,
  });
}

class OnlineSchedule {
  final String id;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  Set<String> selectedDays;

  OnlineSchedule({
    required this.id,
    this.fromTime,
    this.toTime,
    Set<String>? selectedDays,
  }) : selectedDays = selectedDays ?? {'all'};

  /// Deep-copy so edits in the dialog don't mutate the original
  /// until the user confirms.
  OnlineSchedule copy() => OnlineSchedule(
    id: id,
    fromTime: fromTime,
    toTime: toTime,
    selectedDays: {...selectedDays},
  );
}

// ════════════════════════════════════════════════════════
//  STATIC DATA
// ════════════════════════════════════════════════════════

final List<Hospital> initialHospitals = [
  Hospital(
      id: 'h1', name: 'Mariapan Clinic',
      phone: '8056567194', type: 'Own'),
  Hospital(
      id: 'h2', name: 'Mariapan Clinic',
      phone: '8056567194', type: 'Own'),
];

final List<HospitalSchedule> initialSchedules = [
  HospitalSchedule(
      id: 's1', hospitalName: 'Sangamithra Hospital',
      fee: '₹550', intervalMins: 9),
  HospitalSchedule(
      id: 's2', hospitalName: 'Sangamithra Hospital',
      fee: '₹550', intervalMins: 9),
];
