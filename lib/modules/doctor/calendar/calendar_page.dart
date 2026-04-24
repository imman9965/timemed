import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../call_logs/call_logs.dart';
import '../missed_call_page/missed_call.dart' hide AppColors;
import '../patient_waiting_list/patient_waiting_list.dart' hide AppColors;
import 'dashboard.dart';


enum AppointmentType { instant, schedule }

class Appointment {
  final String name;
  final String time;
  final AppointmentType type;
  final String badgeLabel;
  final DateTime date;

  const Appointment({
    required this.name,
    required this.time,
    required this.type,
    required this.badgeLabel,
    required this.date,
  });
}

class CalendarRange {
  final int start;
  final int end;
  const CalendarRange(this.start, this.end);
}



final List<Appointment> _allAppointments = [
  Appointment(
    name: 'Andrew Vijay',
    time: '12:20 PM',
    type: AppointmentType.instant,
    badgeLabel: '4th',
    date: DateTime(2026, 5, 4),
  ),
  Appointment(
    name: 'Vijay',
    time: '12:20 PM',
    type: AppointmentType.schedule,
    badgeLabel: '16th',
    date: DateTime(2026, 5, 16),
  ),
  Appointment(
    name: 'Andrew',
    time: '12:20 PM',
    type: AppointmentType.instant,
    badgeLabel: '20th',
    date: DateTime(2026, 5, 20),
  ),
  Appointment(
    name: 'Dr. Kumar',
    time: '10:00 AM',
    type: AppointmentType.schedule,
    badgeLabel: '5th',
    date: DateTime(2026, 5, 5),
  ),
  Appointment(
    name: 'Priya Sharma',
    time: '03:00 PM',
    type: AppointmentType.instant,
    badgeLabel: '18th',
    date: DateTime(2026, 5, 18),
  ),
];

const List<String> _weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];




/// Curved blue header
class CurvedHeader extends StatelessWidget {
  final String title;
  const CurvedHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary1,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        bottom: 18,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

/// Single appointment card
class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  const AppointmentCard({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInstant = appointment.type == AppointmentType.instant;
    final badgeBg   = isInstant ? AppColors.blueBadge    : AppColors.greenBadge;
    final badgeTxt  = isInstant ? AppColors.blueBadgeTxt : AppColors.greenBadgeTxt;
    final typeIcon  = isInstant ? '⚡' : '📅';
    final typeText  = isInstant ? 'Instant' : 'Schedule';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg1,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary1,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.assignment_outlined,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textDark1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(appointment.time,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecond)),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Type: $typeIcon $typeText',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecond),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              appointment.badgeLabel,
              style: TextStyle(
                color: badgeTxt,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Week day label ────────────────────────────────────────
class _WeekDayLabel extends StatelessWidget {
  final String label;
  const _WeekDayLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

// ── Individual day cell ───────────────────────────────────
class _DayCell extends StatelessWidget {
  final int day;
  final bool isInRange;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isToday;
  final bool hasAppointment;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.isInRange,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isToday,
    required this.hasAppointment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSingleDay = isRangeStart && isRangeEnd;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          alignment: Alignment.center,
          children: [
            // ── Range pill background ───────────────────────────
            if (isInRange)
              Positioned(
                top:    h * 0.12,
                bottom: h * 0.12,
                left:   (isRangeStart || isSingleDay) ? w * 0.08 : 0,
                right:  (isRangeEnd   || isSingleDay) ? w * 0.08 : 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.horizontal(
                      left:  (isRangeStart || isSingleDay)
                          ? const Radius.circular(50)
                          : Radius.zero,
                      right: (isRangeEnd || isSingleDay)
                          ? const Radius.circular(50)
                          : Radius.zero,
                    ),
                  ),
                ),
              ),

            // ── Today outline circle ────────────────────────────
            if (isToday && !isInRange)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.todayBorder, width: 1.5),
                ),
              ),

            // ── Day number ──────────────────────────────────────
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                    isInRange ? FontWeight.w700 : FontWeight.w500,
                    color: isInRange
                        ? Colors.white
                        : isToday
                        ? AppColors.primary
                        : AppColors.textDark,
                  ),
                ),
                // Appointment dot indicator
                if (hasAppointment && !isInRange)
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

// ════════════════════════════════════════════════════════
//  INTERACTIVE CALENDAR WIDGET
// ════════════════════════════════════════════════════════

class MonthCalendar extends StatelessWidget {
  final DateTime displayMonth;
  final List<CalendarRange> ranges;
  final List<DateTime> appointmentDates;
  final DateTime today;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final void Function(int day) onDayTap;

  const MonthCalendar({
    Key? key,
    required this.displayMonth,
    required this.ranges,
    required this.appointmentDates,
    required this.today,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onDayTap,
  }) : super(key: key);

  static const _monthNames = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December',
  ];

  String get _monthLabel =>
      '${_monthNames[displayMonth.month - 1]}, ${displayMonth.year}';

  int get _startWeekday =>
      DateTime(displayMonth.year, displayMonth.month, 1).weekday % 7;
  // DateTime.weekday: Mon=1…Sun=7  →  %7 gives Sun=0…Sat=6

  int get _totalDays =>
      DateTime(displayMonth.year, displayMonth.month + 1, 0).day;

  bool _isToday(int day) =>
      today.year  == displayMonth.year  &&
          today.month == displayMonth.month &&
          today.day   == day;

  bool _isRangeStart(int day) => ranges.any((r) => r.start == day);
  bool _isRangeEnd(int day)   => ranges.any((r) => r.end   == day);
  bool _isInRange(int day)    =>
      ranges.any((r) => day >= r.start && day <= r.end);

  bool _hasAppointment(int day) => appointmentDates.any(
        (d) => d.year  == displayMonth.year  &&
        d.month == displayMonth.month &&
        d.day   == day,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Month header with prev/next arrows ──────────────
        Row(
          children: [
            Expanded(
              child: Text(
                _monthLabel,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
            IconButton(
              onPressed: onPrevMonth,
              icon: const Icon(Icons.chevron_left_rounded,
                  color: AppColors.primary, size: 28),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: onNextMonth,
              icon: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.primary, size: 28),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // ── Week day headers ────────────────────────────────
        Row(
          children: _weekDays.map((d) => _WeekDayLabel(label: d)).toList(),
        ),
        const SizedBox(height: 6),

        // ── Day grid ────────────────────────────────────────
        _buildDayGrid(),
      ],
    );
  }

  Widget _buildDayGrid() {
    final cells = <Widget>[];

    // Empty leading offset cells
    for (int i = 0; i < _startWeekday; i++) {
      cells.add(const SizedBox());
    }

    // Day cells
    for (int day = 1; day <= _totalDays; day++) {
      cells.add(_DayCell(
        day:            day,
        isInRange:      _isInRange(day),
        isRangeStart:   _isRangeStart(day),
        isRangeEnd:     _isRangeEnd(day),
        isToday:        _isToday(day),
        hasAppointment: _hasAppointment(day),
        onTap:          () => onDayTap(day),
      ));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.15,
      children: cells,
    );
  }
}

// ════════════════════════════════════════════════════════
//  BOTTOM NAV BAR
// ════════════════════════════════════════════════════════

class NavItem {
  final String iconPath;
  final String label;

  const NavItem({required this.iconPath, required this.label});
}

class CalendarBottomNav extends StatelessWidget {
  final int activeIndex;
  final void Function(int) onTap;

  const CalendarBottomNav({
    Key? key,
    required this.activeIndex,
    required this.onTap,
  }) : super(key: key);

  static const List<NavItem> _navItems = [
    NavItem(iconPath: 'assets/bottom_nav_icon/calendar.png', label: 'Calendar'),
    NavItem(iconPath: 'assets/bottom_nav_icon/person.png', label: 'Profile'),
    NavItem(iconPath: 'assets/bottom_nav_icon/call_logs.png', label: 'Contacts'),
    NavItem(iconPath: 'assets/bottom_nav_icon/call_direct.png', label: 'Verified'),
    NavItem(iconPath: 'assets/bottom_nav_icon/dashboard.png', label: 'Dashboard'),

  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _navItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final active = index == activeIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: active
                    ? Colors.white
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(70),
              ),
              child: Center(
                child: Image.asset(
                  item.iconPath,
                  width: 24,
                  height: 24,
                  color: active?Colors.blue:Colors.white, // Tints the PNG white
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
// ════════════════════════════════════════════════════════
//  PLACEHOLDER SCREENS for other nav tabs
// ════════════════════════════════════════════════════════

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg1,
      body: Column(
        children: [
          CurvedHeader(title: title),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 64, color: AppColors.primary.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecond,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  MAIN SCREEN (StatefulWidget — holds all state)
// ════════════════════════════════════════════════════════

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int      _activeNavIndex = 0;
  DateTime _displayMonth   = DateTime(2026, 5);
  final DateTime _today          = DateTime(2026, 5, 1); // simulated today

  final List<CalendarRange> _ranges = [
    const CalendarRange(4,  6),
    const CalendarRange(16, 18),
    const CalendarRange(20, 21),
  ];

  // Range selection state: null = no selection started
  int? _rangeStartDay;

  // ── Helpers ────────────────────────────────────────────

  List<Appointment> get _visibleAppointments {
    return _allAppointments.where((a) {
      if (a.date.year  != _displayMonth.year)  return false;
      if (a.date.month != _displayMonth.month) return false;
      // If a range is active, only show appointments inside it
      final activeRanges = _ranges;
      if (activeRanges.isEmpty) return true;
      return activeRanges.any(
            (r) => a.date.day >= r.start && a.date.day <= r.end,
      );
    }).toList();
  }

  List<DateTime> get _appointmentDates =>
      _allAppointments.map((a) => a.date).toList();

  void _goToPrevMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
      _ranges.clear();
      _rangeStartDay = null;
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1);
      _ranges.clear();
      _rangeStartDay = null;
    });
  }

  void _onDayTap(int day) {
    setState(() {
      if (_rangeStartDay == null) {
        // First tap → start of range
        _rangeStartDay = day;
        _ranges
          ..clear()
          ..add(CalendarRange(day, day));
      } else {
        // Second tap → end of range
        final start = _rangeStartDay!;
        final end   = day;
        _ranges
          ..clear()
          ..add(CalendarRange(
            start <= end ? start : end,
            start <= end ? end   : start,
          ));
        _rangeStartDay = null; // reset for next selection
      }
    });
  }

  void _onNavTap(int index) {
    setState(() => _activeNavIndex = index);
  }

  // ── Body content per nav tab ───────────────────────────

  Widget _buildBody() {
    switch (_activeNavIndex) {
      case 1:
        return const PatientWaitingListScreen();
      case 2:
        return const CallLogsScreen();
      case 3:
        return const MissedCallPatientListScreen();
      case 4:
        return  DashboardScreen();
      default:
        return _buildCalendarTab();
    }
  }

  Widget _buildCalendarTab() {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const CurvedHeader(title: 'Calender'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: MonthCalendar(
                      displayMonth:    _displayMonth,
                      ranges:          _ranges,
                      appointmentDates: _appointmentDates,
                      today:           _today,
                      onPrevMonth:     _goToPrevMonth,
                      onNextMonth:     _goToNextMonth,
                      onDayTap:        _onDayTap,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Selection hint ───────────────────────
                  if (_rangeStartDay != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text(
                        'Tap another day to complete the range…',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                  // ── Appointment cards ────────────────────
                  if (_visibleAppointments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      child: Center(
                        child: Text(
                          'No appointments in selected range',
                          style: TextStyle(
                            color: AppColors.textSecond.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  else
                    ..._visibleAppointments.map(
                          (appt) => AppointmentCard(appointment: appt),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.only(bottom: 90),
            child: _buildBody(),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CalendarBottomNav(
              activeIndex: _activeNavIndex,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }
}