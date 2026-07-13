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

  /// Validation error messages — shown below each field, OUTSIDE the input box.
  /// Empty string means "no error".
  var mobileError = ''.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var otpError = ''.obs;

  // Only digits.
  final RegExp _digitsOnly = RegExp(r'^[0-9]+$');
  // Standard email format.
  final RegExp _emailRegex =
      RegExp(r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,}$');

  /// Clear every error message (e.g. when toggling login mode).
  void clearErrors() {
    mobileError.value = '';
    emailError.value = '';
    passwordError.value = '';
    otpError.value = '';
  }

  /// Mobile must be exactly 10 digits.
  bool validateMobile() {
    final value = mobileController.text.trim();
    if (value.isEmpty) {
      mobileError.value = 'Please enter your mobile number';
      return false;
    }
    if (!_digitsOnly.hasMatch(value) || value.length != 10) {
      mobileError.value = 'Enter a valid 10-digit mobile number';
      return false;
    }
    mobileError.value = '';
    return true;
  }

  /// Email + 6-digit password validation. Returns true only if both pass.
  bool validateEmailLogin() {
    var isValid = true;
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Please enter your email';
      isValid = false;
    } else if (!_emailRegex.hasMatch(email)) {
      emailError.value = 'Enter a valid email address';
      isValid = false;
    } else {
      emailError.value = '';
    }

    final password = passwordController.text;
    if (password.isEmpty) {
      passwordError.value = 'Please enter your password';
      isValid = false;
    } else if (!_digitsOnly.hasMatch(password) || password.length != 6) {
      passwordError.value = 'Password must be exactly 6 digits';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    return isValid;
  }

  /// OTP must be exactly 6 digits.
  bool validateOtp() {
    final value = otpController.text.trim();
    if (value.isEmpty) {
      otpError.value = 'Please enter the OTP';
      return false;
    }
    if (!_digitsOnly.hasMatch(value) || value.length != 6) {
      otpError.value = 'Enter the 6-digit OTP';
      return false;
    }
    otpError.value = '';
    return true;
  }

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
    if (!validateMobile()) return;

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1)); // API simulation

    isLoading.value = false;

    // Get.toNamed(AppRoutes.patientOtp);
    AppRouter.router.push(AppRoutes.patientOtpScreen);
  }

  /// Verify OTP
  void verifyOtp() async {
    if (!validateOtp()) return;

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    AppRouter.router.go(AppRoutes.doctorDashboard);
  }

  /// Email Login
  void loginWithEmail() async {
    if (!validateEmailLogin()) return;

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    AppRouter.router.go(AppRoutes.doctorDashboard,);
  }
}
