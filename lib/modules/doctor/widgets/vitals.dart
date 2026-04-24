import 'package:flutter/material.dart';

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
  static const inputBg      = Color(0xFFF2F2F2);
  static const dividerColor = Color(0xFFE5E5E5);
  static const redClose     = Color(0xFFE53935);
  static const vitalRowBg   = Color(0xFFF4F4F4);
}

// ════════════════════════════════════════════════════════
//  APP DIMENSIONS
// ════════════════════════════════════════════════════════

class AppDimens {
  static const double xs  = 4;
  static const double s   = 8;
  static const double m   = 12;
  static const double l   = 16;
  static const double xl  = 20;
  static const double xxl = 24;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;

  static const double screenHPadding = 16;
}

// ════════════════════════════════════════════════════════
//  APP TEXT STYLES
// ════════════════════════════════════════════════════════

class AppTextStyles {
  static const bodyBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const inputLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const inputHint = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static const modalTitle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 18,
    letterSpacing: 1.2,
  );
}

// ════════════════════════════════════════════════════════
//  VITAL DATA CLASS
// ════════════════════════════════════════════════════════

class _Vital {
  final String   label;
  final IconData icon;
  final double   min;
  final double   max;
  final String Function(double) formatter;
  double         sliderValue;

  _Vital({
    required this.label,
    required this.icon,
    required this.min,
    required this.max,
    required this.formatter,
    this.sliderValue = 0,
  });
}

// ════════════════════════════════════════════════════════
//  VITAL SIGN POPUP DIALOG
// ════════════════════════════════════════════════════════

class VitalSignDialog extends StatefulWidget {
  const VitalSignDialog({super.key, required BuildContext context});

  /// Open as a centered popup dialog
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => VitalSignDialog(context: context,),
    );
  }

  @override
  State<VitalSignDialog> createState() => _VitalSignDialogState();
}

class _VitalSignDialogState extends State<VitalSignDialog> {
  // ── Vital data list ───────────────────────────────────
  final List<_Vital> _vitals = [
    _Vital(
      label:     'Pulse Rate',
      icon:      Icons.monitor_heart_outlined,
      min:       0, max: 200,
      formatter: (v) => '${v.toStringAsFixed(1)}/ Min',
    ),
    _Vital(
      label:     'Systolic Pressure',
      icon:      Icons.favorite_border,
      min:       0, max: 250,
      formatter: (v) => '${v.toStringAsFixed(1)}mm of Hg',
    ),
    _Vital(
      label:     'Diastolic Pressure',
      icon:      Icons.favorite_outline,
      min:       0, max: 200,
      formatter: (v) => '${v.toStringAsFixed(1)}mm of Hg',
    ),
    _Vital(
      label:     'Saturation',
      icon:      Icons.speed,
      min:       0, max: 100,
      formatter: (v) => '${v.toStringAsFixed(1)}%',
    ),
    _Vital(
      label:     'Temperation',
      icon:      Icons.thermostat_outlined,
      min:       0, max: 50,
      formatter: (v) => '${v.toStringAsFixed(1)}C',
    ),
    _Vital(
      label:     'Respiration',
      icon:      Icons.air,
      min:       0, max: 60,
      formatter: (v) => '${v.toStringAsFixed(1)}/ Min',
    ),
  ];

  DateTime?  _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context:     context,
      initialDate: DateTime.now(),
      firstDate:   DateTime(2020),
      lastDate:    DateTime(2030),
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
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // ── Time picker ───────────────────────────────────────
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context:     context,
      initialTime: TimeOfDay.now(),
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
    if (picked != null) setState(() => _selectedTime = picked);
  }

  String _formatDate() {
    if (_selectedDate == null) return 'DD/MM/YYYY';
    final d = _selectedDate!;
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  String _formatTime() {
    if (_selectedTime == null) return 'HH:MM:SS';
    final h = _selectedTime!.hour.toString().padLeft(2, '0');
    final m = _selectedTime!.minute.toString().padLeft(2, '0');
    return '$h:$m:00';
  }

  void _onSave() {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date and time'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vital signs saved successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Main popup card ──────────────────────────
          Container(
            constraints: BoxConstraints(maxHeight: screenH * 0.82),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.radiusXl),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusXl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ── Blue header ──────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: AppColors.primaryBlue,
                    child: const Text(
                      'VITAL SIGN',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.modalTitle,
                    ),
                  ),

                  // ── Scrollable body ──────────────────
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppDimens.l),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // "Add Vital Sign" label
                          const Text(
                            'Add Vital Sign',
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: AppDimens.m),

                          // ── Date + Time row ──────────
                          Row(
                            children: [
                              Expanded(
                                child: _dateTimeField(
                                  label:    'Date',
                                  hint:     _formatDate(),
                                  hasValue: _selectedDate != null,
                                  icon:     Icons.calendar_month,
                                  iconBg:   Colors.transparent,
                                  iconColor: AppColors.primaryBlue,
                                  onTap:    _pickDate,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _dateTimeField(
                                  label:    'Time',
                                  hint:     _formatTime(),
                                  hasValue: _selectedTime != null,
                                  icon:     Icons.access_time,
                                  iconBg:   AppColors.primaryBlue,
                                  iconColor: Colors.white,
                                  onTap:    _pickTime,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimens.l),

                          // ── Vitals card ──────────────
                          _buildVitalsCard(),
                          const SizedBox(height: AppDimens.l),

                          // ── Save button ──────────────
                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: _onSave,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.radiusMd),
                                ),
                                child: const Text(
                                  'Save',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimens.s),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top:   -12,
            right: -12,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width:  34,
                height: 34,
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
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Date/Time field ───────────────────────────────────
  Widget _dateTimeField({
    required String       label,
    required String       hint,
    required bool         hasValue,
    required IconData     icon,
    required Color        iconBg,
    required Color        iconColor,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputLabel),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius:
              BorderRadius.circular(AppDimens.radiusSm),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hint,
                    style: hasValue
                        ? AppTextStyles.inputHint.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    )
                        : AppTextStyles.inputHint,
                  ),
                ),
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Vitals card ───────────────────────────────────────
  Widget _buildVitalsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.vitalRowBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: Column(
        children: [
          // Blue section header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.only(
                topLeft:  Radius.circular(AppDimens.radiusMd),
                topRight: Radius.circular(AppDimens.radiusMd),
              ),
            ),
            child: const Text(
              'Vital Signs',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Vitals list — iterated from _vitals
          Padding(
            padding: const EdgeInsets.all(AppDimens.m),
            child: Column(
              children: _vitals.asMap().entries.map((e) {
                final isLast = e.key == _vitals.length - 1;
                return Padding(
                  padding:
                  EdgeInsets.only(bottom: isLast ? 0 : 8),
                  child: _vitalRow(e.value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Single vital row ──────────────────────────────────
  Widget _vitalRow(_Vital v) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(v.icon, size: 22, color: AppColors.textMuted),
            const SizedBox(width: 10),
            Expanded(
              child: Text(v.label, style: AppTextStyles.bodyBold),
            ),
            // Live value chip
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.dividerColor),
              ),
              child: Text(
                v.formatter(v.sliderValue * v.max),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),

        // Slider
        Padding(
          padding: const EdgeInsets.only(left: 32, top: 2),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight:        3,
              activeTrackColor:   AppColors.primaryBlue,
              inactiveTrackColor: const Color(0xFFE0E0E0),
              thumbColor:         AppColors.primaryBlue,
              thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 14),
            ),
            child: Slider(
              value:    v.sliderValue,
              min:      0,
              max:      1,
              onChanged: (val) =>
                  setState(() => v.sliderValue = val),
            ),
          ),
        ),

        const Divider(height: 4, color: AppColors.dividerColor),
      ],
    );
  }
}



class VitalSignDemoScreen extends StatelessWidget {
  const VitalSignDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          'Call Logs',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => VitalSignDialog.show(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            padding: const EdgeInsets.symmetric(
                horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(AppDimens.radiusMd),
            ),
          ),
          child: const Text(
            'Open Vital Sign',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}