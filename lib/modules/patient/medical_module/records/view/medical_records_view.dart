import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class MedicalRecordsPage extends StatefulWidget {
  const MedicalRecordsPage({super.key});

  @override
  State<MedicalRecordsPage> createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  final List<Map<String, dynamic>> appointments = [
    {
      "patient": "Mr. Vignesh",
      "doctor": "Dr. Mariappan",
      "date": "5 May 2026",
      "time": "5:49 PM",
      "status": "Completed",
    },
    {
      "patient": "Mr. Immanuel",
      "doctor": "Dr. Mariappan",
      "date": "4 May 2026",
      "time": "2:43 PM",
      "status": "Completed",
    },
    {
      "patient": "Mr. Vignesh",
      "doctor": "Dr. Mariappan",
      "date": "5 May 2026",
      "time": "5:49 PM",
      "status": "Pending",
    },
    {
      "patient": "Mr. Immanuel",
      "doctor": "Dr. Mariappan",
      "date": "4 May 2026",
      "time": "2:43 PM",
      "status": "Completed",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(title: "Medical Record", showBack: false),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return _timelineItem(appointments[index], index);
        },
      ),
    );
  }

  /// 🔥 Improved Timeline Item
  Widget _timelineItem(Map<String, dynamic> appt, int index) {
    final isCompleted = appt["status"] == "Completed";

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔵 Timeline
          Column(
            children: [
              Container(
                width: 2,
                height: index == 0 ? 0 : 20,
                color: Colors.grey.shade300,
              ),
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(child: Container(width: 2, color: Colors.grey.shade300)),
            ],
          ),

          const SizedBox(width: 14),

          /// 📦 Premium Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 TOP ROW (Patient + Status)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Icon(Icons.person, color: AppColors.primary),
                      ),

                      const SizedBox(width: 12),

                      /// Patient + Doctor
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appt["patient"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              appt["doctor"],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Status
                      _statusChip(isCompleted),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// 🔹 DATE + TIME
                  Row(
                    children: [
                      _detailBlock(Icons.calendar_today, appt["date"]),
                      const SizedBox(width: 12),
                      _detailBlock(Icons.access_time, appt["time"]),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.push(AppRoutes.patientMedicalRecordDetail);
                      },
                      child: const Text(
                        "Medical Record Details",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailBlock(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// 🔹 Status Chip
  Widget _statusChip(bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isCompleted ? "Completed" : "Cancelled",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isCompleted ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  /// 🔹 Common Chip
  Widget _chip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
