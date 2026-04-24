
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ConsultationType { textOnly, videoOnly, both }

class ConsultationOption {
  final ConsultationType type;
  final String label;
  const ConsultationOption({required this.type, required this.label});
}

class SummaryItem {
  final IconData icon;
  final String   label;
  final String   Function(ConsultationScheduleData) valueGetter;
  const SummaryItem({
    required this.icon,
    required this.label,
    required this.valueGetter,
  });
}

class ConsultationScheduleData {
  ConsultationType type;
  int              textFee;
  int              videoFee;
  int              callInterval;

  ConsultationScheduleData({
    required this.type,
    required this.textFee,
    required this.videoFee,
    required this.callInterval,
  });

  String get typeLabel {
    switch (type) {
      case ConsultationType.textOnly:  return 'Text Consultation Only';
      case ConsultationType.videoOnly: return 'Video Consultation Only';
      case ConsultationType.both:      return 'Both Video and Text Consultation';
    }
  }

  String get callMode =>
      type == ConsultationType.both
          ? 'Both Instant and Schedule'
          : 'Instant';
}

// ════════════════════════════════════════════════════════
//  STATIC DATA
// ════════════════════════════════════════════════════════




