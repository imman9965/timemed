import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/modules/patient/medical_module/cart/controller/cart_controller.dart';
import 'package:timesmed_project/modules/patient/medical_module/records_details/controller/midical_record_details_controller.dart';
import 'package:timesmed_project/routes/app_routes.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';

class MedicalRecordDetailsPage extends StatelessWidget {
  const MedicalRecordDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedicalRecordsDetailsController>();

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      appBar: CommonAppBar(title: "Medical Records"),

      /// PREMIUM BOTTOM CTA
      bottomNavigationBar: Obx(() {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(0.06),
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: controller.hasSelection
                    ? () {
                        final cartController = Get.put(CartController());

                        final selectedItems = controller
                            .selectedRecord
                            .value!
                            .prescriptions
                            .where(
                              (p) =>
                                  controller.selectedIds.contains(p.medicineId),
                            )
                            .toList();

                        cartController.setCartItems(selectedItems);

                        context.push(AppRoutes.patientMedicineCart);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Add Selected to Cart",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 HEADER CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: AppColors.primary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            record.patientName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          record.date,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.local_hospital, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            record.doctorName,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            record.visitId,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 PRESCRIPTION
              _title("Prescription"),

              const SizedBox(height: 10),

              ...record.prescriptions.map((p) {
                final isSelected = controller.isSelected(p.medicineId);

                return GestureDetector(
                  onTap: () => controller.toggleMedicine(p.medicineId),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.08)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade200,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isSelected ? AppColors.primary : Colors.grey,
                        ),
                        const SizedBox(width: 10),

                        /// DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.medicineName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${p.frequency} • ${p.days} days",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                p.instructions,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),

                        /// PRICE
                        Text(
                          "₹${p.price}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              /// 🔹 NOTES
              if (record.notes.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(child: Text(record.notes)),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              /// LAB TESTS
              /// 🔬 LAB TESTS
              if (record.labTests.isNotEmpty) ...[
                const SizedBox(height: 26),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _sectionTitle("Lab Tests"),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(.08),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "${record.labTests.length} Tests",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                ...record.labTests.map((lab) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.grey.shade100,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 24,
                          spreadRadius: 0,
                          offset: const Offset(0, 10),
                          color: Colors.black.withOpacity(.04),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        /// 🔹 TOP SECTION
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// ICON
                              Container(
                                height: 62,
                                width: 62,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(.08),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.science_rounded,
                                  color: AppColors.primary,
                                  size: 30,
                                ),
                              ),

                              const SizedBox(width: 16),

                              /// DETAILS
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lab.testName,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -.2,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                            AppColors.primary.withOpacity(.08),
                                            borderRadius:
                                            BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            lab.category,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 8),

                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(.08),
                                            borderRadius:
                                            BorderRadius.circular(30),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.verified,
                                                size: 13,
                                                color: Colors.green,
                                              ),

                                              SizedBox(width: 4),

                                              Text(
                                                "Certified",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 14),

                                    Text(
                                      lab.instructions,
                                      style: TextStyle(
                                        fontSize: 13,
                                        height: 1.6,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// DIVIDER
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            height: 1,
                            color: Colors.grey.shade100,
                          ),
                        ),

                        /// 🔹 FEATURES
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _premiumFeature(
                                icon: Icons.home_outlined,
                                title: "Home Collection",
                              ),

                              _premiumFeature(
                                icon: Icons.location_on_outlined,
                                title: "Visit Lab",
                              ),

                              _premiumFeature(
                                icon: Icons.bolt_outlined,
                                title: "Fast Reports",
                              ),

                              _premiumFeature(
                                icon: Icons.workspace_premium_outlined,
                                title: "NABL Certified",
                              ),
                            ],
                          ),
                        ),

                        /// 🔹 BOTTOM ACTIONS
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Row(
                            children: [
                              /// INFO BUTTON
                              Container(
                                height: 54,
                                width: 54,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(18),
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.article_outlined,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 14),

                              /// BOOK BUTTON
                              Expanded(
                                child: SizedBox(
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.push(
                                        AppRoutes.patientLabTestDetails,
                                        extra: lab,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Book Lab Test",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),

                                        SizedBox(width: 10),

                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _premiumFeature({
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),

          const SizedBox(width: 8),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }



  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
