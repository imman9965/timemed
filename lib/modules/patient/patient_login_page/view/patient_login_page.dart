import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/constants/sapce.dart';
import 'package:timesmed_project/core/constants/title_Text_form_field.dart';
import 'package:timesmed_project/modules/patient/patient_login_page/controller/patient_login_controller.dart';

class PatientLoginPage extends StatefulWidget {
  const PatientLoginPage({super.key});

  @override
  State<PatientLoginPage> createState() => _PatientLoginPageState();
}

class _PatientLoginPageState extends State<PatientLoginPage> {
  PatientLoginController patientLoginController = Get.put(
    PatientLoginController(),
  );

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isOtpLogin = true;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// MAIN PAGE
          Container(
            color: Color(0xff0f674a),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_hospital, size: 70),
                          const SizedBox(height: 10),
                          const Text(
                            "Patient Login",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// Toggle Buttons
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                _toggleButton("Mobile Login", true),
                                _toggleButton("Email Login", false),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// Fields
                          if (isOtpLogin) ...[
                            TitleTextFormField(
                              controller:
                                  patientLoginController.mobileController,
                              hintText: "Enter Mobile Number",
                              prefixIcon: Icon(Icons.phone),
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter mobile number";
                                }
                                return null;
                              },
                            ),
                          ] else ...[
                            TitleTextFormField(
                              controller:
                                  patientLoginController.emailController,
                              hintText: "Enter Email",
                              prefixIcon: Icon(Icons.email),
                              validator: (value) {
                                if (patientLoginController
                                    .emailController
                                    .text
                                    .isEmpty) {
                                  return "Please enter email";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 15),

                            TitleTextFormField(
                              controller:
                                  patientLoginController.passwordController,
                              hintText: "Enter Password",
                              prefixIcon: Icon(Icons.lock),
                              obscureText: obscurePassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              validator: (value) {
                                if (patientLoginController
                                    .passwordController
                                    .text
                                    .isEmpty) {
                                  return "Please enter password";
                                }
                                return null;
                              },
                            ),
                          ],

                          const SizedBox(height: 25),

                          /// Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                if (isOtpLogin) {
                                  if (formKey.currentState!.validate()) {
                                    patientLoginController.sendOtp();
                                  }
                                  patientLoginController.mobileController
                                      .clear();
                                } else {
                                  if (formKey.currentState!.validate()) {
                                    patientLoginController.loginWithEmail();
                                  }
                                  patientLoginController.emailController
                                      .clear();
                                  patientLoginController.passwordController
                                      .clear();
                                }
                              },
                              child: Text(
                                isOtpLogin ? "Send OTP" : "LOGIN",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const Space(height: 15),

                          /// Sign Up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed("/patientSignup");
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// LOADING OVERLAY
          Obx(() {
            if (!patientLoginController.isLoading.value) {
              return const SizedBox();
            }

            return Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, bool value) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isOtpLogin = value;
            formKey.currentState?.reset();

            patientLoginController.mobileController.clear();
            patientLoginController.emailController.clear();
            patientLoginController.passwordController.clear();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isOtpLogin == value ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isOtpLogin == value ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
