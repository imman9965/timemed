import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/core/widgets/sapce.dart';
import 'package:timesmed_project/core/widgets/title_Text_form_field.dart';
import 'package:timesmed_project/modules/auth/controller/auth_controller.dart';
import 'package:timesmed_project/modules/patient/patient_home/controller/patient_home_controller.dart';
import 'package:timesmed_project/routes/app_routes.dart';
// import your TitleTextFormField

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  final patientHomeController = Get.find<PatientHomeController>();
  final authController = Get.find<AuthController>();

  File? _patientImage;

  /// Dummy controllers (replace with your actual ones)
  final nameController = TextEditingController(text: "Andrew Vijay");
  final phoneController = TextEditingController(text: "8056567194");
  final emailController = TextEditingController(text: "vijayguru173@gmail.com");
  final passwordController = TextEditingController(text: "********");

  /// IMAGE PICK FUNCTION (you said already exists)
  Future<void> _pickImage() async {
    // your existing logic
  }

  /// IMAGE PICKER UI
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _patientImage != null
                ? FileImage(_patientImage!)
                : null,
            child: _patientImage == null
                ? const Icon(Icons.person, size: 40, color: Colors.grey)
                : null,
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Account", showBack: false),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 18),

            /// PREMIUM PROFILE CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),

                border: Border.all(color: AppColors.primary.withOpacity(0.08)),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PROFILE IMAGE
                  _buildImagePicker(),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// NAME
                        Text(
                          nameController.text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// PATIENT BADGE
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "Male",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "Age 30",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// LOGOUT
                        GestureDetector(
                          onTap: authController.logout,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.logout_rounded,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// DETAILS CARD
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),

                border: Border.all(color: Colors.grey.withOpacity(0.08)),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Column(
                children: [
                  TitleTextFormField(
                    title: "Full Name",
                    hintText: "Enter your name",
                    controller: nameController,
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.primary,
                    ),
                    fillColor: const Color(0xffF8FAFC),
                    filled: true,
                  ),

                  const SizedBox(height: 16),

                  TitleTextFormField(
                    title: "Phone",
                    hintText: "Enter phone",
                    controller: phoneController,
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.primary,
                    ),
                    fillColor: const Color(0xffF8FAFC),
                    filled: true,
                  ),

                  const SizedBox(height: 16),

                  TitleTextFormField(
                    title: "Email",
                    hintText: "Enter email",
                    controller: emailController,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.primary,
                    ),
                    fillColor: const Color(0xffF8FAFC),
                    filled: true,
                  ),

                  const SizedBox(height: 16),

                  TitleTextFormField(
                    title: "Password",
                    hintText: "Enter password",
                    controller: passwordController,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.primary,
                    ),
                    fillColor: const Color(0xffF8FAFC),
                    filled: true,
                  ),
                ],
              ),
            ),

            /// KEEP YOUR BUTTONS SAME
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.push(AppRoutes.addPatient);
                      },
                      child: const Text("Edit Profile"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.push(AppRoutes.patientForgotPassword);
                      },
                      child: const Text("Change Password"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
