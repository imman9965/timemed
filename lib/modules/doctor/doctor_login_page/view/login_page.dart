import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/core/widgets/sapce.dart';
import 'package:timesmed_project/core/widgets/title_Text_form_field.dart';
import 'package:timesmed_project/routes/app_routes.dart';

import '../controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginControllerctr = Get.put(LoginController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isOtpLogin = true;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Logo
              Center(
                child: SvgPicture.asset(
                  "assets/logos/svg/timesmed_logo.svg",
                  height: 100,
                  width: 100,
                ),
              ),

              /// Main Page
              Stack(
                children: [
                  /// MAIN PAGE
                  SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),

                                const Space(height: 25),
                                const Text(
                                  "Please sign in to continue",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                                const Space(height: 25),

                                /// Toggle Buttons
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
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
                                    borderRadius: 25,
                                    controller:
                                        LoginControllerctr.mobileController,
                                    filled: true,
                                    fillColor: AppColors.white,
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
                                        LoginControllerctr.emailController,
                                    hintText: "Enter Email",
                                    prefixIcon: Icon(Icons.email),
                                    filled: true,
                                    fillColor: AppColors.white,
                                    borderRadius: 25,
                                    validator: (value) {
                                      if (LoginControllerctr
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
                                    controller: LoginControllerctr
                                        .passwordController,
                                    hintText: "Enter Password",
                                    prefixIcon: Icon(Icons.lock),
                                    obscureText: obscurePassword,
                                    filled: true,
                                    fillColor: AppColors.white,
                                    borderRadius: 25,
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
                                      if (LoginControllerctr
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
                                CommonButton(
                                  title: isOtpLogin ? "Send OTP" : "LOGIN",
                                  width: 150,
                                  borderRadius: 12,
                                  onPressed: () {
                                    if (isOtpLogin) {
                                      if (formKey.currentState!.validate()) {
                                        LoginControllerctr.sendOtp();
                                      }
                                      LoginControllerctr.mobileController
                                          .clear();
                                    } else {
                                      if (formKey.currentState!.validate()) {
                                        LoginControllerctr.loginWithEmail();
                                      }
                                      LoginControllerctr.emailController
                                          .clear();
                                      LoginControllerctr.passwordController
                                          .clear();
                                    }
                                  },
                                ),
                                const Space(height: 10),

                                /// Forgot Password
                                isOtpLogin
                                    ? const SizedBox()
                                    : Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            "Forgot Password !",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                      ),

                                /// Sign Up
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don't have an account?",
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.push(AppRoutes.patientSignup);
                                      },
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.yellow,
                                        ),
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

                  /// LOADING OVERLAY
                  Obx(() {
                    if (!LoginControllerctr.isLoading.value) {
                      return const SizedBox();
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    );
                  }),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () {},

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 5,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                          ),
                        ),
                        child: Text(
                          "How can i help you ?",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: SvgPicture.asset("assets/icons/ai_robot.svg"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
            LoginControllerctr.mobileController.clear();
            LoginControllerctr.emailController.clear();
            LoginControllerctr.passwordController.clear();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isOtpLogin == value
                ? AppColors.secondaryBackground
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isOtpLogin == value ? Colors.white : AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
