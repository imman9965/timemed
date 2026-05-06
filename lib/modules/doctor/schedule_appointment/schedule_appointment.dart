import 'package:flutter/material.dart';

import '../../../core/widgets/common/curved_header.dart';
import '../theme/doctor_colors.dart';


class AppColors {
  static const primary     = DoctorColors.primaryVivid;
  static const scaffoldBg  = DoctorColors.backgroundCream;
  static const cardBg      = DoctorColors.cardWhite;
  static const textDark    = DoctorColors.textDark;
  static const textSecond  = DoctorColors.textSecondary;
  static const green       = DoctorColors.success;
  static const orange      = DoctorColors.warningOrange;
  static const sunYellow   = DoctorColors.warningAmber;
  static const disabledTxt = DoctorColors.textDisabled;
  static const divider     = DoctorColors.divider;
  static const redHint     = DoctorColors.error;
}



enum SessionType { morning, afternoon, evening, night }

class SchedulePatient {
  final String name;
  final String patientId;
  final String date;
  final String time;

  const SchedulePatient({
    required this.name,
    required this.patientId,
    required this.date,
    required this.time,
  });
}

class DoctorInfo {
  final String name;
  final String qualification;
  final String specialty;
  final int    experience;

  const DoctorInfo({
    required this.name,
    required this.qualification,
    required this.specialty,
    required this.experience,
  });
}

class TimeSlot {
  final String time;
  final bool   available;

  const TimeSlot({
    required this.time,
    required this.available,
  });
}

class SessionColumn {
  final SessionType    type;
  final String         label;
  final List<TimeSlot> slots;

  const SessionColumn({
    required this.type,
    required this.label,
    required this.slots,
  });
}

// ════════════════════════════════════════════════════════
//  STATIC DATA
// ════════════════════════════════════════════════════════

const _schedulePatient = SchedulePatient(
  name:      'Andrew Vijay',
  patientId: '10',
  date:      '1/7/2026',
  time:      '12:20 PM',
);

const _doctorInfo = DoctorInfo(
  name:          'Dr.Mariappan',
  qualification: 'MBBS, MD',
  specialty:     'Pulmonolgy',
  experience:    10,
);

const List<String> _weekDays = [
  'Sun','Mon','Tue','Wed','Thu','Fri','Sat'
];

final List<SessionColumn> _sessionColumns = [
  const SessionColumn(
    type:  SessionType.morning,
    label: 'Morning',
    slots: [
      TimeSlot(time: '09:00 AM', available: false),
      TimeSlot(time: '09:15 AM', available: false),
      TimeSlot(time: '09:30 AM', available: false),
      TimeSlot(time: '09:45 AM', available: false),
      TimeSlot(time: '10:00 AM', available: false),
      TimeSlot(time: '10:15 AM', available: false),
      TimeSlot(time: '10:30 AM', available: false),
    ],
  ),
  const SessionColumn(
    type:  SessionType.afternoon,
    label: 'Afternoon',
    slots: [
      TimeSlot(time: '12:00 PM', available: false),
      TimeSlot(time: '12:15 PM', available: false),
      TimeSlot(time: '12:30 PM', available: false),
      TimeSlot(time: '12:45 PM', available: false),
      TimeSlot(time: '01:00 PM', available: false),
      TimeSlot(time: '01:15 PM', available: false),
      TimeSlot(time: '01:30 PM', available: false),
    ],
  ),
  const SessionColumn(
    type:  SessionType.evening,
    label: 'Evening',
    slots: [
      TimeSlot(time: '04:00 PM', available: false),
      TimeSlot(time: '04:15 PM', available: true),
      TimeSlot(time: '04:30 PM', available: true),
      TimeSlot(time: '04:45 PM', available: true),
      TimeSlot(time: '05:00 PM', available: false),
      TimeSlot(time: '05:15 PM', available: true),
      TimeSlot(time: '05:30 PM', available: true),
    ],
  ),
  const SessionColumn(
    type:  SessionType.night,
    label: 'Night',
    slots: [
      TimeSlot(time: '08:00 PM', available: false),
      TimeSlot(time: '08:15 PM', available: false),
      TimeSlot(time: '08:30 PM', available: true),
      TimeSlot(time: '08:45 PM', available: true),
      TimeSlot(time: '09:00 PM', available: false),
      TimeSlot(time: '09:15 PM', available: true),
      TimeSlot(time: '09:30 PM', available: true),
    ],
  ),
];

// ════════════════════════════════════════════════════════
//  REUSABLE — CURVED HEADER
// ════════════════════════════════════════════════════════

// class CurvedHeader extends StatelessWidget {
//   final String title;
//   const CurvedHeader({Key? key, required this.title}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         color: AppColors.primary,
//         borderRadius: BorderRadius.only(
//           bottomLeft:  Radius.circular(32),
//           bottomRight: Radius.circular(32),
//         ),
//       ),
//       padding: EdgeInsets.only(
//         top:    MediaQuery.of(context).padding.top + 18,
//         bottom: 24,
//       ),
//       child: Text(
//         title,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w800,
//           fontSize: 24,
//         ),
//       ),
//     );
//   }
// }

// ════════════════════════════════════════════════════════
//  REUSABLE — HELPDESK BUTTON
// ════════════════════════════════════════════════════════

class HelpdeskButton extends StatelessWidget {
  final VoidCallback onTap;
  const HelpdeskButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.green,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.green.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Text(
          'Helpdesk Request',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  REUSABLE — PATIENT INFO CARD
// ════════════════════════════════════════════════════════

class PatientInfoCard extends StatelessWidget {
  final SchedulePatient patient;
  const PatientInfoCard({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 28, height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFE0E0E0),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              patient.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.textDark,
              ),
            ),
          ]),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 38),
            child: Row(
              children: [
                const Text(
                  'Patient ID: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecond,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  patient.patientId,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.green,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Row(children: [
                  const Icon(Icons.calendar_month, size: 18,
                      color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(patient.date,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ]),
              ),
              Expanded(
                child: Row(children: [
                  const Icon(Icons.access_time, size: 18,
                      color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(patient.time,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  REUSABLE — SESSION ICON
// ════════════════════════════════════════════════════════

class SessionIcon extends StatelessWidget {
  final SessionType type;
  const SessionIcon({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SessionType.morning:
      // Cloud with sun behind
        return SizedBox(
          width: 42, height: 32,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -2, left: 12,
                child: Icon(Icons.wb_sunny, color: AppColors.sunYellow, size: 22),
              ),
              const Positioned(
                bottom: 0, left: 0,
                child: Icon(Icons.cloud, color: AppColors.primary, size: 28),
              ),
            ],
          ),
        );
      case SessionType.afternoon:
        return const Icon(Icons.wb_sunny, color: AppColors.sunYellow, size: 30);
      case SessionType.evening:
      // Sun setting with horizon line
        return SizedBox(
          width: 42, height: 32,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wb_sunny, color: AppColors.orange, size: 22),
              Container(
                width: 32, height: 2,
                color: AppColors.orange,
              ),
            ],
          ),
        );
      case SessionType.night:
      // Moon with star
        return SizedBox(
          width: 42, height: 32,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Positioned(
                bottom: 0, left: 0,
                child: Icon(Icons.nightlight_round,
                    color: AppColors.primary, size: 28),
              ),
              Positioned(
                top: -2, right: 2,
                child: Icon(Icons.star, color: AppColors.sunYellow, size: 14),
              ),
            ],
          ),
        );
    }
  }
}

// ════════════════════════════════════════════════════════
//  REUSABLE — SESSION COLUMN (time slot list)
// ════════════════════════════════════════════════════════

class SessionColumnWidget extends StatelessWidget {
  final SessionColumn column;
  final String? selectedSlot;
  final void Function(String) onSlotTap;

  const SessionColumnWidget({
    Key? key,
    required this.column,
    required this.selectedSlot,
    required this.onSlotTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            SessionIcon(type: column.type),
            const SizedBox(height: 4),
            Text(
              column.label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),

            // Slots — iterated
            ...column.slots.map((slot) {
              final isSelected = selectedSlot == slot.time;
              final isDisabled = !slot.available;

              return GestureDetector(
                onTap: isDisabled ? null : () => onSlotTap(slot.time),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 3),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.green : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    slot.time,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : isDisabled
                          ? AppColors.disabledTxt
                          : AppColors.green,
                      decoration: isDisabled
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: AppColors.disabledTxt,
                      decorationThickness: 1.5,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  REUSABLE — WEEK CALENDAR PICKER
// ════════════════════════════════════════════════════════

class WeekCalendarCard extends StatelessWidget {
  final String            monthLabel;
  final int               selectedDayIndex;
  final String?           selectedSlot;
  final VoidCallback      onPrevWeek;
  final VoidCallback      onNextWeek;
  final void Function(int)    onDayTap;
  final void Function(String) onSlotTap;

  const WeekCalendarCard({
    Key? key,
    required this.monthLabel,
    required this.selectedDayIndex,
    required this.selectedSlot,
    required this.onPrevWeek,
    required this.onNextWeek,
    required this.onDayTap,
    required this.onSlotTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Month nav ──────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onPrevWeek,
                child: const Icon(Icons.chevron_left,
                    color: AppColors.primary, size: 26),
              ),
              Text(
                monthLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.textDark,
                ),
              ),
              GestureDetector(
                onTap: onNextWeek,
                child: const Icon(Icons.chevron_right,
                    color: AppColors.primary, size: 26),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Weekday row ────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekDays.asMap().entries.map((entry) {
              final isSelected = entry.key == selectedDayIndex;
              return GestureDetector(
                onTap: () => onDayTap(entry.key),
                child: Column(
                  children: [
                    Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppColors.green
                            : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: 24,
                      height: 2,
                      color: isSelected
                          ? AppColors.green
                          : Colors.transparent,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // ── Session columns — iterated ─────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _sessionColumns
                .map((col) => SessionColumnWidget(
              column:       col,
              selectedSlot: selectedSlot,
              onSlotTap:    onSlotTap,
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  REUSABLE — DOCTOR INFO ROW
// ════════════════════════════════════════════════════════

class DoctorInfoRow extends StatelessWidget {
  final DoctorInfo doctor;
  const DoctorInfoRow({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Doctor details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 16,
                    color: AppColors.textDark),
              ),
              const SizedBox(height: 2),
              Text(
                doctor.qualification,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecond),
              ),
              Text(
                doctor.specialty,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecond),
              ),
            ],
          ),
        ),

        // Experience badge — orange pill with avatar
        Container(
          padding: const EdgeInsets.only(right: 14),
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar circle in dark
              Container(
                width: 40, height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A2E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              Text(
                '${doctor.experience} Years experience',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════
//  MAIN SCREEN
// ════════════════════════════════════════════════════════

class ScheduleAppointmentScreen extends StatefulWidget {
  const ScheduleAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleAppointmentScreen> createState() =>
      _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState
    extends State<ScheduleAppointmentScreen> {

  DateTime _weekStart       = DateTime(2026, 2, 15); // Sun Feb 15 2026
  int      _selectedDayIdx  = 1;                     // Mon
  String?  _selectedSlot    = '04:15 PM';           // from image

  static const _monthNames = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'
  ];

  String _formatMonthLabel() {
    final day = _weekStart.add(Duration(days: _selectedDayIdx));
    return '${_monthNames[day.month - 1]} ${day.day}, ${day.year}';
  }

  void _prevWeek() => setState(() =>
  _weekStart = _weekStart.subtract(const Duration(days: 7)));

  void _nextWeek() => setState(() =>
  _weekStart = _weekStart.add(const Duration(days: 7)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const CurvedHeader(title: 'Schedule Appointment'),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Helpdesk button ─────────────────────
                  Center(
                    child: HelpdeskButton(
                      onTap: () => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content: Text('Helpdesk Request sent'),
                        duration: Duration(seconds: 1),
                      )),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Patient info card ───────────────────
                  const PatientInfoCard(patient: _schedulePatient),
                  const SizedBox(height: 10),

                  // ── Reschedule hint ─────────────────────
                  const Center(
                    child: Text(
                      'Please choose a slot to reschedule appointment....',
                      style: TextStyle(
                        color: AppColors.redHint,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Week calendar card ──────────────────
                  WeekCalendarCard(
                    monthLabel:       _formatMonthLabel(),
                    selectedDayIndex: _selectedDayIdx,
                    selectedSlot:     _selectedSlot,
                    onPrevWeek:       _prevWeek,
                    onNextWeek:       _nextWeek,
                    onDayTap: (idx) => setState(() {
                      _selectedDayIdx = idx;
                      _selectedSlot = null;
                    }),
                    onSlotTap: (slot) =>
                        setState(() => _selectedSlot = slot),
                  ),
                  const SizedBox(height: 20),

                  // ── Doctor info ─────────────────────────
                  const DoctorInfoRow(doctor: _doctorInfo),

                  // ── Confirm button (shows only when slot picked) ──
                  if (_selectedSlot != null) ...[
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                        content: Text(
                            'Appointment confirmed for $_selectedSlot'),
                        backgroundColor: AppColors.green,
                        duration: const Duration(seconds: 2),
                      )),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Confirm Appointment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}