import 'package:flutter/material.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';

import '../../../../doctor/schedule_appointment/schedule_appointment.dart';

class PatientPrescriptionOrderStatusPage extends StatelessWidget {
  const PatientPrescriptionOrderStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      ("Order Placed", true),
      ("Pending", true),
      ("Confirmed", false),
      ("Processing", false),
      ("Delivered", false),
    ];

    return Scaffold(
      appBar: CommonAppBar(title: "Order Status"),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                /// ICON
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_shipping, color: Colors.white),
                ),

                const SizedBox(width: 12),

                /// TEXT
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "On the way",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Arriving in 20 mins",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 TIMELINE
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ...steps.map((step) {
                    final title = step.$1;
                    final isDone = step.$2;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// LINE + DOT
                        Column(
                          children: [
                            Container(
                              width: 2,
                              height: 30,
                              color: Colors.grey.shade300,
                            ),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: isDone
                                    ? Colors.green
                                    : Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 30,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),

                        const SizedBox(width: 12),

                        /// TEXT
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isDone ? Colors.black : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Status update description here",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  const Spacer(),

                  /// 🔹 SUMMARY
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        _row("Cetaphil Cleanser x1", "₹45"),
                        const Divider(),
                        _row("Total", "₹45", isBold: true),
                      ],
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

  Widget _row(String t, String v, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(t),
        Text(
          v,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
