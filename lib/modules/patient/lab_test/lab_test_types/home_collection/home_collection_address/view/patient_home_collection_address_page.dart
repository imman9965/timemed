import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/model/medical_record_model.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientHomeCollectionAddressPage extends StatefulWidget {
  final LabTest labTest;
  final String selectedDate;
  final String selectedTime;

  const PatientHomeCollectionAddressPage({
    super.key,
    required this.labTest,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  State<PatientHomeCollectionAddressPage> createState() =>
      _PatientHomeCollectionAddressPageState();
}

class _PatientHomeCollectionAddressPageState
    extends State<PatientHomeCollectionAddressPage> {
  final nameController = TextEditingController(text: "Mr. Vignesh");

  final mobileController = TextEditingController(
    text: "9876543210",
  );

  final addressController = TextEditingController(
    text: "No.12, Anna Nagar West, Chennai",
  );

  final landmarkController = TextEditingController(
    text: "Near Metro Station",
  );

  final pincodeController = TextEditingController(
    text: "600040",
  );

  String selectedAddressType = "Home";

  @override
  Widget build(BuildContext context) {
    final test = widget.labTest;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: CommonAppBar(
        title: "Collection Address",
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.05),
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                context.push(
                  AppRoutes.patientHomeCollectionCheckout,
                  extra: {
                    "labTest": test,
                    "selectedDate": widget.selectedDate,
                    "selectedTime": widget.selectedTime,
                    "name": nameController.text,
                    "mobile": mobileController.text,
                    "address": addressController.text,
                    "landmark": landmarkController.text,
                    "pincode": pincodeController.text,
                    "addressType": selectedAddressType,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                "Continue To Payment",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 SLOT SUMMARY CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(.82),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.14),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.home_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              test.testName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              test.category,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _topInfoTile(
                          Icons.calendar_month,
                          widget.selectedDate,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _topInfoTile(
                          Icons.access_time,
                          widget.selectedTime,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 🔹 ADDRESS FORM
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                    color: Colors.black.withOpacity(.04),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Patient Details",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 18),

                  _textField(
                    controller: nameController,
                    hint: "Patient Name",
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 16),

                  _textField(
                    controller: mobileController,
                    hint: "Mobile Number",
                    icon: Icons.call_outlined,
                    keyboard: TextInputType.phone,
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Collection Address",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 18),

                  _textField(
                    controller: addressController,
                    hint: "Full Address",
                    icon: Icons.location_on_outlined,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 16),

                  _textField(
                    controller: landmarkController,
                    hint: "Landmark",
                    icon: Icons.place_outlined,
                  ),

                  const SizedBox(height: 16),

                  _textField(
                    controller: pincodeController,
                    hint: "Pincode",
                    icon: Icons.pin_outlined,
                    keyboard: TextInputType.number,
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    "Address Type",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _addressTypeCard(
                          title: "Home",
                          icon: Icons.home_outlined,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _addressTypeCard(
                          title: "Office",
                          icon: Icons.work_outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _topInfoTile(
      IconData icon,
      String value,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.14),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xffF7F8FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _addressTypeCard({
    required String title,
    required IconData icon,
  }) {
    final isSelected = selectedAddressType == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddressType = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primary
                  : Colors.grey.shade700,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppColors.primary
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}