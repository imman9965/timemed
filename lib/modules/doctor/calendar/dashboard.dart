import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';
import '../theme/doctor_theme.dart';






class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {



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
                context.push(AppRoutes.scheduleAppointment);
              },
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  color: DoctorColors.blue50,
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
                      color: DoctorColors.primary,
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
                      style: const TextStyle(fontSize: 12, color: DoctorColors.textMuted),
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
