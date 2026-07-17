import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/sapce.dart';
import 'package:timesmed_project/core/widgets/selection_card.dart';
import 'package:timesmed_project/core/widgets/title_Text_form_field.dart';
import 'package:timesmed_project/modules/patient/patient_signup/controller/patient_signup_controller.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientSignupPage extends StatefulWidget {
  PatientSignupPage({super.key});

  @override
  State<PatientSignupPage> createState() => _PatientSignupPageState();
}

class _PatientSignupPageState extends State<PatientSignupPage>
    with SingleTickerProviderStateMixin {
  final patientSignUPController = Get.find<PatientSignupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CommonAppBar(title: "SignUp"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TitleTextFormField(
                      title: "First Name",
                      hintText: 'Enter your name',
                      controller: patientSignUPController.nameController,
                      borderRadius: 16,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color(0xff0673de),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ],
              ),

              const Space(height: 14),

              TitleTextFormField(
                title: "Email Address",
                hintText: 'your.email@example.com',
                controller: patientSignUPController.emailController,
                prefixIcon: const Icon(
                  Icons.mail_outline,
                  color: Color(0xff0673de),
                ),
                borderRadius: 16,
                fillColor: Colors.white,
                filled: true,
              ),

              const Space(height: 14),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TitleTextFormField(
                      title: "Mobile Number",
                      hintText: 'Your phone number',
                      controller: patientSignUPController.phoneNumberController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: Color(0xff0673de),
                      ),
                      borderRadius: 16,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ],
              ),

              const Space(height: 24),

              Row(
                children: [
                  Expanded(
                    child: TitleTextFormField(
                      title: "Date of Birth",
                      hintText: 'DD/MM/YYYY',
                      controller: patientSignUPController.dobController,
                      prefixIcon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xff0673de),
                      ),
                      borderRadius: 16,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TitleTextFormField(
                      title: "Age",
                      hintText: 'Your age',
                      controller: patientSignUPController.ageController,
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(
                        Icons.cake_outlined,
                        color: Color(0xff0673de),
                      ),
                      borderRadius: 16,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ],
              ),

              const Space(height: 20),

              /// GENDER SECTION
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Gender",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SelectionCard(
                        label: "Male",
                        icon: Icons.male,
                        isSelected:
                            patientSignUPController.selectedGender == "Male",
                        onTap: () {
                          setState(
                            () => patientSignUPController.selectedGender.value =
                                "Male",
                          );
                        },
                      ),
                      SelectionCard(
                        label: "Female",
                        icon: Icons.female,
                        isSelected:
                            patientSignUPController.selectedGender == "Female",
                        onTap: () {
                          setState(
                            () => patientSignUPController.selectedGender.value =
                                "Female",
                          );
                        },
                      ),
                      SelectionCard(
                        label: "Other",
                        icon: Icons.more_horiz,
                        isSelected:
                            patientSignUPController.selectedGender == "Others",
                        onTap: () {
                          setState(
                            () => patientSignUPController.selectedGender.value =
                                "Others",
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const Space(height: 20),

              /// MARITAL STATUS SECTION
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Marital Status",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SelectionCard(
                        label: "Single",
                        icon: Icons.favorite_border,
                        isSelected:
                            patientSignUPController.selectedMaterialStatus ==
                            "Single",
                        onTap: () {
                          setState(
                            () =>
                                patientSignUPController
                                        .selectedMaterialStatus
                                        .value =
                                    "Single",
                          );
                        },
                      ),
                      SelectionCard(
                        label: "Married",
                        icon: Icons.favorite,
                        isSelected:
                            patientSignUPController.selectedMaterialStatus ==
                            "Married",
                        onTap: () {
                          setState(
                            () =>
                                patientSignUPController
                                        .selectedMaterialStatus
                                        .value =
                                    "Married",
                          );
                        },
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ),

              const Space(height: 24),

              TitleTextFormField(
                title: "Password",
                hintText: 'Create a strong password',
                controller: patientSignUPController.passwordController,
                obscureText: true,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Color(0xff0673de),
                ),
                borderRadius: 16,
                fillColor: Colors.white,
                filled: true,
              ),

              const Space(height: 14),

              TitleTextFormField(
                title: "Confirm Password",
                hintText: 'Confirm your password',
                controller: patientSignUPController.confirmPasswordController,
                obscureText: true,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Color(0xff0673de),
                ),
                borderRadius: 16,
                fillColor: Colors.white,
                filled: true,
              ),

              const SizedBox(height: 28),

              /// REGISTER BUTTON
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff0673de), Color(0xff2f6f7e)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff0673de).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      context.go(AppRoutes.patientLogin);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// LOGIN SECTION
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go(AppRoutes.patientLogin);
                      },
                      child: const Text(
                        "Login Now",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff0673de),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff0673de), Color(0xff2f6f7e)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
