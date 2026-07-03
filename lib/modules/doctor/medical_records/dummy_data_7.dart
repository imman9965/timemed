
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
  String? hospitalId;
  String? hospitalName;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  Set<String> selectedDays;

  OnlineSchedule({
    required this.id,
    this.hospitalId,
    this.hospitalName,
    this.fromTime,
    this.toTime,
    Set<String>? selectedDays,
  }) : selectedDays = selectedDays ?? {'all'};

  /// Deep-copy so edits in the dialog don't mutate the original
  /// until the user confirms.
  OnlineSchedule copy() => OnlineSchedule(
    id: id,
    hospitalId: hospitalId,
    hospitalName: hospitalName,
    fromTime: fromTime,
    toTime: toTime,
    selectedDays: {...selectedDays},
  );
}

// ════════════════════════════════════════════════════════
//  STATIC DATA
// ════════════════════════════════════════════════════════

// Screen starts empty — data is added by the user via the Add New form
final List<Hospital> initialHospitals = [];

final List<HospitalSchedule> initialSchedules = [];

final List<OnlineSchedule> initialOnlineSchedules = [];
