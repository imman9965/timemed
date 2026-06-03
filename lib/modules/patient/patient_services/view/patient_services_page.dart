import 'package:flutter/material.dart';
import 'package:timesmed_project/modules/patient/lab_test/lab_test_track/view/patient_lab_test_tracking_page.dart';
import 'package:timesmed_project/modules/patient/patient_order/binding/patient_order_binding.dart';
import 'package:timesmed_project/modules/patient/patient_order/view/patient_order_page.dart';

import '../../../../core/constants/app_colors.dart';

class PatientServicesPage extends StatefulWidget {
  const PatientServicesPage({super.key});

  @override
  State<PatientServicesPage> createState() => _PatientServicesPageState();
}

class _PatientServicesPageState extends State<PatientServicesPage> {
  @override
  void initState() {
    super.initState();

    PatientOrderBinding().dependencies();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(


        appBar: AppBar( flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary, // #0673de
                AppColors.primary, // #0673de
                // const Color(0xff055bb0),
                // const Color(0xff03458a),
              ],
            ),

            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.20),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white.withOpacity(0.12),
              ),
            ),
          ),
        ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Patient Services",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

        ),

        body: Column(
          children: [

            /// 🔘 TAB BAR
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22,
              vertical: 16
              ),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: AppColors.white,
                unselectedLabelColor: Colors.grey.shade600,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                padding: const EdgeInsets.all(4),
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                tabs: const [
                  Tab(text: "Orders"),
                  Tab(text: "Lab Track"),
                ],
              ),
            ),
            Expanded(
              child: const TabBarView(
                children: [

                  PatientOrderPage(),
                  PatientLabTrackingPage(),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/* bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              margin: const EdgeInsets.all(16),
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xffE9EEF5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xff2F8DB5),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.medication_outlined, size: 20),
                    text: "Orders",
                  ),
                  Tab(
                    icon: Icon(Icons.science_outlined, size: 20),
                    text: "Lab Track",
                  ),
                ],
              ),
            ),
          ),*/

/// ---------------- PREMIUM CARD ----------------

class PremiumServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final Color color;
  final IconData icon;

  const PremiumServiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}