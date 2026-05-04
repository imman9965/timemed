import 'package:flutter/material.dart';
import 'package:timesmed_project/modules/doctor/widgets/theme.dart';
import '../../../core/widgets/common/curved_header.dart';
import 'dummy.dart';


class ClinicalNoteDetailScreen extends StatelessWidget {
  final ClinicalNote note;
  const ClinicalNoteDetailScreen({super.key, required this.note});

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vitals row 1
                    Row(
                      children: [
                        Expanded(
                          child: _vitalCard(
                            icon: Icons.height,
                            label: 'Height',
                            value: '${note.height.toStringAsFixed(0)} cm',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _vitalCard(
                            icon: Icons.monitor_weight_outlined,
                            label: 'Weight',
                            value: '${note.weight.toStringAsFixed(0)} kg',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Vitals row 2
                    Row(
                      children: [
                        Expanded(
                          child: _vitalCard(
                            icon: Icons.favorite_outline,
                            label: 'Pulse',
                            value: '${note.pulse} /min',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _vitalCard(
                            icon: Icons.thermostat_outlined,
                            label: 'Temperature',
                            value: '${note.temperature.toStringAsFixed(0)} c',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _readOnlyField('Disease Complaints', note.diseaseComplaints),
                    const SizedBox(height: 12),
                    _readOnlyField('Allergies', note.allergies),
                    const SizedBox(height: 12),
                    _readOnlyField('Symptoms', note.symptoms),
                    const SizedBox(height: 12),
                    _readOnlyField('Diagnosis', note.diagnosis),
                    const SizedBox(height: 12),
                    _readOnlyField('Causes', note.causes),
                    const SizedBox(height: 12),
                    _readOnlyField('Investigation', note.investigation),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vitalCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors100.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors100.fieldBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors100.iconBlueSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors100.iconBlue, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors100.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors100.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors100.cardWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors100.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors100.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (value.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors100.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
