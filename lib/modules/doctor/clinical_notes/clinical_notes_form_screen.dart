import 'package:flutter/material.dart';
import 'package:timesmed_project/modules/doctor/widgets/theme.dart';
import '../../../core/widgets/common/curved_header.dart';
import 'dummy.dart';

class ClinicalNoteFormScreen extends StatefulWidget {
  final ClinicalNote? existing;
  const ClinicalNoteFormScreen({super.key, this.existing});

  @override
  State<ClinicalNoteFormScreen> createState() => _ClinicalNoteFormScreenState();
}

class _ClinicalNoteFormScreenState extends State<ClinicalNoteFormScreen> {
  // Vitals (slider-controlled)
  late double _height;
  late double _weight;
  late double _pulse;
  late double _temperature;

  // Text fields
  late final TextEditingController _diseaseComplaints;
  late final TextEditingController _allergies;
  late final TextEditingController _symptoms;
  late final TextEditingController _diagnosis;
  late final TextEditingController _causes;
  late final TextEditingController _investigation;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final n = widget.existing;
    _height = n?.height ?? 156;
    _weight = n?.weight ?? 55;
    _pulse = (n?.pulse ?? 80).toDouble();
    _temperature = n?.temperature ?? 98;

    _diseaseComplaints =
        TextEditingController(text: n?.diseaseComplaints ?? '');
    _allergies = TextEditingController(text: n?.allergies ?? '');
    _symptoms = TextEditingController(text: n?.symptoms ?? '');
    _diagnosis = TextEditingController(text: n?.diagnosis ?? '');
    _causes = TextEditingController(text: n?.causes ?? '');
    _investigation = TextEditingController(text: n?.investigation ?? '');
  }

  @override
  void dispose() {
    _diseaseComplaints.dispose();
    _allergies.dispose();
    _symptoms.dispose();
    _diagnosis.dispose();
    _causes.dispose();
    _investigation.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final note = ClinicalNote(
      id: widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      dateTime: widget.existing?.dateTime ?? DateTime.now(),
      height: _height,
      weight: _weight,
      pulse: _pulse.round(),
      temperature: _temperature,
      diseaseComplaints: _diseaseComplaints.text.trim(),
      allergies: _allergies.text.trim(),
      symptoms: _symptoms.text.trim(),
      diagnosis: _diagnosis.text.trim(),
      causes: _causes.text.trim(),
      investigation: _investigation.text.trim(),
    );
    Navigator.of(context).pop(note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors100.background,
      body: SafeArea(
        child: Column(
          children: [
            const CurvedHeader(title: 'CLINICAL NOTES'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    _sliderField(
                      label: 'Height',
                      value: _height,
                      min: 50,
                      max: 220,
                      display: '${_height.toStringAsFixed(1)}cm',
                      onChanged: (v) => setState(() => _height = v),
                    ),
                    const SizedBox(height: 12),
                    _sliderField(
                      label: 'Weight',
                      value: _weight,
                      min: 2,
                      max: 200,
                      display: '${_weight.toStringAsFixed(0)}kg',
                      onChanged: (v) => setState(() => _weight = v),
                    ),
                    const SizedBox(height: 12),
                    _sliderField(
                      label: 'Pulse',
                      value: _pulse,
                      min: 40,
                      max: 200,
                      display: '${_pulse.round()}/min',
                      onChanged: (v) => setState(() => _pulse = v),
                    ),
                    const SizedBox(height: 12),
                    _sliderField(
                      label: 'Temperature',
                      value: _temperature,
                      min: 90,
                      max: 110,
                      display: '${_temperature.toStringAsFixed(0)}c',
                      onChanged: (v) => setState(() => _temperature = v),
                    ),
                    const SizedBox(height: 16),
                    _multilineField(
                      controller: _diseaseComplaints,
                      hint: 'Disease Complaints',
                    ),
                    const SizedBox(height: 12),
                    _multilineField(
                      controller: _allergies,
                      hint: 'Allergies',
                    ),
                    const SizedBox(height: 12),
                    _multilineField(
                      controller: _symptoms,
                      hint: 'Symptoms',
                    ),
                    const SizedBox(height: 12),
                    _multilineField(
                      controller: _diagnosis,
                      hint: 'Diagnosis',
                    ),
                    const SizedBox(height: 12),
                    _multilineField(
                      controller: _causes,
                      hint: 'Causes',
                    ),
                    const SizedBox(height: 12),
                    _multilineField(
                      controller: _investigation,
                      hint: 'Investigation',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors100.cancelRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors100.submitBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _isEditing ? 'Update' : 'Submit',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sliderField({
    required String label,
    required double value,
    required double min,
    required double max,
    required String display,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      decoration: BoxDecoration(
        color: AppColors100.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors100.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors100.textPrimary,
                ),
              ),
              Text(
                display,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors100.primary,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors100.primary,
              inactiveTrackColor: AppColors100.fieldBorder,
              thumbColor: Colors.white,
              overlayColor: AppColors100.primary.withOpacity(0.15),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 11,
                elevation: 3,
              ),
              overlayShape:
              const RoundSliderOverlayShape(overlayRadius: 22),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _multilineField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      maxLines: 3,
      minLines: 3,
      style: const TextStyle(fontSize: 16, color: AppColors100.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors100.textHint, fontSize: 16),
        filled: true,
        fillColor: AppColors100.cardWhite,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors100.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors100.fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors100.primary, width: 1.5),
        ),
      ),
    );
  }
}
