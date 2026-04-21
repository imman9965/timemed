import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesmed_project/modules/auth/controller/auth_controller.dart';
import 'package:timesmed_project/modules/patient/paient_home/controller/patient_home_controller.dart';

class PatientOrderPage extends StatefulWidget {
  const PatientOrderPage({super.key});

  @override
  State<PatientOrderPage> createState() => _PatientOrderPageState();
}

class _PatientOrderPageState extends State<PatientOrderPage> {
  final patientHomeController = Get.find<PatientHomeController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Text("Order Page"));
  }
}
