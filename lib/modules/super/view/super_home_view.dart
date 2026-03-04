import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesmed_project/routes/app_pages.dart';

class SuperHomeView extends StatelessWidget {
  const SuperHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f674a),
        title: const Text("Super Admin Panel"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.patientLogin),
              child: const Text("Open Patient App"),
            ),

            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.doctorLogin),
              child: const Text("Open Doctor App"),
            ),

            ElevatedButton(
              onPressed: () => Get.toNamed('/pharmacyHome'),
              child: const Text("Open Pharmacy App"),
            ),

            ElevatedButton(
              onPressed: () => Get.toNamed('/adminDashboard'),
              child: const Text("Open Admin App"),
            ),
          ],
        ),
      ),
    );
  }
}
