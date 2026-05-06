import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientPreviousAppointmentPage extends StatefulWidget {
  const PatientPreviousAppointmentPage({super.key});

  @override
  State<PatientPreviousAppointmentPage> createState() =>
      _PatientPreviousAppointmentPageState();
}

class _PatientPreviousAppointmentPageState
    extends State<PatientPreviousAppointmentPage> {
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
      appBar: CommonAppBar(title: "Previous Appointments", showBack: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        children: [
          ...appointments
              .map((appt) => _previousAppointmentCard(appt))
              .toList(),
        ],
      ),
    );
  }

  Widget _previousAppointmentCard(Map<String, dynamic> appt) {
    final isCompleted = appt["status"] == "Completed";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // ✅ Fixed: explicit height on SizedBox + Stack
              SizedBox(
                width: 60,
                height: 40,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        child: const Icon(Icons.person, size: 18),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        child: Icon(
                          Icons.medical_services,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appt["doctor"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      appt["patient"],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  appt["status"],
                  style: TextStyle(
                    fontSize: 11,
                    color: isCompleted ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              _detailBlock(Icons.calendar_today, appt["date"]),
              const SizedBox(width: 14),
              _detailBlock(Icons.access_time, appt["time"]),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  "Chennai - Clinic Visit",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                context.push(AppRoutes.patientMedicalRecords);
              },
              child: const Text("View Medical Record"),
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
}
