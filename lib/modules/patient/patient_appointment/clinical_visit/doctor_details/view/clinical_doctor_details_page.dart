import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class ClinicalDoctorDetailsPage extends StatefulWidget {
  const ClinicalDoctorDetailsPage({super.key});

  @override
  State<ClinicalDoctorDetailsPage> createState() =>
      _ClinicalDoctorDetailsPageState();
}

class _ClinicalDoctorDetailsPageState extends State<ClinicalDoctorDetailsPage> {
  int selectedTab = 0;

  final tabs = ["INFO", "FEEDBACK", "PHOTOS", "VIDEOS", "SERVICES", "MAP"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CommonAppBar(title: "Doctor Details"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          children: [
            _premiumHeader(),
            _premiumTabs(),
            const SizedBox(height: 10),
            Expanded(child: _buildTabContent()),
            _bottomCTA(context),
          ],
        ),
      ),
    );
  }

  /// 🔥 TAB CONTENT SWITCH
  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return _infoTab();
      case 1:
        return const Center(child: Text("No Feedback Available"));
      case 2:
        return const Center(child: Text("Photos Coming Soon"));
      case 3:
        return const Center(child: Text("Videos Coming Soon"));
      case 4:
        return const Center(child: Text("Services List"));
      case 5:
        return const Center(child: Text("Map View"));
      default:
        return const SizedBox();
    }
  }

  /// Header
  Widget _premiumHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          /// IMAGE
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
            ),
          ),

          const SizedBox(width: 14),

          /// DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Dr. Arun",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),

                /// DEGREE CHIP
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text("MBBS", style: TextStyle(fontSize: 11)),
                ),

                const SizedBox(height: 6),

                Text(
                  "Child Specialist • 3+ Years",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),

          /// STATUS BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Available",
              style: TextStyle(
                fontSize: 11,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 TAB CONTENT SWITCH
  Widget _premiumTabs() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = selectedTab == index;

          return GestureDetector(
            onTap: () => setState(() => selectedTab = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.white : Colors.grey.shade600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🔹 INFO TAB UI
  Widget _infoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          /// ABOUT CARD
          _sectionCard(
            title: "About Doctor",
            child: Text(
              "Dr. Arun is a board-certified specialist with 3+ years of experience providing quality healthcare.",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),

          /// LOCATION CARD
          _sectionCard(
            title: "Clinic Location",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mogappair-East - Chennai",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  "No: 82, Justice Rathnavel Pandian Road, Golden George Nagar",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 10),

                OutlinedButton(onPressed: () {}, child: const Text("View Map")),
              ],
            ),
          ),

          /// TIMINGS CARD
          _sectionCard(
            title: "Available Timings",
            child: Column(
              children: [
                _timingRow("Mon - Sat", "5:00 PM - 9:00 PM"),
                const SizedBox(height: 8),
                _timingRow("Sun", "8:00 PM - 9:00 PM"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _timingRow(String day, String time) {
    return Row(
      children: [
        const Icon(Icons.schedule, size: 16, color: Colors.orange),
        const SizedBox(width: 8),
        Text("$day • $time", style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _bottomCTA(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          /// PRICE
          Expanded(
            child: Text(
              "Consultation Fee\n₹550",
              style: TextStyle(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// BUTTON
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                context.push(AppRoutes.clinicalSchedule);
              },
              child: const Text("Book Appointment"),
            ),
          ),
        ],
      ),
    );
  }
}
