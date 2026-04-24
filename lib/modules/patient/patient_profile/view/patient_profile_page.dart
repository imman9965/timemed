import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/core/widgets/title_Text_form_field.dart';
import 'package:timesmed_project/modules/auth/controller/auth_controller.dart';
import 'package:timesmed_project/modules/patient/paient_home/controller/patient_home_controller.dart';
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
    return Column(
      children: [
        Container(
          height: 70,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: AppColors.primary,
          child: Center(
            child: Text(
              "Account",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  /// 🔥 TOP SECTION
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 8),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImagePicker(),

                        const SizedBox(width: 16),

                        /// RIGHT SIDE DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// NAME
                              Text(
                                nameController.text,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),

                              const SizedBox(height: 6),

                              /// GENDER + AGE
                              const Text(
                                "Male | Age: 30",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              /// LOGOUT BUTTON
                              SizedBox(
                                height: 35,
                                child: ElevatedButton(
                                  onPressed: () {
                                    authController
                                        .logout(); // 👈 your logout logic
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Logout"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// 🔥 FORM FIELDS

                  /// NAME FIELD
                  TitleTextFormField(
                    title: "First Name",
                    hintText: 'Enter your name',
                    controller: nameController,
                    borderRadius: 16,
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Color(0xff0673de),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),

                  const SizedBox(height: 16),

                  /// PHONE
                  TitleTextFormField(
                    title: "Phone",
                    hintText: 'Enter phone',
                    controller: phoneController,
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: Color(0xff0673de),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),

                  const SizedBox(height: 16),

                  /// EMAIL
                  TitleTextFormField(
                    title: "Email",
                    hintText: 'Enter email',
                    controller: emailController,
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Color(0xff0673de),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),

                  const SizedBox(height: 16),

                  /// PASSWORD
                  TitleTextFormField(
                    title: "Password",
                    hintText: 'Enter password',
                    controller: passwordController,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color(0xff0673de),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),

                  const SizedBox(height: 25),

                  /// SAVE BUTTON
                  CommonButton(
                    title: "Save",
                    borderRadius: 25,
                    width: 200,
                    onPressed: () {
                      // Save API call
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
