import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common/curved_header.dart';
import '../../../core/widgets/common/pill_button.dart';
import '../../../core/widgets/common/primary_card.dart';

// ─── Data Models ────────────────────────────────────────────────────────────

class PatientInfo {
  final String name;
  final String date;
  final String time;
  final String doctor;
  final String visitId;

  const PatientInfo({
    required this.name,
    required this.date,
    required this.time,
    required this.doctor,
    required this.visitId,
  });
}

class PrescriptionItem {
  final String name;
  final String instruction;
  final String dosage;
  final String dosageSub;
  final String days;

  const PrescriptionItem({
    required this.name,
    required this.instruction,
    required this.dosage,
    required this.dosageSub,
    required this.days,
  });
}

class LabTestItem {
  final String category;
  final String testName;
  final String instructions;

  const LabTestItem({
    required this.category,
    required this.testName,
    required this.instructions,
  });
}

class HealthRecordItem {
  final String title;
  final String fileName;

  const HealthRecordItem({
    required this.title,
    required this.fileName,
  });
}

// ─── Static Data ─────────────────────────────────────────────────────────────

const _patient = PatientInfo(
  name: 'Mr. Andrew',
  date: '1/7/2026',
  time: '12:20 PM',
  doctor: 'DR.MARIAPPAN',
  visitId: '258351',
);

const _prescriptions = [
  PrescriptionItem(
    name: 'PARACIP 500MG TABLET',
    instruction: 'Instruction: After Meal',
    dosage: '1-1-0-1,',
    dosageSub: '1tablet',
    days: 'Days: 02',
  ),
  PrescriptionItem(
    name: 'VITAMIN E',
    instruction: 'Instruction: store in cool place',
    dosage: '1-0-0-1,',
    dosageSub: '2 Drops',
    days: 'Days: 04',
  ),
];

const _labTests = [
  LabTestItem(
    category: 'X RAY',
    testName: 'CHEST XRAY',
    instructions: 'Test',
  ),
];

const _healthRecords = [
  HealthRecordItem(
    title: 'Health Records',
    fileName: 'D330.Png',
  ),
];

const _doctorNote = 'Follow The Above Mentioned Drugs For 5 Days';

// ─── Screen ──────────────────────────────────────────────────────────────────

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({Key? key}) : super(key: key);

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  @override
  void initState() {
    super.initState();
    print("Screen initialized");
  }

  @override
  void dispose() {
    print("Screen disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const CurvedHeader(title: 'Medical Records'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.screenHPadding,
                AppDimens.l,
                AppDimens.screenHPadding,
                AppDimens.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPatientCard(_patient),
                  const SizedBox(height: AppDimens.l),
                  _buildSectionHeader('Prescription', onPrint: () {}),
                  const SizedBox(height: AppDimens.m),

                  // ── Prescriptions iterated ──────────────────────────────
                  ..._prescriptions.map((rx) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimens.m),
                    child: _buildPrescriptionCard(rx),
                  )),

                  const SizedBox(height: AppDimens.xl),
                  _buildDoctorNotes(_doctorNote),
                  const SizedBox(height: AppDimens.xl),
                  _buildSectionHeader('Lab Test', onPrint: () {}),
                  const SizedBox(height: AppDimens.m),

                  // ── Lab tests iterated ──────────────────────────────────
                  ..._labTests.map((test) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimens.m),
                    child: _buildLabTest(test),
                  )),

                  const SizedBox(height: AppDimens.xl),
                  Text('Health Records', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: AppDimens.m),

                  // ── Health records iterated ─────────────────────────────
                  ..._healthRecords.map((record) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimens.m),
                    child: _buildHealthRecord(record),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Widgets ──────────────────────────────────────────────────────────────

  Widget _buildPatientCard(PatientInfo patient) {
    return PrimaryCard(
      padding: const EdgeInsets.all(AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFFE0E0E0),
                child: Icon(Icons.person, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(patient.name, style: AppTextStyles.bodyBold),
            ],
          ),
          const Divider(height: 24, color: AppColors.dividerColor),
          Row(
            children: [
              const Icon(Icons.calendar_month,
                  size: 18, color: AppColors.primaryBlue),
              const SizedBox(width: 6),
              Text(patient.date, style: AppTextStyles.body),
              const SizedBox(width: 24),
              const Icon(Icons.access_time,
                  size: 18, color: AppColors.primaryBlue),
              const SizedBox(width: 6),
              Text(patient.time, style: AppTextStyles.body),
              const Spacer(),
              Text(
                patient.doctor,
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Visit ID : ${patient.visitId}', style: AppTextStyles.body),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onPrint}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        PillButton.green(
          label: 'Print',
          icon: Icons.print,
          onPressed: onPrint,
        ),
      ],
    );
  }

  Widget _buildPrescriptionCard(PrescriptionItem rx) {
    return PrimaryCard(
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rx.name, style: AppTextStyles.bodyBold),
                const SizedBox(height: 4),
                Text(rx.instruction, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rx.dosage, style: AppTextStyles.bodyBold),
                const SizedBox(height: 4),
                Text(rx.dosageSub,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(rx.days, style: AppTextStyles.bodyBold),
        ],
      ),
    );
  }

  Widget _buildDoctorNotes(String note) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.l),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Doctor Notes',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.white54, height: 1),
          ),
          Text(
            note,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildLabTest(LabTestItem test) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            test.category,
            style: AppTextStyles.bodyBold.copyWith(
              color: AppColors.accentGreen,
            ),
          ),
          const Divider(height: 16, color: AppColors.dividerColor),
          RichText(
            text: TextSpan(
              style: AppTextStyles.body,
              children: [
                const TextSpan(
                  text: 'Test Name: ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: test.testName),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: AppTextStyles.body,
              children: [
                const TextSpan(
                  text: 'Instructions: ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: test.instructions,
                  style: const TextStyle(color: AppColors.primaryBlue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthRecord(HealthRecordItem record) {
    return PrimaryCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.health_and_safety,
                color: AppColors.accentGreen, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${record.title}\n${record.fileName}',
              style: AppTextStyles.bodyBold,
            ),
          ),
          _circleIconButton(Icons.remove_red_eye, AppColors.primaryBlue),
          const SizedBox(width: 8),
          _circleIconButton(
              Icons.arrow_downward_rounded, AppColors.accentGreen),
          const SizedBox(width: 8),
          _circleIconButton(Icons.delete_outline, AppColors.accentRed),
        ],
      ),
    );
  }

  Widget _circleIconButton(IconData icon, Color color) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}