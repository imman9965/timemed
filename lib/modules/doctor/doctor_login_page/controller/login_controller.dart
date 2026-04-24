import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesmed_project/routes/app_pages.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class LoginController extends GetxController {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onClose() {
    mobileController.dispose();
    otpController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Send OTP
  void sendOtp() async {
    if (mobileController.text.length != 10) {
      Get.snackbar("Error", "Enter valid mobile number");
      return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1)); // API simulation

    isLoading.value = false;

    // Get.toNamed(AppRoutes.patientOtp);
    AppRouter.router.push(AppRoutes.patientOtp);
  }

  /// Verify OTP
  void verifyOtp() async {
    if (otpController.text.length != 6) {
      Get.snackbar("Error", "Enter valid OTP");
      return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    // Get.offAllNamed(AppRoutes.patientHome);
    AppRouter.router.go(AppRoutes.patientHome);
  }

  /// Email Login
  void loginWithEmail() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Enter email & password");
      return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    AppRouter.router.go(AppRoutes.doctorHome);
  }
}
