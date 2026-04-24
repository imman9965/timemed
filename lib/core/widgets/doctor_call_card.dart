import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoctorCallCard extends StatelessWidget {
  const DoctorCallCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1976D2), // blue background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          /// 🔹 Doctor Name
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

          /// 🔹 Call Info Section
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
                      /// 🔴 Red Dot
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