import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/app_routes.dart';
import '../hospital_list_doctor/hospital_list_based_on_doctor.dart';
import '../widgets/add_online_schedule_list.dart';

// Assume these are already defined in your project
// import 'add_online_consultation_dialog.dart';

class Hospital {
  final String name;
  OnlineScheduleData? schedule;

  Hospital({required this.name, this.schedule});
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final List<Hospital> _hospitals = [
    Hospital(name: "City Hospital"),
    Hospital(name: "Apollo Clinic"),
    // Hospital(name: "Global Health Center"),
  ];

  void _onEditHospital(Hospital h) async {
    final result = await AddOnlineConsultationDialog.show(
      context,
      initialData: h.schedule,
    );

    if (result != null) {
      setState(() {
        h.schedule = result;
      });
    }
  }

  // 🧾 Format schedule text
  String _formatSchedule(Hospital h) {
    if (h.schedule == null ||
        h.schedule!.fromTime == null ||
        h.schedule!.toTime == null) {
      return "No schedule added";
    }

    final from = h.schedule!.fromTime!.format(context);
    final to = h.schedule!.toTime!.format(context);

    return "$from → $to";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                context.go(AppRoutes.scheduleAppointment);
              },
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.local_hospital,
                      size: 40,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 10),

                    // 🏥 Hospital Name
                    Text(
                      "Schedule Appointment List",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // ⏰ Schedule (optional)
                    Text(
                      "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          )

        ],
      )
    );
  }
}
