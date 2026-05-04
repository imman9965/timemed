import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/common/curved_header.dart';
import '../missed_call_page/missed_call.dart' hide AppColors;
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
          color: AppColors.green2,
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_alt, color: Colors.white, size: 15),
            SizedBox(width: 5),
            Text('Filter',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

/// Date picker input field
class DatePickerField extends StatelessWidget {
  final DateTime?    selectedDate;
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
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasDate
                    ? '${selectedDate!.day.toString().padLeft(2,'0')}/'
                    '${selectedDate!.month.toString().padLeft(2,'0')}/'
                    '${selectedDate!.year}'
                    : 'DD/MM/YYYY',
                style: TextStyle(
                  fontSize: 14,
                  color: hasDate
                      ? AppColors.textDark
                      : AppColors.textSecond,
                ),
              ),
            ),
            const Icon(Icons.calendar_month,
                color: AppColors.primary, size: 20),
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
  String get _typeIcon =>
      log.type == AppointmentType.instant ? '⚡' : '📅';

  Color get _statusColor {
    switch (log.status) {
      case CallStatus.success: return AppColors.successColor2;
      case CallStatus.pending: return AppColors.pendingColor2;
      case CallStatus.failed:  return AppColors.failColor2;
    }
  }

  String get _statusLabel {
    switch (log.status) {
      case CallStatus.success: return 'Success';
      case CallStatus.pending: return 'Pending';
      case CallStatus.failed:  return 'Failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
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
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: const Icon(Icons.person,
                    color: Colors.white, size: 28),
              ),
              const Spacer(),
              // Date + Time stacked
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(children: [
                    const Icon(Icons.calendar_month,
                        size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(formatDate(log.dateTime),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.access_time,
                        size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(formatTime(log.dateTime),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                  ]),
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
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),

          // ── Row 3: Fee + Type ─────────────────────────────
          Row(
            children: [
              Text('Fee: ',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecond)),
              Text(log.fee,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.feeColor2)),
              const SizedBox(width: 24),
              Text('Type: $_typeIcon $_typeLabel',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecond)),
            ],
          ),
          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(Icons.phone, size: 13, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(log.phone,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecond)),
              const SizedBox(width: 24),
              Text('Status: ',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecond)),
              Text(_statusLabel,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _statusColor)),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 10),

          // ── Progress note ─────────────────────────────────
          Text(
            'Progress of the call: ${log.progressNote}',
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark),
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
                                  ? AppColors.successColor2
                                  : AppColors.textDark,
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
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.videocam,
                    color: Colors.white, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }
}





class CallLogsScreen extends StatefulWidget {
  const CallLogsScreen({Key? key}) : super(key: key);

  @override
  State<CallLogsScreen> createState() => _CallLogsScreenState();
}

class _CallLogsScreenState extends State<CallLogsScreen> {

  DateTime? _selectedDate;            // null = show all

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
      firstDate:   DateTime(2020),
      lastDate:    DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary:   AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
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
            const Text('Filter Options',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.check_circle,
                  color: AppColors.successColor2),
              title: const Text('Success only'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filter: Success')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.pending,
                  color: AppColors.pendingColor2),
              title: const Text('Pending only'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filter: Pending')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel,
                  color: AppColors.failColor2),
              title: const Text('Failed only'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filter: Failed')),
                );
              },
            ),
            if (_selectedDate != null)
              ListTile(
                leading: const Icon(Icons.clear, color: Colors.grey),
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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                const CurvedHeader(title: 'Call Logs'),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ── Doctor badge + Filter ────────────
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            DoctorBadge(doctor: "Dr.Mariappan" ),
                            FilterButton(onTap: _showFilterSheet),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ── Date label ───────────────────────
                        Text('Date',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary)),
                        const SizedBox(height: 8),

                        // ── Date picker field ────────────────
                        DatePickerField(
                          selectedDate: _selectedDate,
                          onTap:        _pickDate,
                        ),

                        // Clear date chip
                        if (_selectedDate != null) ...[
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _clearDate,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.close,
                                    size: 14,
                                    color: AppColors.textSecond),
                                const SizedBox(width: 4),
                                Text(
                                  'Clear date filter',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecond
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 40),
                              child: Column(
                                children: [
                                  Icon(Icons.search_off,
                                      size: 48,
                                      color: AppColors.textSecond
                                          .withOpacity(0.4)),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No call logs for selected date',
                                    style: TextStyle(
                                        color: AppColors.textSecond
                                            .withOpacity(0.7),
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ..._filteredLogs.map(
                                (log) => CallLogCard(log: log),
                          ),
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