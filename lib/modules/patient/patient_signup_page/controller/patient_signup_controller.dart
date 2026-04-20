import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientSignupController extends GetxController {
  /// Name
  /// Email
  /// Dob
  /// Age
  /// genger
  /// matirial Status
  /// phone Number
  /// Password
  /// Confirm Password

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController materialStatusController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  var isLoading = false.obs;
}
