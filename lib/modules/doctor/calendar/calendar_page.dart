import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/doctor_theme.dart';
import '../../../core/widgets/common/curved_header.dart';
import '../../../routes/app_routes.dart';
import '../notifications/notification_controller.dart';
import 'package:go_router/go_router.dart';
import 'dummy_data_2.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  const AppointmentCard({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInstant = appointment.type == AppointmentType.instant;
    final badgeBg   = isInstant ? DoctorColors.badgeBlue    : DoctorColors.badgeGreen;
    final badgeTxt  = isInstant ? DoctorColors.badgeBlueText : DoctorColors.badgeGreenText;
    final typeIcon  = isInstant ? '⚡' : '📅';
    final typeText  = isInstant ? 'Instant' : 'Schedule';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: DoctorColors.cardWhite,
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
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: DoctorColors.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              appointment.gender == 'female'
                  ? 'assets/icons/gender/female.png'
                  : 'assets/icons/gender/male.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date shown above the name — only for Schedule type
                if (!isInstant) ...[
                  Text(
                    '${appointment.date.day.toString().padLeft(2, '0')}/'
                    '${appointment.date.month.toString().padLeft(2, '0')}/'
                    '${appointment.date.year}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: DoctorColors.primaryBrand,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  appointment.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: DoctorColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 13, color: DoctorColors.primaryBrand),
                    const SizedBox(width: 4),
                    Text(appointment.time,
                        style: const TextStyle(
                            fontSize: 12, color: DoctorColors.textSecondary)),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Type: $typeIcon $typeText',
                        style: const TextStyle(
                            fontSize: 12, color: DoctorColors.textSecondary),
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
          color: DoctorColors.textDark,
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
                    color: DoctorColors.primaryBrand,
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
                      color: DoctorColors.primaryVivid, width: 1.5),
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
                        ? DoctorColors.primaryBrand
                        : DoctorColors.textDark,
                  ),
                ),
                // Appointment dot indicator
                if (hasAppointment && !isInRange)
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: const BoxDecoration(
                      color: DoctorColors.primaryBrand,
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
                  color: DoctorColors.primaryBrand,
                ),
              ),
            ),
            IconButton(
              onPressed: onPrevMonth,
              icon: const Icon(Icons.chevron_left_rounded,
                  color: DoctorColors.primaryBrand, size: 28),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: onNextMonth,
              icon: const Icon(Icons.chevron_right_rounded,
                  color: DoctorColors.primaryBrand, size: 28),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // ── Week day headers ────────────────────────────────
        Row(
          children: weekDays.map((d) => _WeekDayLabel(label: d)).toList(),
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

// ════════════════════════════════════════════════════════
//  MAIN CALENDAR SCREEN
// ════════════════════════════════════════════════════════

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _displayMonth   = DateTime(2026, 5);
  final DateTime _today    = DateTime(2026, 5, 1); // simulated today

  final List<CalendarRange> _ranges = [
    const CalendarRange(4,  6),
    const CalendarRange(16, 18),
    const CalendarRange(20, 21),
  ];

  int? _rangeStartDay;

  List<Appointment> get _visibleAppointments {
    return allAppointments.where((a) {
      // Only Schedule appointments are listed — no Instant
      if (a.type != AppointmentType.schedule) return false;
      if (a.date.year  != _displayMonth.year)  return false;
      if (a.date.month != _displayMonth.month) return false;
      final activeRanges = _ranges;
      if (activeRanges.isEmpty) return true;
      return activeRanges.any(
            (r) => a.date.day >= r.start && a.date.day <= r.end,
      );
    }).toList();
  }

  List<DateTime> get _appointmentDates => allAppointments
      .where((a) => a.type == AppointmentType.schedule)
      .map((a) => a.date)
      .toList();

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
        _rangeStartDay = day;
        _ranges
          ..clear()
          ..add(CalendarRange(day, day));
      } else {
        final start = _rangeStartDay!;
        final end   = day;
        _ranges
          ..clear()
          ..add(CalendarRange(
            start <= end ? start : end,
            start <= end ? end   : start,
          ));
        _rangeStartDay = null;
      }
    });
  }

  /// Bell tap = simulate a new local notification.
  /// Fires a real system-tray notification (visible even if the app is
  /// closed), bumps the badge count, appends to the history, then shows the
  /// in-app banner which can be tapped to open the full history screen.
  void _onBellTap(BuildContext context) {
    NotificationController.to.simulateNotification();
    _showNotificationPopup(context);
  }

  void _showNotificationPopup(BuildContext context) {
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (ctx) => _NotificationPopup(
        onTap: () {
          overlayEntry.remove();
          context.push(AppRoutes.doctorNotifications);
        },
        onDismiss: () {
          overlayEntry.remove();
        },
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    // Auto-dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DoctorColors.backgroundWarm,
      body: Column(
        children: [
          Obx(
            () => CurvedHeader(
              title: 'CALENDER',
              showBackButton: false,
              showNotification: true,
              badgeCount: NotificationController.to.queue.length,
              onNotificationTap: () => _onBellTap(context),
              titleStyle: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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

                  if (_rangeStartDay != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text(
                        'Tap another day to complete the range…',
                        style: TextStyle(
                          fontSize: 12,
                          color: DoctorColors.primaryBrand.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                  if (_visibleAppointments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      child: Center(
                        child: Text(
                          'No appointments in selected range',
                          style: TextStyle(
                            color: DoctorColors.textSecondary.withOpacity(0.7),
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
}

// ════════════════════════════════════════════════════════
//  IN-APP NOTIFICATION POPUP OVERLAY
// ════════════════════════════════════════════════════════

class _NotificationPopup extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationPopup({
    required this.onTap,
    required this.onDismiss,
  });

  @override
  State<_NotificationPopup> createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<_NotificationPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4FC3F7).withOpacity(0.30),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.call_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'INSTANT CALL REQUEST',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1565C0),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Patient Vignesh (313311) requested an instant call',
                            style: TextStyle(
                              fontSize: 12,
                              color: DoctorColors.greyMedium,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to view  →',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onDismiss,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: DoctorColors.avatarGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}