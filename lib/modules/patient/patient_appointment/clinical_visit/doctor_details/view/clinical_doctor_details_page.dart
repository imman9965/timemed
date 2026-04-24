import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
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
      appBar: AppBar(title: const Text("Doctor Details")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          children: [
            /// 👨‍⚕️ DOCTOR HEADER
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=3",
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dr. Arun",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text("MBBS"),
                      SizedBox(height: 4),
                      Text(
                        "Child Specialist • 3+ Years",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// 🔹 TABS
            Container(
              height: 45,
              color: Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedTab == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedTab = index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected
                                ? Colors.orange
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: isSelected ? Colors.orange : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 1),

            /// 🔥 TAB CONTENT
            Expanded(child: _buildTabContent()),

            /// 🔥 BOOK BUTTON
            Container(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    context.push(AppRoutes.clinicalSchedule);
                  },
                  child: const Text(
                    "Book Appointment",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
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

  /// 🔹 INFO TAB UI
  Widget _infoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dr. Arun is a board-certified specialist with 3+ years of experience providing quality healthcare.",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 16),

          const Text(
            "Mogappair-East - Chennai",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 6),

          const Text(
            "No: 82, Justice Rathnavel Pandian Road, Golden George Nagar, Chennai - 600107",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {},
            child: const Text("View Map"),
          ),

          const SizedBox(height: 20),

          /// TIMINGS
          _timingCard("Mon - Sat", "5:00 PM - 9:00 PM"),
          const SizedBox(height: 10),
          _timingCard("Sun", "8:00 PM - 9:00 PM"),
        ],
      ),
    );
  }

  Widget _timingCard(String day, String time) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.orange),
          const SizedBox(width: 10),
          Text("$day - $time"),
        ],
      ),
    );
  }
}
