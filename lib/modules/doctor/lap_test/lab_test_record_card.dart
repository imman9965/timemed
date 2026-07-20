import 'package:flutter/material.dart';

import '../theme/doctor_theme.dart';
import 'lab_test_record.dart';

/// Expandable card showing the details of a single lab test record.
class LabTestRecordCard extends StatefulWidget {
  final LabTestRecord record;

  const LabTestRecordCard({super.key, required this.record});

  @override
  State<LabTestRecordCard> createState() => _LabTestRecordCardState();
}

class _LabTestRecordCardState extends State<LabTestRecordCard> {
  bool _expanded = false;

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    final ap = d.hour < 12 ? 'AM' : 'PM';
    return '${d.day} ${_months[d.month - 1]} ${d.year}, $h:$m $ap';
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.record;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: DoctorColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DoctorColors.fieldBorder),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: DoctorColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.science_outlined,
                        color: DoctorColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                r.department,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: DoctorColors.textPrimary,
                                ),
                              ),
                            ),
                            if (r.urgent) _urgentBadge(),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '#${r.id}  •  ${_formatDate(r.requestedOn)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: DoctorColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _statusChip(r.status),
                            const Spacer(),
                            Text(
                              '${r.tests.length} test${r.tests.length == 1 ? '' : 's'}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: DoctorColors.textSecondary,
                              ),
                            ),
                            Icon(
                              _expanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: DoctorColors.textSecondary,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) _buildDetails(r),
        ],
      ),
    );
  }

  Widget _buildDetails(LabTestRecord r) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: DoctorColors.dividerCool, height: 1),
          const SizedBox(height: 12),
          const Text(
            'Tests',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: DoctorColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: r.tests
                .map((t) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: DoctorColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: DoctorColors.primary.withOpacity(0.25)),
                      ),
                      child: Text(
                        t,
                        style: const TextStyle(
                          fontSize: 12,
                          color: DoctorColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ))
                .toList(),
          ),
          if (r.notes != null && r.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Clinical Notes',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: DoctorColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              r.notes!,
              style: const TextStyle(
                fontSize: 13,
                color: DoctorColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusChip(LabTestStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 13, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _urgentBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: DoctorColors.errorRed.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.priority_high, size: 12, color: DoctorColors.errorRed),
          SizedBox(width: 2),
          Text(
            'Urgent',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: DoctorColors.errorRed,
            ),
          ),
        ],
      ),
    );
  }
}
