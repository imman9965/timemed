import 'package:flutter/material.dart';
import '../theme/doctor_theme.dart';
import '../../../core/widgets/common/curved_header.dart';
import '../widgets/doctor_stamp.dart';
import 'dummy_data_3.dart' hide NavItem;

class FilterButton extends StatelessWidget {
  final VoidCallback onTap;
  const FilterButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: DoctorColors.success,
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_alt, color: Colors.white, size: 15),
            SizedBox(width: 5),
            Text(
              'Filter',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Date picker input field
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

/// Single call log card
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
          // ── Row 1: Avatar + Date/Time ─────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
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
              // Date + Time stacked
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/img_21.png',
                        width: 11,
                        height: 11,
                      ),
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
                      Image.asset(
                        'assets/icons/img_22.png',
                        width: 14,
                        height: 14,
                      ),
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

          // ── Row 2: Name ───────────────────────────────────
          Text(
            log.patientName,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: DoctorColors.textDark,
            ),
          ),
          const SizedBox(height: 6),

          // ── Row 3: Fee + Type ─────────────────────────────
          Row(
            children: [
              Text(
                'Fee: ',
                style: const TextStyle(
                  fontSize: 13,
                  color: DoctorColors.textSecondary,
                ),
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
                style: const TextStyle(
                  fontSize: 13,
                  color: DoctorColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(
                Icons.phone,
                size: 13,
                color: DoctorColors.primaryBrand,
              ),
              const SizedBox(width: 4),
              Text(
                log.phone,
                style: const TextStyle(
                  fontSize: 13,
                  color: DoctorColors.textSecondary,
                ),
              ),
              const SizedBox(width: 24),
              Text(
                'Status: ',
                style: const TextStyle(
                  fontSize: 13,
                  color: DoctorColors.textSecondary,
                ),
              ),
              Text(
                _statusLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _statusColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(color: DoctorColors.divider, height: 1),
          const SizedBox(height: 10),

          // ── Progress note ─────────────────────────────────
          Text(
            'Progress of the call: ${log.progressNote}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: DoctorColors.textDark,
            ),
          ),
          const SizedBox(height: 8),

          // ── Task list + Video button ──────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Tasks — iterated from log.tasks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: log.tasks.map((task) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        children: [
                          Text(
                            task.completed ? '✅' : '❌',
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            task.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: task.completed
                                  ? DoctorColors.successDeep
                                  : DoctorColors.textDark,
                              decoration: task.completed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Video call button
              Container(
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
            ],
          ),
        ],
      ),
    );
  }
}

class CallLogsScreen extends StatefulWidget {
  final String? title;
  const CallLogsScreen({super.key,this.title,});

  @override
  State<CallLogsScreen> createState() => _CallLogsScreenState();
}

class _CallLogsScreenState extends State<CallLogsScreen> {
  DateTime? _selectedDate; // null = show all

  // ── Filtered list based on selected date ──────────────
  List<CallLog> get _filteredLogs {
    if (_selectedDate == null) return allCallLogs;
    return allCallLogs
        .where((log) => isSameDay(log.dateTime, _selectedDate!))
        .toList();
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

  // ── Filter bottom sheet ───────────────────────────────
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.check_circle,
                color: DoctorColors.successDeep,
              ),
              title: const Text('Success only'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filter: Success')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.pending, color: DoctorColors.warningPending),
              title: const Text('Pending only'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filter: Pending')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: DoctorColors.error),
              title: const Text('Failed only'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Filter: Failed')));
              },
            ),
            if (_selectedDate != null)
              ListTile(
                leading: const Icon(Icons.clear, color: DoctorColors.textMuted),
                title: const Text('Clear date filter'),
                onTap: () {
                  Navigator.pop(context);
                  _clearDate();
                },
              ),
          ],
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    late String? _status = widget.title.toString();  // use it for filtering

    return Scaffold(
      backgroundColor: DoctorColors.backgroundWarm,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                 CurvedHeader(title: widget.title??"CALL LOGS", showBackButton: false,
                  leading: const DoctorBadge(doctor: "Dr.Mariappan"),
                  titleStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Filter ───────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilterButton(onTap: _showFilterSheet),
                          ],
                        ),
                        const SizedBox(height: 16),

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

                        // Clear date chip
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
                                    color: DoctorColors.textSecondary
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // ── Call log cards — iterated ────────
                        if (_filteredLogs.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 48,
                                    color: DoctorColors.textSecondary
                                        .withOpacity(0.4),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No call logs for selected date',
                                    style: TextStyle(
                                      color: DoctorColors.textSecondary
                                          .withOpacity(0.7),
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
          ),
        ],
      ),
    );
  }
}
