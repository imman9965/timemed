import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/widgets/common/curved_header.dart';
import 'package:timesmed_project/routes/app_routes.dart';

import '../../../core/constants/app_colors.dart';
import '../theme/doctor_colors.dart';

/// Appointment dashboard with fully functional date range picker.
class AppointmentDashboard extends StatefulWidget {
  const AppointmentDashboard({super.key});

  @override
  State<AppointmentDashboard> createState() => _AppointmentDashboardState();
}

class _AppointmentDashboardState extends State<AppointmentDashboard> {
  // Initial dates
  late DateTime _startDate;
  late DateTime _endDate;

  // Date format for display
  static const _dateFormat = 'd MMMM yyyy';

  @override
  void initState() {
    super.initState();
    _startDate = DateTime(2025, 3, 31);
    _endDate = DateTime(2025, 5, 31);
  }

  // Helper to format DateTime -> string
  String _formatDate(DateTime date) {
    // Using intl package would be nicer, but we do manual formatting
    // to avoid extra dependency. For production, consider DateFormat.
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Show date picker and update state
  Future<void> _selectDate(bool isStartDate) async {
    final initialDate = isStartDate ? _startDate : _endDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Transform.scale(
          scale: 0.9, // Adjust size (0.7, 0.8, 0.9)
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // ── Exact colors pulled from the reference image ────────────────
  static const Color _teal = Color(0xFF1BA098); // Scheduled / For Confirmation
  static const Color _blue = Color(0xFF2BA8DD); // Waiting / Follow Up
  static const Color _red = Color(0xFFE0394C); // Check Out
  static const Color _amber = Color(0xFFF5A623); // Cancle / Missed
  static const Color _navy = Color(
    0xFF37474F,
  ); // Online Consultation / Hospital bar
  static const Color _olive = Color(0xFF8BB832); // OT Request Count

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

          CurvedHeader(
            title: "DOCTOR DASHBOARD",
            showBackButton: false,
            titleStyle: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _DateBox(
                          label: 'Start Date',
                          date: _formatDate(_startDate),
                          onTap: () => _selectDate(true),
                        ),
                      ),
                      Container(
                        width: 1.8,
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: const Color(0xFF1947CD),
                      ),

                      Expanded(
                        child: _DateBox(
                          label: 'End Date',
                          date: _formatDate(_endDate),
                          onTap: () => _selectDate(false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          color: _teal,
                          count: '0',
                          label: 'Scheduled',
                          icon: Icons.event_available_rounded,
                          onTap: () {
                            context.push(
                              AppRoutes.callLogsScreenDash,
                              extra: 'Scheduled Appointment List',
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          color: _blue,
                          count: '0',
                          label: 'Waiting',
                          icon: Icons.pending_actions_rounded,
                          onTap: () {
                            context.push(
                              AppRoutes.callLogsScreenDash,
                              extra: 'WAITING LIST',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          color: _red,
                          count: '0',
                          label: 'Check Out',
                          icon: Icons.task_alt_rounded,
                          onTap: () {
                            context.push(
                              AppRoutes.scheduleAppointment,
                              extra: 'Check Out',
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          color: _amber,
                          count: '0',
                          label: 'Cancel',
                          icon: Icons.event_busy_rounded,
                          onTap: () {
                            context.push(
                              AppRoutes.scheduleAppointment,
                              extra: 'Cancelled Appointments',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ── Row 3: Online Consultation (full width) ───────
                  _StatCard(
                    color: _navy,
                    count: '0',
                    label: 'Online Consultation',
                    icon: Icons.calendar_month_rounded,
                    fullWidth: true,
                    onTap: () {
                      context.push(AppRoutes.doctorWaitingList);

                      // context.push(AppRoutes.scheduleAppointment, extra: 'Online Consultation');
                    },
                  ),
                  const SizedBox(height: 10),

                  // ── Row 4: OT Request Count + Follow Up ───────────
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          color: _olive,
                          count: '0',
                          label: 'OT Request Count',
                          icon: Icons.event_note_rounded,
                          onTap: () {
                            // context.push(AppRoutes.scheduleAppointment, extra: 'OT Request Count');
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          color: _blue,
                          count: '0',
                          label: 'Follow Up\nAppointment',
                          icon: Icons.event_repeat_rounded,
                          onTap: () {
                            // context.push(AppRoutes.scheduleAppointment, extra: 'Follow Up Appointment');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ── Row 5: Missed + For Confirmation ──────────────
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          color: _amber,
                          count: '0',
                          label: 'Missed',
                          icon: Icons.phone_missed_rounded,
                          onTap: () {
                            context.push(
                              AppRoutes.scheduleAppointment,
                              extra: 'Missed Appointments',
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          color: _teal,
                          count: '0',
                          label: 'For Confirmation',
                          icon: Icons.verified_user_rounded,
                          onTap: () {
                            context.push(
                              AppRoutes.scheduleAppointment,
                              extra: 'For Confirmation',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Hospital Appointment bar ──────────────────────
                  _HospitalBar(
                    label: 'Hospital Appointment',
                    color: _navy,
                    onTap: () {
                      context.push(
                        AppRoutes.scheduleAppointment,
                        extra: 'Hospital Appointment',
                      );
                    },
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

/// A tappable date box (used for start & end date)
class _DateBox extends StatelessWidget {
  final String label;
  final String date;
  final VoidCallback onTap;

  const _DateBox({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFF1565D8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF212121),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primaryBlue,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stat card (unchanged, only kept for completeness)
class _StatCard extends StatelessWidget {
  final Color color;
  final String count;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool fullWidth;

  const _StatCard({
    required this.color,
    required this.count,
    required this.label,
    required this.icon,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: fullWidth ? double.infinity : null,
          height: 92,
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      count,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(icon, color: Colors.white.withOpacity(0.92), size: 46),
            ],
          ),
        ),
      ),
    );
  }
}

/// Hospital appointment bar (unchanged)
class _HospitalBar extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _HospitalBar({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(Icons.add, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                'Hospital Appointment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
