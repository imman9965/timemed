import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/routes/app_pages.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class SuperHomeView extends StatelessWidget {
  const SuperHomeView({super.key});

  Widget adminCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Color(0xff0f674a)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7f6),
      appBar: AppBar(
        backgroundColor: const Color(0xff0f674a),
        elevation: 0,
        title: const Text(
          "Super Admin Panel",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            adminCard(
              title: "Patient App",
              icon: Icons.person,
              onTap: () => context.push(AppRoutes.patientLogin),
            ),

            adminCard(
              title: "Doctor App",
              icon: Icons.medical_services,
              onTap: () => context.push(AppRoutes.doctorLogin),
            ),

            adminCard(
              title: "Pharmacy App",
              icon: Icons.local_pharmacy,
              onTap: () => context.push(AppRoutes.pharmacyLogin),
            ),

            adminCard(
              title: "Admin Dashboard",
              icon: Icons.admin_panel_settings,
              onTap: () => context.push(AppRoutes.adminLogin),
            ),
          ],
        ),
      ),
    );
  }
}
