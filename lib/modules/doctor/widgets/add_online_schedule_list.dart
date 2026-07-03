import 'package:flutter/material.dart';

import '../theme/doctor_theme.dart';
import '../hospital_list_doctor/hospital_list_based_on_doctor.dart';
import '../medical_records/dummy_data_7.dart';

// ════════════════════════════════════════════════════════
//  DATA MODELS
// ════════════════════════════════════════════════════════

class DayOption {
  final String key;
  final String label;
  const DayOption({required this.key, required this.label});
}

// ════════════════════════════════════════════════════════
//  STATIC DATA
// ════════════════════════════════════════════════════════

const List<DayOption> _dayOptions = [
  DayOption(key: 'all', label: 'All'),
  DayOption(key: 'sun', label: 'Sun'),
  DayOption(key: 'mon', label: 'Mon'),
  DayOption(key: 'tue', label: 'Tue'),
  DayOption(key: 'wed', label: 'Wed'),
  DayOption(key: 'thu', label: 'Thu'),
  DayOption(key: 'fri', label: 'Fri'),
  DayOption(key: 'sat', label: 'Sat'),
];

// Grid layout: 4 columns × 2 rows
const List<List<String>> _dayGrid = [
  ['all', 'sun', 'mon', 'tue'],
  ['wed', 'thu', 'fri', 'sat'],
];

// ════════════════════════════════════════════════════════
//  ADD / EDIT ONLINE CONSULTATION SCHEDULE DIALOG
// ════════════════════════════════════════════════════════

class AddOnlineConsultationDialog extends StatefulWidget {
  final OnlineSchedule? initialData;

  const AddOnlineConsultationDialog({super.key, this.initialData});

  /// Static helper to open the dialog.
  /// Pass [initialData] to pre-fill existing schedule for editing.
  /// Returns the updated [OnlineSchedule] or null if cancelled.
  static Future<OnlineSchedule?> show(
      BuildContext context, {
        OnlineSchedule? initialData,
      }) {
    return showDialog<OnlineSchedule>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => AddOnlineConsultationDialog(initialData: initialData),
    );
  }

  @override
  State<AddOnlineConsultationDialog> createState() =>
      _AddOnlineConsultationDialogState();
}

class _AddOnlineConsultationDialogState
    extends State<AddOnlineConsultationDialog> {
  late OnlineSchedule _data;
  late final bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.initialData != null;

    // Clone initialData if provided, else create fresh with default 'all' day
    _data = widget.initialData?.copy() ??
        OnlineSchedule(
          id: '',
          selectedDays: {'all'},
        );
  }

  // ── Day toggle logic ─────────────────────────────────
  void _toggleDay(String key) {
    setState(() {
      if (key == 'all') {
        // Tapping All → select only All
        _data.selectedDays = {'all'};
      } else {
        // Tapping another day → remove All and toggle the day
        _data.selectedDays.remove('all');
        if (_data.selectedDays.contains(key)) {
          _data.selectedDays.remove(key);
        } else {
          _data.selectedDays.add(key);
        }
        // If nothing selected, default back to All
        if (_data.selectedDays.isEmpty) {
          _data.selectedDays = {'all'};
        }
      }
    });
  }

  // ── Time pickers ─────────────────────────────────────
  Future<void> _pickTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
      (isFrom ? _data.fromTime : _data.toTime) ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: DoctorColors.primaryBrand,
            onPrimary: Colors.white,
            onSurface: DoctorColors.textDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _data.fromTime = picked;
        } else {
          _data.toTime = picked;
        }
      });
    }
  }

  // ── Validation helper ────────────────────────────────
  String? _validate() {
    if (_data.fromTime == null || _data.toTime == null) {
      return 'Please select both From and To time';
    }

    // Compare times as minutes since midnight
    final fromMinutes = _data.fromTime!.hour * 60 + _data.fromTime!.minute;
    final toMinutes = _data.toTime!.hour * 60 + _data.toTime!.minute;

    if (fromMinutes >= toMinutes) {
      return 'From time must be earlier than To time';
    }

    if (_data.selectedDays.isEmpty) {
      return 'Please select at least one day';
    }

    return null; // valid
  }

  // ── Save action ──────────────────────────────────────
  void _onSave() {
    final error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: DoctorColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Return the updated data to caller — parent is responsible for the
    // success snackbar so it shows on the correct screen.
    Navigator.pop(context, _data);
  }

  // ════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Padding(
        // Reserve space for the overlapping close button so it stays tappable
        padding: const EdgeInsets.only(top: 18, right: 18),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Main card ──────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Blue header ──────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      color: DoctorColors.primaryBrand,
                      child: Text(
                        _isEditMode
                            ? 'EDIT ONLINE\nCONSULTATION SCHEDULE'
                            : 'ADD ONLINE\nCONSULTATION SCHEDULE LIST',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          height: 1.4,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),

                    // ── Body ─────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: Column(
                        children: [
                          _buildAvailableDays(),
                          const SizedBox(height: 14),
                          _buildTimeRow(),
                          const SizedBox(height: 16),
                          _buildSaveButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Close button (overlapping) ─────────────
            Positioned(
              top: -12,
              right: -12,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: DoctorColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Available Days section ────────────────────────────
  Widget _buildAvailableDays() {
    return Column(
      children: [
        const Text(
          'Available Days',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: DoctorColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, color: DoctorColors.divider),
        const SizedBox(height: 10),

        // Days grid — 2 rows × 4 columns
        Column(
          children: _dayGrid.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: row.map((key) {
                  final option =
                  _dayOptions.firstWhere((o) => o.key == key);
                  return _buildDayPill(option);
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDayPill(DayOption option) {
    final isSelected = _data.selectedDays.contains(option.key);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _toggleDay(option.key),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? DoctorColors.primaryBrand
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              option.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : DoctorColors.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Time row ─────────────────────────────────────────
  Widget _buildTimeRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: DoctorColors.inputBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _buildTimeField(
              label: 'From',
              time: _data.fromTime,
              onTap: () => _pickTime(true),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            child: Icon(Icons.arrow_forward,
                color: DoctorColors.textDark, size: 16),
          ),
          Expanded(
            child: _buildTimeField(
              label: 'To',
              time: _data.toTime,
              onTap: () => _pickTime(false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: DoctorColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: DoctorColors.primaryBrand,
                width: 1.2,
              ),
            ),
            child: Text(
              time?.format(context) ?? 'Time',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: time != null
                    ? DoctorColors.textDark
                    : DoctorColors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Save / Add button ────────────────────────────────
  Widget _buildSaveButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onSave,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        decoration: BoxDecoration(
          color: DoctorColors.success,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: DoctorColors.success.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          _isEditMode ? 'Update' : 'Add New',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}