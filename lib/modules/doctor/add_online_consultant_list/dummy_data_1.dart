
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ConsultationType { textOnly, videoOnly, both }



const List<ConsultationOption> consultationOptions = [
  ConsultationOption(type: ConsultationType.textOnly,
      label: 'Text Consultation Only'),
  ConsultationOption(type: ConsultationType.videoOnly,
      label: 'Video Consultation Only'),
  ConsultationOption(type: ConsultationType.both,
      label: 'Both Video and Text Consultation'),
];


final List<SummaryItem> summaryItems = [
  SummaryItem(
    icon:  Icons.phone_outlined,
    label: 'Call Mode:',
    valueGetter: (d) => d.callMode,
  ),
  SummaryItem(
    icon:  Icons.medical_services_outlined,
    label: 'Consultation Type:',
    valueGetter: (d) => d.typeLabel,
  ),
  SummaryItem(
    icon:  Icons.hourglass_bottom_outlined,
    label: 'Call Duration:',
    valueGetter: (d) => '${d.callInterval}',
  ),
  SummaryItem(
    icon:  Icons.chat_bubble_outline,
    label: 'Text Fee:',
    valueGetter: (d) => '₹ ${d.textFee}',
  ),
  SummaryItem(
    icon:  Icons.videocam_outlined,
    label: 'Video Fee:',
    valueGetter: (d) => '₹ ${d.videoFee}',
  ),
];


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


final data = ConsultationScheduleData(
  type:         ConsultationType.both,
  textFee:      550,
  videoFee:     550,
  callInterval: 6,
);

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




