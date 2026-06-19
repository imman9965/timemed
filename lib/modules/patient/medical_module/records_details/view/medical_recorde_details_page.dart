import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/utils/datetime_helper.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/modules/patient/medical_module/cart/controller/cart_controller.dart';
import 'package:timesmed_project/modules/patient/medical_module/records_details/controller/midical_record_details_controller.dart';
import 'package:timesmed_project/modules/patient/medical_module/records_details/utils/medical_pdf_helper.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/model/medical_record_model.dart';
import 'package:timesmed_project/routes/app_routes.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';

class MedicalRecordDetailsPage extends StatelessWidget {
  const MedicalRecordDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedicalRecordsDetailsController>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xffF8FAFD),
        appBar: CommonAppBar(title: "Medical Records"),

        /// 🔘 BOTTOM ACTIONS
        bottomNavigationBar: Obx(() {
          final record = controller.selectedRecord.value;

          return Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: record != null
                            ? () {
                                final cartController = Get.put(CartController());
                                cartController.setCartItems(record.prescriptions);
                                context.push(AppRoutes.patientMedicineCart);
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Add Prescription",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          final labTests = controller.selectedRecord.value?.labTests;
                          if (labTests != null && labTests.isNotEmpty) {
                            context.push(
                              AppRoutes.patientLabTestDetails,
                              extra: labTests,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Book Lab Test",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final record = controller.selectedRecord.value;

          if (record == null) {
            return const Center(child: Text("No Records Found"));
          }

          return Column(
            children: [
              /// 🔹 MINIMIZED HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.person, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.patientName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff2C3E50),
                              ),
                            ),
                            Text(
                              "${record.doctorName} | ${record.speciality}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            DateTimeHelper.formatToLongDate(record.date),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            "#${record.visitId}",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// 🔘 TAB BAR
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: AppColors.white,
                  unselectedLabelColor: Colors.grey.shade600,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: const EdgeInsets.all(4),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  tabs: const [
                    Tab(text: "Prescription"),
                    Tab(text: "Lab Tests"),
                    Tab(text: "Remarks"),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              /// 🔹 TAB CONTENT
              Expanded(
                child: TabBarView(
                  children: [
                    /// TAB 1: PRESCRIPTION
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _sectionLabel("Medical Prescription"),
                              _actionChip(
                                "Download",
                                Icons.download_rounded,
                                () async {
                                  final bytes = await MedicalPdfHelper.generatePrescriptionPdf(record);
                                  await MedicalPdfHelper.saveAndOpenPdf(bytes, "Prescription_${record.visitId}");
                                },
                                AppColors.primary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (record.prescriptions.isEmpty)
                            _emptyState("No prescriptions recorded", Icons.medication_outlined)
                          else
                            _prescriptionTable(record.prescriptions),
                        ],
                      ),
                    ),

                    /// TAB 2: LAB TESTS
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _sectionLabel("Clinical Lab Tests"),
                              if (record.labTests.isNotEmpty)
                                _actionChip(
                                  "View Report",
                                  Icons.article_outlined,
                                  () async {
                                    final bytes = await MedicalPdfHelper.generateLabReportPdf(record);
                                    await MedicalPdfHelper.saveAndOpenPdf(bytes, "Lab_Report_${record.visitId}");
                                  },
                                  Colors.teal,
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (record.labTests.isEmpty)
                            _emptyState("No lab investigations", Icons.science_outlined)
                          else
                            _labTestTable(record.labTests),
                        ],
                      ),
                    ),

                    /// TAB 3: REMARKS
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel("Medical Notes / Remarks"),
                          const SizedBox(height: 10),
                          if (record.notes.isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                record.notes,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                  height: 1.4,
                                ),
                              ),
                            )
                          else
                            _emptyState("No medical remarks", Icons.note_alt_outlined),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xff34495E),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _prescriptionTable(List<PrescriptionItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2.5),
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(1),
          },
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade50),
              children: [
                _tableHeader("Medicine Name"),
                _tableHeader("Frequency"),
                _tableHeader("Days"),
              ],
            ),
            ...items.map((p) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.medicineName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff2C3E50),
                            ),
                          ),
                          if (p.instructions.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                p.instructions,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    _tableCell(p.frequency),
                    _tableCell("${p.days}"),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _labTestTable(List<LabTest> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
          },
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade50),
              children: [
                _tableHeader("Test Name"),
                _tableHeader("Category"),
              ],
            ),
            ...items.map((lab) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lab.testName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff2C3E50),
                            ),
                          ),
                          if (lab.instructions.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "Prep: ${lab.instructions}",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blueGrey.shade400,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    _tableCell(lab.category),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader(String label) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _tableCell(String value) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xff34495E),
        ),
      ),
    );
  }

  Widget _actionChip(String label, IconData icon, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String message, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, color: Colors.grey.shade200, size: 28),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: Colors.white, size: 8),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
