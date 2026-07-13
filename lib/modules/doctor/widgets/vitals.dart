import 'package:flutter/material.dart';

import '../theme/doctor_theme.dart';

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

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => VitalSignDialog(context: context),
    );
  }

  @override
  State<VitalSignDialog> createState() => _VitalSignDialogState();
}

class _VitalSignDialogState extends State<VitalSignDialog> {
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
            primary:   DoctorColors.primaryVivid,
            onPrimary: Colors.white,
            onSurface: DoctorColors.textDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context:     context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary:   DoctorColors.primaryVivid,
            onPrimary: Colors.white,
            onSurface: DoctorColors.textDark,
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
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
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
        backgroundColor: DoctorColors.success,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: screenH * 0.82),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: DoctorRadii.brXxl,
            ),
            child: ClipRRect(
              borderRadius: DoctorRadii.brXxl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Blue header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: DoctorColors.primaryVivid,
                    child: const Text(
                      'VITAL SIGN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: DoctorFontWeight.extraBold,
                        fontSize: DoctorFontSize.title,
                        letterSpacing: DoctorLetterSpacing.widest,
                      ),
                    ),
                  ),

                  Flexible(
                    child: SingleChildScrollView(
                      padding: DoctorSpacing.cardPaddingLg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Vital Sign',
                            style: DoctorTextStyles.sectionTitle.copyWith(
                              color: DoctorColors.primaryVivid,
                            ),
                          ),
                          const SizedBox(height: DoctorSpacing.md),

                          Row(
                            children: [
                              Expanded(
                                child: _dateTimeField(
                                  label:     'Date',
                                  hint:      _formatDate(),
                                  hasValue:  _selectedDate != null,
                                  icon:      Icons.calendar_month,
                                  iconBg:    Colors.transparent,
                                  iconColor: DoctorColors.primaryVivid,
                                  onTap:     _pickDate,
                                ),
                              ),
                              const SizedBox(width: DoctorSpacing.md),
                              Expanded(
                                child: _dateTimeField(
                                  label:     'Time',
                                  hint:      _formatTime(),
                                  hasValue:  _selectedTime != null,
                                  icon:      Icons.access_time,
                                  iconBg:    DoctorColors.primaryVivid,
                                  iconColor: Colors.white,
                                  onTap:     _pickTime,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: DoctorSpacing.lg),

                          _buildVitalsCard(),
                          const SizedBox(height: DoctorSpacing.lg),

                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: _onSave,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: DoctorColors.primaryVivid,
                                  borderRadius: DoctorRadii.brMd,
                                ),
                                child: const Text(
                                  'Save',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: DoctorFontWeight.bold,
                                    fontSize: DoctorFontSize.bodyLarge,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: DoctorSpacing.sm),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Close button
          Positioned(
            top:   -12,
            right: -12,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width:  34,
                height: 34,
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
                child: const Icon(Icons.close, color: Colors.white, size: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        Text(label, style: DoctorTextStyles.label.copyWith(
          fontWeight: DoctorFontWeight.bold,
          color: DoctorColors.textDark,
        )),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: DoctorColors.inputBg,
              borderRadius: DoctorRadii.brSm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hint,
                    style: DoctorTextStyles.hint.copyWith(
                      color: hasValue ? DoctorColors.textDark : DoctorColors.textMuted,
                      fontWeight: hasValue ? DoctorFontWeight.semiBold : DoctorFontWeight.medium,
                    ),
                  ),
                ),
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVitalsCard() {
    return Container(
      decoration: BoxDecoration(
        color: DoctorColors.rowBg,
        borderRadius: DoctorRadii.brMd,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: DoctorColors.primaryVivid,
              borderRadius: BorderRadius.only(
                topLeft:  Radius.circular(DoctorRadii.md),
                topRight: Radius.circular(DoctorRadii.md),
              ),
            ),
            child: const Text(
              'Vital Signs',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: DoctorFontSize.subtitle,
                fontWeight: DoctorFontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: DoctorSpacing.cardPadding,
            child: Column(
              children: _vitals.asMap().entries.map((e) {
                final isLast = e.key == _vitals.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : DoctorSpacing.sm),
                  child: _vitalRow(e.value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vitalRow(_Vital v) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(v.icon, size: 22, color: DoctorColors.textMuted),
            const SizedBox(width: 10),
            Expanded(
              child: Text(v.label, style: DoctorTextStyles.body.copyWith(
                fontWeight: DoctorFontWeight.bold,
              )),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: DoctorRadii.brXs,
                border: Border.all(color: DoctorColors.divider),
              ),
              child: Text(
                v.formatter(v.sliderValue * v.max),
                style: DoctorTextStyles.caption,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, top: 2),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight:        3,
              activeTrackColor:   DoctorColors.primaryVivid,
              inactiveTrackColor: DoctorColors.dividerNeutral,
              thumbColor:         DoctorColors.primaryVivid,
              thumbShape:  const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              value:    v.sliderValue,
              min:      0,
              max:      1,
              onChanged: (val) => setState(() => v.sliderValue = val),
            ),
          ),
        ),
        Divider(height: 4, color: DoctorColors.divider),
      ],
    );
  }
}

class VitalSignDemoScreen extends StatelessWidget {
  const VitalSignDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DoctorColors.backgroundCream,
      appBar: AppBar(
        backgroundColor: DoctorColors.primaryVivid,
        title: const Text(
          'Call Logs',
          style: TextStyle(color: Colors.white, fontWeight: DoctorFontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => VitalSignDialog.show(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: DoctorColors.primaryVivid,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: DoctorRadii.brMd),
          ),
          child: const Text(
            'Open Vital Sign',
            style: TextStyle(
              color: Colors.white,
              fontWeight: DoctorFontWeight.bold,
              fontSize: DoctorFontSize.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
