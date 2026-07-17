import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class ClinicalVisitConfirmationPage extends StatelessWidget {
  const ClinicalVisitConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6f8),
      appBar: CommonAppBar(title: "Thank You for Booking"),

      body: Column(
        children: [
          /// 🔵 SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _doctorCard(),
                  const SizedBox(height: 16),

                  _thankYouSection(),
                  const SizedBox(height: 16),

                  _dateTimeCard(),
                  const SizedBox(height: 16),

                  _confirmationCard(),
                ],
              ),
            ),
          ),

          /// 🔘 FIXED BUTTON
          Padding(
            padding: const EdgeInsets.all(16),
            child: CommonButton(
              color: AppColors.primary,
              title: "Book Another Appointment",
              onPressed: () {
                context.go(AppRoutes.patientHome);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 DOCTOR CARD (clean header card)
  Widget _doctorCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Dr. Mariappan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text("MBBS", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔶 THANK YOU SECTION
  Widget _thankYouSection() {
    return Column(
      children: const [
        Text(
          "THANK YOU",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Your appointment has been confirmed",
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  /// 📅 DATE TIME CARD (more premium split layout)
  Widget _dateTimeCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _dateItem(
              icon: Icons.calendar_today,
              label: "Date",
              value: "02/05/2026",
            ),
          ),
          Container(height: 40, width: 1, color: Colors.grey.shade300),
          Expanded(
            child: _dateItem(
              icon: Icons.access_time,
              label: "Time",
              value: "02:04 PM",
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  /// 🔹 CONFIRMATION CARD
  Widget _confirmationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: Column(
        children: [
          /// LOGO
          SvgPicture.asset("assets/logos/svg/timesmed_logo.svg", height: 60),

          const SizedBox(height: 10),

          const Text(
            "This appointment is guaranteed by",
            style: TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 4),

          const Text(
            "TimesMed",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Divider(height: 24),

          /// DETAILS
          _infoRow("Name", "Tony Stark"),
          _infoRow("Email", "tony@gmail.com"),
          _infoRow("Mobile", "+91 9876543210"),
          _infoRow("Symptoms", "Fever, headache, body pain"),
        ],
      ),
    );
  }

  /// 🔹 INFO ROW
  static Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
