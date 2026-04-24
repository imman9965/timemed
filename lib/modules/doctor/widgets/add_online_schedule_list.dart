import 'package:flutter/material.dart';

import '../hospital_list_doctor/hospital_list_based_on_doctor.dart';

// void main() => runApp(const MaterialApp(
//   debugShowCheckedModeBanner: false,
//   home: DemoScreen(),
// ));

// ════════════════════════════════════════════════════════
//  APP COLORS
// ════════════════════════════════════════════════════════

class AppColors {
  static const primaryBlue  = Color(0xFF1A6BF5);
  static const scaffoldBg   = Color(0xFFFAF5EC);
  static const cardBg       = Colors.white;
  static const textDark     = Color(0xFF1A1A2E);
  static const textMuted    = Color(0xFF9E9E9E);
  static const textSecond   = Color(0xFF6B7280);
  static const inputBg      = Color(0xFFF5F5F5);
  static const dividerColor = Color(0xFFE0E0E0);
  static const redClose     = Color(0xFFE53935);
  static const greenBtn     = Color(0xFF4CAF50);
}

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
//  ADD ONLINE CONSULTATION SCHEDULE DIALOG
// ════════════════════════════════════════════════════════

class AddOnlineConsultationDialog extends StatefulWidget {
  final OnlineScheduleData? initialData;

  const AddOnlineConsultationDialog({super.key, this.initialData});

  /// Static helper to open dialog
  static Future<OnlineScheduleData?> show(
      BuildContext context, {
        OnlineScheduleData? initialData,
      }) {
    return showDialog<OnlineScheduleData>(
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

  late OnlineScheduleData _data;

  @override
  void initState() {
    super.initState();
    _data = widget.initialData?.copy() ??
        OnlineScheduleData(selectedDays: {'all'});
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
            primary:   AppColors.primaryBlue,
            onPrimary: Colors.white,
            onSurface: AppColors.textDark,
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

  // ── Add New action ───────────────────────────────────
  void _onAddNew() {
    if (_data.fromTime == null || _data.toTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both From and To time'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    Navigator.pop(context, _data);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Schedule added: ${_data.fromTime!.format(context)} → '
                '${_data.toTime!.format(context)}'),
        backgroundColor: AppColors.greenBtn,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 80,vertical: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [

          // ── Main card ──────────────────────────────────
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

                  // ── Blue header ────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    color: AppColors.primaryBlue,
                    child: const Text(
                      'ADD ONLINE\nCONSULTATION SCHEDULE LIST',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        height: 1.4,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  // ── Body ───────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      children: [
                        _buildAvailableDays(),
                        const SizedBox(height: 14),
                        _buildTimeRow(),
                        const SizedBox(height: 16),
                        _buildAddNewButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Close button (overlapping) ────────────────
          Positioned(
            top: -14, right: -14,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.redClose,
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
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, color: AppColors.dividerColor),
        const SizedBox(height: 10),

        // Days grid — 2 rows × 4 columns, iterated from _dayGrid
        Column(
          children: _dayGrid.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: row.map((key) {
                  final option = _dayOptions
                      .firstWhere((o) => o.key == key);
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
          onTap: () => _toggleDay(option.key),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryBlue
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              option.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? Colors.white
                    : AppColors.textDark,
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
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _buildTimeField(
              label: 'From',
              time:  _data.fromTime,
              onTap: () => _pickTime(true),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            child: Icon(Icons.arrow_forward,
                color: AppColors.textDark, size: 16),
          ),
          Expanded(
            child: _buildTimeField(
              label: 'To',
              time:  _data.toTime,
              onTap: () => _pickTime(false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField({
    required String       label,
    required TimeOfDay?   time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: AppColors.primaryBlue, width: 1.2),
            ),
            child: Text(
              time?.format(context) ?? 'Time',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: time != null
                    ? AppColors.textDark
                    : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Add New button ───────────────────────────────────
  Widget _buildAddNewButton() {
    return GestureDetector(
      onTap: _onAddNew,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 32, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.greenBtn,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.greenBtn.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Text(
          'Add New',
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


