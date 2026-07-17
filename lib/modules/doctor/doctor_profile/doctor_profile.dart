import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/title_Text_form_field.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class DoctorProfileScreen extends StatefulWidget {
  /// Doctor's gender — drives the dummy avatar ('male' or 'female').
  final String doctorGender;

  const DoctorProfileScreen({super.key, this.doctorGender = 'male'});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  File? _doctorImage;

  final nameController = TextEditingController(text: "Dr Mariappan");
  final specializationController =
      TextEditingController(text: "MBBS, General Physician");
  final phoneController = TextEditingController(text: "9876543210");
  final emailController = TextEditingController(text: "mariappan@timesmed.com");

  /// Gender-based dummy avatar (same image set as the patient module).
  String _doctorAvatar(String gender) {
    switch (gender.toLowerCase()) {
      case 'female':
        return 'assets/icons/gender/category/woman/adult_woman.png';
      case 'male':
      default:
        return 'assets/icons/gender/category/man/adult_man.png';
    }
  }

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
            backgroundImage: _doctorImage != null
                ? FileImage(_doctorImage!)
                : AssetImage(_doctorAvatar(widget.doctorGender)) as ImageProvider,
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
    final isFemale = widget.doctorGender.toLowerCase() == 'female';

    return Scaffold(
      backgroundColor: AppColors.background,
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
                border: Border.all(color: Colors.grey.shade300),
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
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// BADGES
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _badge("MBBS", AppColors.primary),
                            _badge(
                              isFemale ? "Female" : "Male",
                              isFemale ? Colors.pink : Colors.blue,
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// LOGOUT
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.doctorLogin),
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
                border: Border.all(color: Colors.grey.shade300),
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
                    title: "Specialization",
                    hintText: "Enter specialization",
                    controller: specializationController,
                    prefixIcon: const Icon(
                      Icons.medical_services_outlined,
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
                ],
              ),
            ),

            /// ACTION BUTTONS
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
                        context.push(AppRoutes.basicDetails);
                      },
                      child: const Text("Edit Profile",
                          style: TextStyle(fontSize: 12)),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Change password coming soon"),
                          ),
                        );
                      },
                      child: const Text(
                        "Change Password",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
