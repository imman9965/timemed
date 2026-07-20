import 'package:flutter/material.dart';

import '../theme/doctor_theme.dart';

/// Status of a previously requested lab test.
enum LabTestStatus { pending, inProgress, completed }

extension LabTestStatusX on LabTestStatus {
  String get label {
    switch (this) {
      case LabTestStatus.pending:
        return 'Pending';
      case LabTestStatus.inProgress:
        return 'In Progress';
      case LabTestStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case LabTestStatus.pending:
        return DoctorColors.warningPending;
      case LabTestStatus.inProgress:
        return DoctorColors.primary;
      case LabTestStatus.completed:
        return DoctorColors.success;
    }
  }

  IconData get icon {
    switch (this) {
      case LabTestStatus.pending:
        return Icons.schedule;
      case LabTestStatus.inProgress:
        return Icons.autorenew;
      case LabTestStatus.completed:
        return Icons.check_circle;
    }
  }
}

/// A single lab test request record for the patient.
class LabTestRecord {
  final String id;
  final String department;
  final List<String> tests;
  final DateTime requestedOn;
  final bool urgent;
  final LabTestStatus status;
  final String? notes;

  const LabTestRecord({
    required this.id,
    required this.department,
    required this.tests,
    required this.requestedOn,
    required this.status,
    this.urgent = false,
    this.notes,
  });
}

/// Mock lab test records for the current patient.
final List<LabTestRecord> mockLabTestRecords = [
  LabTestRecord(
    id: 'LT-2048',
    department: 'Biochemistry',
    tests: const ['HbA1c', 'Lipid Profile', 'Blood Glucose - Fasting'],
    requestedOn: DateTime(2026, 7, 15, 10, 30),
    status: LabTestStatus.completed,
    notes: 'Routine diabetic follow-up.',
  ),
  LabTestRecord(
    id: 'LT-2039',
    department: 'Hematology',
    tests: const ['HEMOGRAM - 6 PART (DIFF)', 'INR'],
    requestedOn: DateTime(2026, 7, 12, 9, 15),
    status: LabTestStatus.inProgress,
    urgent: true,
    notes: 'Fatigue and bruising reported.',
  ),
  LabTestRecord(
    id: 'LT-2027',
    department: 'Microbiology',
    tests: const ['Urine Culture'],
    requestedOn: DateTime(2026, 7, 8, 16, 45),
    status: LabTestStatus.pending,
  ),
];
