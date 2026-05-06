import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/floating_bottom_navigation_bar.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientMainPage extends StatelessWidget {
  final Widget child;

  const PatientMainPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    int currentIndex = _getIndexFromLocation(
      GoRouterState.of(context).uri.toString(),
    );

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true, // 🔥 allows body behind bottom nav
        body: Stack(
          children: [
            child, // 👈 your current page
            /// 🔥 AI FLOATING BUTTON (GLOBAL)
            Positioned(
              bottom: 110, // above bottom nav
              right: 16,
              child: GestureDetector(
                onTap: () {
                  context.push(AppRoutes.aiChat, extra: 'patient');
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                      ),
                    ],
                    border: Border.all(color: AppColors.primaryBackground),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/ai_robot.svg",
                    color: Colors.white,
                    height: 20,
                  ),
                ),
              ),
            ),
          ],
        ), // 👈 VERY IMPORTANT
        bottomNavigationBar: SizedBox(
          height: 100,
          child: FloatingBottomNavigationBar(
            currentIndex: currentIndex,
            label: const ['Home', 'Appointments', 'My Orders', 'Profile'],
            icons: const [
              Icons.home,
              Icons.date_range,
              Icons.backpack_sharp,
              Icons.person,
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go(AppRoutes.patientHome);
                  break;
                case 1:
                  context.go(AppRoutes.patientPreviousAppointments);
                  break;
                case 2:
                  context.go(AppRoutes.patientOrder);
                  break;
                case 3:
                  context.go(AppRoutes.patientProfile);
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  int _getIndexFromLocation(String location) {
    if (location.contains(AppRoutes.patientPreviousAppointments)) return 1;
    if (location.contains(AppRoutes.patientOrder)) return 2;
    if (location.contains(AppRoutes.patientProfile)) return 3;
    return 0;
  }
}
