import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/doctor_theme.dart';
import '../../../core/widgets/common/curved_header.dart';
import '../../../core/widgets/common/pill_button.dart';
import '../../../core/widgets/common/primary_card.dart';


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
    dosageSub: '1 tablet',
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
      backgroundColor: DoctorColors.backgroundWarm,
      body: Column(
        children: [
          const CurvedHeader(title: 'MEDICAL RECORDS',titleStyle: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                DoctorSpacing.lg,
                DoctorSpacing.lg,
                DoctorSpacing.lg,
                DoctorSpacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPatientCard(_patient),
                  const SizedBox(height: DoctorSpacing.lg),
                  _buildSectionHeader('Prescription', onPrint: () {}),
                  const SizedBox(height: DoctorSpacing.md),

                  // ── Prescriptions iterated ──────────────────────────────
                  ..._prescriptions.map((rx) => Padding(
                    padding: const EdgeInsets.only(bottom: DoctorSpacing.md),
                    child: _buildPrescriptionCard(rx),
                  )),

                  const SizedBox(height: DoctorSpacing.xl),
                  _buildDoctorNotes(_doctorNote),
                  const SizedBox(height: DoctorSpacing.xl),
                  _buildSectionHeader('Lab Test', onPrint: () {}),
                  const SizedBox(height: DoctorSpacing.md),

                  // ── Lab tests iterated ──────────────────────────────────
                  ..._labTests.map((test) => Padding(
                    padding: const EdgeInsets.only(bottom: DoctorSpacing.md),
                    child: _buildLabTest(test),
                  )),

                  const SizedBox(height: DoctorSpacing.xl),
                  Text('Health Records', style: DoctorTextStyles.sectionTitleLarge),
                  const SizedBox(height: DoctorSpacing.md),

                  // ── Health records iterated ─────────────────────────────
                  ..._healthRecords.map((record) => Container(
                    // padding: const EdgeInsets.only(bottom: DoctorSpacing.md),
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
      radius: 18,
      padding: EdgeInsets.only(top: 14,bottom: 14,right: 14,left: 14),

      // padding: const EdgeInsets.all(DoctorSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundColor: DoctorColors.dividerNeutral,
                child: Icon(Icons.person, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(patient.name, style: DoctorTextStyles.titleBody),
            ],
          ),
          const Divider(height: 24, color: DoctorColors.divider),
          Row(
            spacing: 24,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month,
                      size: 18, color: DoctorColors.primaryBrand),
                  const SizedBox(width: 6),
                  Text(patient.date, style: DoctorTextStyles.titleBody),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 18, color: DoctorColors.primaryBrand),
                  Text(patient.time, style: DoctorTextStyles.titleBody),

                ],
              ),
              Row(
                children: [
                  Text(
                      patient.doctor,
                      style: DoctorTextStyles.titleBodyBlue
                  ),
                ],
              )



              // const SizedBox(width: 6),

            ],
          ),
          const SizedBox(height: 10),
          Text('Visit ID : ${patient.visitId}', style: DoctorTextStyles.titleBody),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onPrint}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: DoctorTextStyles.sectionTitleLarge),
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
      radius: 8,
      padding: EdgeInsets.only(top: 14,bottom: 14,right: 8,left: 8),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rx.name, style: DoctorTextStyles.titleBody),
                const SizedBox(height: 4),
                Text(rx.instruction, style: DoctorTextStyles.titleBody),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rx.dosage, style: DoctorTextStyles.titleBody),
                const SizedBox(height: 4),
                Text(rx.dosageSub,
                    style: DoctorTextStyles.titleBody),
              ],
            ),
          ),
          Text(rx.days, style: DoctorTextStyles.titleBody),
        ],
      ),
    );
  }

  Widget _buildDoctorNotes(String note) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 10,bottom: 10,right: 10,left: 10),
      decoration: BoxDecoration(
        color: DoctorColors.primaryBrand,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Doctor Notes',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.white54, height: 1),
          ),
          Text(
            note,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildLabTest(LabTestItem test) {
    return PrimaryCard(
      radius: 8,
      padding: EdgeInsets.only(top: 14,bottom: 14,right: 8,left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            test.category,
            style: DoctorTextStyles.titleBody
          ),
          const Divider(height: 16, color: DoctorColors.divider),
          RichText(
            text: TextSpan(
              style: DoctorTextStyles.titleBody,
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
              style: DoctorTextStyles.titleBody,
              children: [
                const TextSpan(
                  text: 'Instructions: ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: test.instructions,
                  style: const TextStyle(color: DoctorColors.primaryBrand),
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
      radius: 8,
      padding: EdgeInsets.only(top: 14,bottom: 14,right: 8,left: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: DoctorColors.successMint.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.health_and_safety,
                color: DoctorColors.successMint, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${record.title}\n${record.fileName}',
              style: DoctorTextStyles.titleBody,
            ),
          ),
          _circleIconButton(Icons.remove_red_eye, DoctorColors.primaryBrand,),
          const SizedBox(width: 8),
          _circleIconButton(
              Icons.arrow_downward_rounded, DoctorColors.successMint),
          const SizedBox(width: 8),
          _circleIconButton(Icons.delete_outline, DoctorColors.error),
        ],
      ),
    );
  }

  Widget _circleIconButton(IconData icon, Color color) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black54,
          builder: (context) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: DoctorColors.medicalNavy,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child:  Icon(Icons.medical_services_sharp, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PATIENT FILE",
                                  style: TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 1.2,
                                    color: Colors.white60,
                                  ),
                                ),
                                Text(
                                  "Health Record",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 15),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:  DoctorColors.medicalBlueMed,
                              child: const Text(
                                "JD",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: DoctorColors.medicalBlueSoft,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "John Doe",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "29 yrs · O+ Blood Group",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Body
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "VITALS",
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.2,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _vitalCard(Icons.monitor_heart, "Heart rate", "78", "bpm", DoctorColors.error)),
                            const SizedBox(width: 10),
                            Expanded(child: _vitalCard(Icons.show_chart, "Blood pressure", "120", "/80", DoctorColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "DIAGNOSIS",
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.2,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color:  DoctorColors.errorPink,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.coronavirus_outlined, color: DoctorColors.errorDeep, size: 22),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mild Fever",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: DoctorColors.errorDeeper,
                                    ),
                                  ),
                                  Text(
                                    "Under observation · Low severity",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: DoctorColors.errorDeep,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: DoctorColors.medicalNavy,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.check, color: Colors.white, size: 18),
                            label: const Text(
                              "Done",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _vitalCard(IconData icon, String label, String value, String unit, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: DoctorColors.inputBgSoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: iconColor),
              const SizedBox(width: 5),
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.black45)),
            ],
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                TextSpan(
                  text: unit,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Widget _circleIconButton(
//     BuildContext context,
//     IconData icon,
//     Color color,
//     ) {
//   return GestureDetector(
//     onTap: () {
//
//     },
//     child: Container(
//       width: 34,
//       height: 34,
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         icon,
//         color: Colors.white,
//         size: 18,
//       ),
//     ),
//   );
// }

Widget _recordTile(String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DoctorColors.inputBgSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}