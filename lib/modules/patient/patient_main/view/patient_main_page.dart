import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

    return Scaffold(
      backgroundColor: Color(0xffFFFCF5),
      body: child, // 👈 VERY IMPORTANT

      bottomNavigationBar: SizedBox(
        height: 100,
        child: FloatingBottomNavigationBar(
          currentIndex: currentIndex,
          label: const ['Home', 'Profile', 'My Orders'],
          icons: const [Icons.home, Icons.person, Icons.backpack_sharp],
          onTap: (index) {
            switch (index) {
              case 0:
                context.go(AppRoutes.patientHome);
                break;
              case 1:
                context.go(AppRoutes.patientProfile);
                break;
              case 2:
                context.go(AppRoutes.patientOrder);
                break;
            }
          },
        ),
      ),
    );
  }

  int _getIndexFromLocation(String location) {
    if (location.contains(AppRoutes.patientProfile)) return 1;
    if (location.contains(AppRoutes.patientOrder)) return 2;
    return 0;
  }
}
