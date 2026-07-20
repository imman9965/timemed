
import 'dart:ui';

import 'package:flutter/material.dart';

import '../add_online_consultant_list/dummy_data_1.dart';


// ════════════════════════════════════════════════════════
//  DATA MODELS
// ════════════════════════════════════════════════════════

class Hospital {
  final String id;
  String name;
  String phone;
  // Ownership — only meaningful for clinics ('Own' / 'Partner'); '' for hospitals.
  String type;
  // Facility category: 'Clinic' or 'Hospital'.
  String category;
  String address;

  Hospital({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
    this.category = 'Clinic',
    this.address = '',
  });

  bool get isClinic => category == 'Clinic';
}

class HospitalSchedule {
  final String id;
  String hospitalName;
  String fee;
  int intervalMins;
  // Clinical (in-person) visit availability.
  Set<String> visitDays;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  HospitalSchedule({
    required this.id,
    required this.hospitalName,
    required this.fee,
    required this.intervalMins,
    Set<String>? visitDays,
    this.fromTime,
    this.toTime,
  }) : visitDays = visitDays ?? {'all'};
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

// Consultation details per online schedule (keyed by online-schedule id).
// Kept here (shared) so details survive navigation, like the lists above.
final Map<String, ConsultationScheduleData> initialConsultationData = {};
