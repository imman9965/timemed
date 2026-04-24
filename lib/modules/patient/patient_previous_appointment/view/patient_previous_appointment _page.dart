import 'package:flutter/material.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';

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
      "name": "Dr. Andrew",
      "speciality": "Dentist",
      "id": "35648",
      "type": "Instant",
      "date": "12 Apr 2026",
      "status": "Completed",
    },
    {
      "name": "Dr. Priya",
      "speciality": "Cardiologist",
      "id": "35649",
      "type": "Schedule",
      "date": "10 Apr 2026",
      "status": "Cancelled",
    },
    {
      "name": "Dr. Rahul",
      "speciality": "Dermatologist",
      "id": "35650",
      "type": "Instant",
      "date": "08 Apr 2026",
      "status": "Completed",
    },
    {
      "name": "Dr. Meena",
      "speciality": "Gynecologist",
      "id": "35651",
      "type": "Schedule",
      "date": "05 Apr 2026",
      "status": "Completed",
    },
    {
      "name": "Dr. Arjun",
      "speciality": "Orthopedic",
      "id": "35652",
      "type": "Instant",
      "date": "02 Apr 2026",
      "status": "Cancelled",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Previous Appointments"),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
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
    final isInstant = appt["type"] == "Instant";

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🟢 Timeline
          Column(
            children: [
              /// Top line
              Container(
                width: 2,
                height: index == 0 ? 0 : 20,
                color: Colors.grey.shade300,
              ),

              /// Dot
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),

              /// Bottom line
              Expanded(child: Container(width: 2, color: Colors.grey.shade300)),
            ],
          ),

          const SizedBox(width: 14),

          /// 📦 Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Top Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Icon(Icons.person, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appt["name"],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              appt["speciality"],
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Status Chip
                      _statusChip(isCompleted),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 Chips Row (Type + Date)
                  Row(
                    children: [
                      _chip(
                        label: appt["type"],
                        color: isInstant ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      _chip(label: appt["date"], color: Colors.blueGrey),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// 🔹 ID
                  Text(
                    "Appointment ID: ${appt["id"]}",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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
