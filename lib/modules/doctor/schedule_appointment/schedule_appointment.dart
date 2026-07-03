import 'package:flutter/material.dart';

import '../../../core/widgets/common/curved_header.dart';


class AppColors {
  static const primary     = Color(0xFF1A6BF5);
  static const scaffoldBg  = Color(0xFFFAF5EC);
  static const cardBg      = Colors.white;
  static const textDark    = Color(0xFF1A1A2E);
  static const textSecond  = Color(0xFF6B7280);
  static const green       = Color(0xFF4CAF50);
  static const orange      = Color(0xFFFFB347);
  static const sunYellow   = Color(0xFFFFC107);
  static const disabledTxt = Color(0xFFB0B0B0);
  static const divider     = Color(0xFFE5E5E5);
  static const redHint     = Color(0xFFE53935);
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
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
      // Cloud with sun peeking from behind
        return SizedBox(
          width: 44, height: 34,
          child: Stack(
            clipBehavior: Clip.none,
            children: const [
              Positioned(
                top: -4, left: 14,
                child: Icon(Icons.wb_sunny_rounded,
                    color: AppColors.sunYellow, size: 22),
              ),
              Positioned(
                bottom: 0, left: 0,
                child: Icon(Icons.cloud_rounded,
                    color: AppColors.primary, size: 30),
              ),
            ],
          ),
        );
      case SessionType.afternoon:
        return const Icon(Icons.wb_sunny_rounded,
            color: AppColors.sunYellow, size: 32);
      case SessionType.evening:
      // Sun resting on horizon line
        return SizedBox(
          width: 44, height: 34,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wb_sunny_rounded,
                  color: AppColors.sunYellow, size: 22),
              const SizedBox(height: 2),
              Container(
                width: 30, height: 2,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        );
      case SessionType.night:
      // Cloud with crescent moon + star
        return SizedBox(
          width: 44, height: 34,
          child: Stack(
            clipBehavior: Clip.none,
            children: const [
              Positioned(
                bottom: 0, left: 2,
                child: Icon(Icons.cloud_rounded,
                    color: AppColors.primary, size: 30),
              ),
              Positioned(
                top: -4, right: 0,
                child: Icon(Icons.nightlight_round,
                    color: AppColors.primary, size: 16),
              ),
              Positioned(
                top: -2, right: 14,
                child: Icon(Icons.star_rounded,
                    color: AppColors.sunYellow, size: 12),
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

  static const Color _headerBg     = Color(0xFFEAF2FE); // soft blue tint
  static const Color _columnBorder = Color(0xFFE5EAF1);

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
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _columnBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            children: [
              // Blue header area: icon + label
              Container(
                width: double.infinity,
                color: _headerBg,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Center(child: SessionIcon(type: column.type)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      column.label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Slots
              ...column.slots.map((slot) {
                final isSelected = selectedSlot == slot.time;
                final isDisabled = !slot.available;
                return _SlotTile(
                  time: slot.time,
                  isSelected: isSelected,
                  isDisabled: isDisabled,
                  onTap: isDisabled ? null : () => onSlotTap(slot.time),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  const _SlotTile({
    required this.time,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 1),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),

          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.30),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ]
              : null,
        ),
        child: Text(
          time,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? Colors.white
                : isDisabled
                ? AppColors.disabledTxt
                : AppColors.primary,
            decoration: isDisabled
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            decorationColor: AppColors.disabledTxt,
            decorationThickness: 1.4,
          ),
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
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecond,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 26,
                      height: 2.5,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                      ),
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
  const ScheduleAppointmentScreen({super.key});

  @override
  State<ScheduleAppointmentScreen> createState() =>
      _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState extends State<ScheduleAppointmentScreen>
    with SingleTickerProviderStateMixin {

// class _ScheduleAppointmentScreenState
//     extends State<ScheduleAppointmentScreen> {
  // ── Blue & white palette ──────────────────────────────────────────────
  static const Color _blue = Color(0xFF1A6BF5);
  static const Color _blueSoft = Color(0xFFE8F1FC);
  static const Color _inactiveText = Color(0xFF6B7280);
  static const Color _strikeGray = Color(0xFFB0B0B0);
  static const Color _cardBorder = Color(0xFFE5EAF2);
  static const Color _scaffoldBg = Colors.white;

  static const List<String> _tabs = <String>[
    'FREE REVIEW',
    'PAID RE-VISIT',
    'COMPLETE CONSULTATION',
  ];

  static const List<String> _days = <String>[
    'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
  ];

  static const List<String> _months = <String>[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  late final TabController _tabController;
  late DateTime _currentDate;
  int _selectedDay = 1; // Mon
  String _selectedSlot = '04:15 PM';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: 2,
    );
    // Initialize with Feb 16, 2026 (Monday)
    _currentDate = DateTime(2026, 2, 16);
    _updateSelectedDayFromDate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── Date navigation helpers ──────────────────────────────────────────
  void _goPreviousDay() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 1));
      _updateSelectedDayFromDate();
    });
  }

  void _goNextDay() {
    setState(() {
      _currentDate = _currentDate.add(const Duration(days: 1));
      _updateSelectedDayFromDate();
    });
  }

  void _updateSelectedDayFromDate() {
    // DateTime.weekday: Monday = 1 ... Sunday = 7
    final int weekday = _currentDate.weekday;
    // Map to _days index: Sun(7) -> 0, Mon(1) -> 1, Tue(2) -> 2, ... Sat(6) -> 6
    _selectedDay = weekday == 7 ? 0 : weekday;
  }

  String _getFormattedDate(DateTime date) {
    return '${_months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _selectDayByIndex(int dayIndex) {
    // Map dayIndex (0=Sun .. 6=Sat) to DateTime weekday (1=Mon .. 7=Sun)
    int targetWeekday;
    if (dayIndex == 0) {
      targetWeekday = 7; // Sunday
    } else {
      targetWeekday = dayIndex; // Mon=1, Tue=2, ..., Sat=6
    }

    final int currentWeekday = _currentDate.weekday;
    int delta = targetWeekday - currentWeekday;

    setState(() {
      _currentDate = _currentDate.add(Duration(days: delta));
      _updateSelectedDayFromDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          CurvedHeader(
            title: "SCHEDULE APPOINTMENT",
            titleStyle: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
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

                  _buildSlotTab(),

                  // ── Week calendar card ──────────────────

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

  Widget _buildSlotTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          _buildDateRow(),
          _buildDayPicker(),
          _buildSlotGrid(),
        ],
      ),
    );
  }

  Widget _buildDateRow() {
    return Row(
      children: [
        _arrowBtn(Icons.chevron_left, onTap: _goPreviousDay),
        Expanded(
          child: Center(
            child: Text(
              _getFormattedDate(_currentDate),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
        ),
        _arrowBtn(Icons.chevron_right, onTap: _goNextDay),
      ],
    );
  }

  Widget _arrowBtn(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: _blue, size: 26),
      ),
    );
  }

  Widget _buildDayPicker() {
    return Row(
      children: List.generate(_days.length, (i) {
        final bool selected = i == _selectedDay;
        return Expanded(
          child: InkWell(
            onTap: () => _selectDayByIndex(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  Text(
                    _days[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: selected ? _blue : _inactiveText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 2,
                    width: selected ? 28 : 0,
                    decoration: BoxDecoration(
                      color: _blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // ─── 4-column slot grid ───────────────────────────────────────────────
  Widget _buildSlotGrid() {
    final columns = <_SlotColumn>[
      _SlotColumn(
        title: 'Morning',
        icon: "assets/icons/Morning.png",
        slots: const [
          _Slot('09:00 AM', taken: true),
          _Slot('09:15 AM', taken: true),
          _Slot('09:30 AM', taken: true),
          _Slot('09:45 AM', taken: true),
          _Slot('10:00 AM', taken: true),
          _Slot('10:15 AM', taken: true),
          _Slot('10:30 AM', taken: true),
        ],
      ),
      _SlotColumn(
        title: 'Afternoon',
        icon: "assets/icons/afternoon.png",
        slots: const [
          _Slot('12:00 PM', taken: true),
          _Slot('12:15 PM', taken: true),
          _Slot('12:30 PM', taken: true),
          _Slot('12:45 PM', taken: true),
          _Slot('01:00 PM', taken: true),
          _Slot('01:15 PM', taken: true),
          _Slot('01:30 PM', taken: true),
        ],
      ),
      _SlotColumn(
        title: 'Evening',
        icon: "assets/icons/sun_fog.png",
        slots: const [
          _Slot('04:00 PM', taken: true),
          _Slot('04:15 PM'),
          _Slot('04:30 PM'),
          _Slot('04:45 PM'),
          _Slot('05:00 PM', taken: true),
          _Slot('05:15 PM'),
          _Slot('05:30 PM'),
        ],
      ),
      _SlotColumn(
        title: 'Night',
        icon: "assets/icons/night_cloud.png",
        slots: const [
          _Slot('08:00 PM', taken: true),
          _Slot('08:15 PM', taken: true),
          _Slot('08:30 PM'),
          _Slot('08:45 PM'),
          _Slot('09:00 PM', taken: true),
          _Slot('09:15 PM'),
          _Slot('09:30 PM'),
        ],
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns
          .map((c) => Expanded(child: _buildSlotColumn(c)))
          .toList(),
    );
  }

  Widget _buildSlotColumn(_SlotColumn col) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: _blueSoft,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  col.icon,
                  width: 32,
                  height: 32,
                ),
                const SizedBox(height: 4),
                Text(
                  col.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _blue,
                  ),
                ),
              ],
            ),
          ),
          // Slots
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: col.slots.map(_buildSlot).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlot(_Slot slot) {
    final bool isSelected = _selectedSlot == slot.time && !slot.taken;

    if (slot.taken) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          slot.time,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _strikeGray,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => setState(() => _selectedSlot = slot.time),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? _blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            slot.time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : _blue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _blue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Click to Complete',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

}

class _SlotColumn {
  final String title;
  final String icon;
  final List<_Slot> slots;
  const _SlotColumn({
    required this.title,
    required this.icon,
    required this.slots,
  });
}

class _Slot {
  final String time;
  final bool taken;
  const _Slot(this.time, {this.taken = false});
}