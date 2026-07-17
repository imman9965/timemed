import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/utils/datetime_helper.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/controller/medical_records_controller.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/model/medical_record_model.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class MedicalRecordsPage extends StatefulWidget {
  final MedicalRecordModel? initialRecord;
  const MedicalRecordsPage({super.key, this.initialRecord});

  @override
  State<MedicalRecordsPage> createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  final controller = Get.find<MedicalRecordsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(title: "Medical Records", showBack: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final records = widget.initialRecord != null
            ? controller.records
                .where((r) =>
                    r.patientName == widget.initialRecord!.patientName &&
                    r.doctorName == widget.initialRecord!.doctorName)
                .toList()
            : controller.records;

        if (records.isEmpty) {
          return const Center(child: Text("No records found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          itemCount: records.length,
          itemBuilder: (context, index) {
            return _timelineItem(records[index], index);
          },
        );
      }),
    );
  }

  /// 🔥 Improved Timeline Item
  Widget _timelineItem(MedicalRecordModel record, int index) {
    const isCompleted = true; // Based on your dummy data logic

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔵 Timeline
          Column(
            children: [
              Container(
                width: 2,
                height: index == 0 ? 0 : 20,
                color: Colors.grey.shade300,
              ),
              Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(child: Container(width: 2, color: Colors.grey.shade300)),
            ],
          ),

          const SizedBox(width: 14),

          /// 📦 Premium Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 TOP ROW (Patient + Status)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: Icon(Icons.person, color: AppColors.primary),
                      ),

                      const SizedBox(width: 12),

                      /// Patient + Doctor
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.patientName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${record.doctorName} (${record.speciality})",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Status
                      _statusChip(isCompleted),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// 🔹 DATE + TIME
                  Row(
                    children: [
                      _detailBlock(Icons.calendar_today, DateTimeHelper.formatToLongDate(record.date)),
                      const SizedBox(width: 12),
                      _detailBlock(Icons.access_time, record.time),
                      const SizedBox(width: 12),
                      _detailBlock(Icons.fingerprint, "#${record.visitId}"),
                    ],
                  ),

                  if (record.diagnosis.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(Icons.assignment_turned_in_outlined, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "Diagnosis: ${record.diagnosis}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 14),

                  /// 🔹 DATA INDICATORS
                  Row(
                    children: [
                      _dataIndicator(
                        Icons.medication_outlined,
                        record.prescriptions.isNotEmpty,
                        "Prescription",
                      ),
                      const SizedBox(width: 8),
                      _dataIndicator(
                        Icons.science_outlined,
                        record.labTests.isNotEmpty,
                        "Lab Test",
                      ),
                      const SizedBox(width: 8),
                      _dataIndicator(
                        Icons.note_alt_outlined,
                        record.notes.isNotEmpty,
                        "Notes",
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.push(AppRoutes.patientMedicalRecordDetail, extra: record);
                      },
                      child: const Text(
                        "Medical Record Details",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailBlock(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _dataIndicator(IconData icon, bool exists, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: exists ? AppColors.primary.withValues(alpha: 0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: exists ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                size: 16,
                color: exists ? AppColors.primary : Colors.grey.shade400,
              ),
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: exists ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Icon(
                    exists ? Icons.check : Icons.close,
                    size: 8,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: exists ? Colors.black87 : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Status Chip
  Widget _statusChip(bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isCompleted ? "Completed" : "Cancelled",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isCompleted ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
