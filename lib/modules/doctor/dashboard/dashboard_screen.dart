import 'package:flutter/material.dart';
import 'package:timesmed_project/modules/doctor/schedule_appointment/schedule_appointment.dart';

class AppointmentDashboard extends StatelessWidget {
  const AppointmentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.9), // 👈 opacity applied
                  borderRadius: BorderRadius.circular(12), // 🔵 rounded corners
                  // border: Border.all(
                  //   // color: Colors.grey, // 🟤 border color
                  //   width: 1.5, // 📏 border width
                  // ),
                ),
                padding: EdgeInsets.all(13),
                // color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Dr Mariappan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "General Physician",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.logout, color: Colors.white),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// 🔹 DATE FILTER
                    Row(
                      children: [
                        _dateBox("04/28/2026"),
                        const SizedBox(width: 10),
                        _dateBox("04/29/2026"),
                      ],
                    ),

                    const SizedBox(height: 15),

                    /// 🔹 GO BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Go",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
              // SizedBox(height: 8,),



              /// 🔹 GRID STATS
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  StatCard(title: "Scheduled", count: "0", color: Colors.blue),
                  StatCard(title: "Waiting", count: "0", color: Colors.teal),
                  StatCard(title: "Checked Out", count: "0", color: Colors.green),
                  StatCard(title: "Cancel", count: "0", color: Colors.red),
                  StatCard(title: "Online Consultation", count: "0", color: Colors.grey),
                  StatCard(title: "OT Request", count: "0", color: Colors.orange),
                  StatCard(title: "Follow Up Appointment", count: "0", color: Colors.greenAccent),
                  StatCard(title: "Missed Call", count: "0", color: Colors.redAccent),
                  StatCard(title: "For Confirmation", count: "0", color: Colors.deepPurpleAccent),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔹 EXTRA SECTION
              const Text(
                "Hospital Appointment",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Appointments"),
                    Text("0", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 DATE BOX
  static Widget _dateBox(String date) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          date,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

/// 🔹 STAT CARD
class StatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}