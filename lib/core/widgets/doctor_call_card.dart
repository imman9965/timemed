import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../modules/doctor/schedule_appointment/schedule_appointment.dart';
import '../../modules/doctor/widgets/theme.dart';

class DoctorCallCard extends StatelessWidget {
  const DoctorCallCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      // decoration: BoxDecoration(
      //   color: const Color(0xFF1976D2), // blue background
      //   borderRadius: BorderRadius.circular(20),
      // ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Dr.Mariappan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              const Icon(CupertinoIcons.phone_arrow_down_left, color: Colors.white, size: 22),
              const SizedBox(width: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "On call",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.red,
                      ),
                      SizedBox(width: 6),
                      /// ⏱ Time
                      Text(
                        "02:39",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}