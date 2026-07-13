import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/routes/app_routes.dart';
import '../call_logs/dummy_data_3.dart';
import '../theme/doctor_theme.dart';
import '../../../core/widgets/common/curved_header.dart';

/// Date picker input field (unchanged)
class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DatePickerField({
    Key? key,
    required this.selectedDate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasDate = selectedDate != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: DoctorColors.cardWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: DoctorColors.divider),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasDate
                    ? '${selectedDate!.day.toString().padLeft(2, '0')}/'
                    '${selectedDate!.month.toString().padLeft(2, '0')}/'
                    '${selectedDate!.year}'
                    : 'DD/MM/YYYY',
                style: TextStyle(
                  fontSize: 14,
                  color: hasDate
                      ? DoctorColors.textDark
                      : DoctorColors.textSecondary,
                ),
              ),
            ),
            Image.asset('assets/icons/img_21.png', width: 17, height: 17),
          ],
        ),
      ),
    );
  }
}

/// Single call log card (unchanged)
class CallLogCard extends StatelessWidget {
  final CallLog log;
  const CallLogCard({Key? key, required this.log}) : super(key: key);

  String get _typeLabel =>
      log.type == AppointmentType.instant ? 'Instant' : 'Schedule';
  String get _typeIcon => log.type == AppointmentType.instant ? '⚡' : '📅';

  Color get _statusColor {
    switch (log.status) {
      case CallStatus.success:
        return DoctorColors.successDeep;
      case CallStatus.pending:
        return DoctorColors.warningPending;
      case CallStatus.failed:
        return DoctorColors.error;
    }
  }

  String get _statusLabel {
    switch (log.status) {
      case CallStatus.success:
        return 'Success';
      case CallStatus.pending:
        return 'Pending';
      case CallStatus.failed:
        return 'Failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Avatar + Date/Time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: DoctorColors.dividerNeutral,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 28),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/icons/img_21.png', width: 11, height: 11),
                      const SizedBox(width: 4),
                      Text(
                        formatDate(log.dateTime),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: DoctorColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    spacing: 2,
                    children: [
                      Image.asset('assets/icons/img_22.png', width: 14, height: 14),
                      Text(
                        formatTime(log.dateTime),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: DoctorColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            log.patientName,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: DoctorColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                'Fee: ',
                style: const TextStyle(fontSize: 13, color: DoctorColors.textSecondary),
              ),
              Text(
                log.fee,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: DoctorColors.primaryVivid,
                ),
              ),
              const SizedBox(width: 24),
              Text(
                'Type: $_typeIcon $_typeLabel',
                style: const TextStyle(fontSize: 13, color: DoctorColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.phone, size: 13, color: DoctorColors.primaryBrand),
              const SizedBox(width: 4),
              Text(log.phone, style: const TextStyle(fontSize: 13, color: DoctorColors.textSecondary)),
              const SizedBox(width: 24),
              const Text('Status: ', style: TextStyle(fontSize: 13, color: DoctorColors.textSecondary)),
              Text(
                _statusLabel,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _statusColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: DoctorColors.divider, height: 1),
          const SizedBox(height: 10),
          Text(
            'Progress of the call: ${log.progressNote}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: DoctorColors.textDark),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: log.tasks.map((task) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        children: [
                          Text(task.completed ? '✅' : '❌', style: const TextStyle(fontSize: 13)),
                          const SizedBox(width: 6),
                          Text(
                            task.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: task.completed ? DoctorColors.successDeep : DoctorColors.textDark,
                              decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push(AppRoutes.videoPage);
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: DoctorColors.primaryBrand,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.videocam,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CallLogsScreenDash extends StatefulWidget {
  final String? title;
  const CallLogsScreenDash({super.key, this.title});

  @override
  State<CallLogsScreenDash> createState() => _CallLogsScreenDashState();
}

class _CallLogsScreenDashState extends State<CallLogsScreenDash> {

  DateTime? _selectedDate;

  @override
  void initState() {
    debugPrint("${widget.title}imman");
    super.initState();
  }

  // ── Filtered list: based on title and date ──
  List<CallLog> get _filteredLogs {
    Iterable<CallLog> logs;
    if (widget.title == "WAITING LIST") {
      logs = allCallLogs.where((log) => log.status == CallStatus.pending);
    } else {
      logs = allCallLogs.where(
            (log) => log.status == CallStatus.pending || log.status == CallStatus.success,
      );
    }
    if (_selectedDate != null) {
      logs = logs.where((log) => isSameDay(log.dateTime, _selectedDate!));
    }
    return logs.toList();
  }

  // ── Date picker ───────────────────────────────────────
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2026, 1, 7),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: DoctorColors.primaryBrand,
              onPrimary: Colors.white,
              onSurface: DoctorColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _clearDate() => setState(() => _selectedDate = null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DoctorColors.backgroundWarm,
      body: Column(
        children: [
          CurvedHeader(
            title: widget.title ?? "CALL LOGS",
            titleStyle: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Date label ───────────────────────
                  Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: DoctorColors.primaryBrand,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Date picker field ────────────────
                  DatePickerField(
                    selectedDate: _selectedDate,
                    onTap: _pickDate,
                  ),

                  // ── Clear date chip ──────────────────
                  if (_selectedDate != null) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _clearDate,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.close,
                            size: 14,
                            color: DoctorColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Clear date filter',
                            style: TextStyle(
                              fontSize: 12,
                              color: DoctorColors.textSecondary.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // ── Call log cards ──
                  if (_filteredLogs.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: DoctorColors.textSecondary.withOpacity(0.4),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.title == "WAITING LIST"
                                  ? "No pending call logs"
                                  : "No pending or success call logs",
                              style: TextStyle(
                                color: DoctorColors.textSecondary.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._filteredLogs.map((log) => CallLogCard(log: log)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}