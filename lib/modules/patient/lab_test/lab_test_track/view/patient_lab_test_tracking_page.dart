import 'package:flutter/material.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';

class PatientLabTrackingPage extends StatefulWidget {
  const PatientLabTrackingPage({super.key});

  @override
  State<PatientLabTrackingPage> createState() => _PatientLabTrackingPageState();
}

class _PatientLabTrackingPageState extends State<PatientLabTrackingPage> {
  final List<Map<String, dynamic>> bookings = [
    {
      "testName": "Complete Blood Count",
      "bookingId": "#LAB1025",
      "date": "12 May 2026",
      "time": "08:30 AM",
      "status": "Sample Collected",
      "type": "Home Collection",
      "price": "₹850",
      "lab": "Apollo Diagnostics",
      "icon": Icons.home_rounded,
      "color": Colors.green,
      "steps": [
        {"title": "Booking Confirmed", "done": true},
        {"title": "Technician Assigned", "done": true},
        {"title": "Sample Collected", "done": true},
        {"title": "Report Processing", "done": false},
        {"title": "Report Ready", "done": false},
      ],
    },
    {
      "testName": "Vitamin D Test",
      "bookingId": "#LAB1088",
      "date": "14 May 2026",
      "time": "11:00 AM",
      "status": "Visit Scheduled",
      "type": "Visit Lab",
      "price": "₹1200",
      "lab": "Medall Healthcare",
      "icon": Icons.local_hospital_rounded,
      "color": Colors.orange,
      "steps": [
        {"title": "Booking Confirmed", "done": true},
        {"title": "Slot Reserved", "done": true},
        {"title": "Visit Lab", "done": false},
        {"title": "Sample Processing", "done": false},
        {"title": "Report Ready", "done": false},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFD),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  color: Colors.black.withValues(alpha: 0.04),
                ),
              ],
            ),
            child: Column(
              children: [
                /// 🔹 PREMIUM HEADER
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(booking["icon"], color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking["testName"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  booking["bookingId"],
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              booking["price"],
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _headerInfoChip(Icons.calendar_month, booking["date"]),
                          const SizedBox(width: 12),
                          _headerInfoChip(Icons.access_time_filled, booking["time"]),
                          const Spacer(),
                          _typeBadge(booking["type"], booking["color"]),
                        ],
                      ),
                    ],
                  ),
                ),

                /// 🔹 TRACKING BODY
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "CURRENT STATUS",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1),
                          ),
                          const Spacer(),
                          Text(
                            booking["status"].toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.w800, color: booking["color"], fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: List.generate(booking["steps"].length, (i) {
                          final step = booking["steps"][i];
                          final bool done = step["done"];
                          final bool isLast = i == booking["steps"].length - 1;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: done ? AppColors.primary : Colors.grey.shade200,
                                      border: Border.all(
                                        color: done ? AppColors.primary : Colors.grey.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    child: done ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                                  ),
                                  if (!isLast)
                                    Container(
                                      width: 2,
                                      height: 35,
                                      color: done ? AppColors.primary : Colors.grey.shade200,
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  step["title"],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: done ? FontWeight.w700 : FontWeight.w500,
                                    color: done ? const Color(0xff1A1C1E) : Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _actionBtn(
                              label: "Support",
                              icon: Icons.headset_mic_outlined,
                              onTap: () {},
                              isPrimary: false,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _actionBtn(
                              label: "View Report",
                              icon: Icons.description_outlined,
                              onTap: () {},
                              isPrimary: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _headerInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _typeBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 0.5),
      ),
    );
  }

  Widget _actionBtn({required String label, required IconData icon, required VoidCallback onTap, required bool isPrimary}) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : Colors.white,
          foregroundColor: isPrimary ? Colors.white : AppColors.primary,
          elevation: isPrimary ? 4 : 0,
          shadowColor: isPrimary ? AppColors.primary.withValues(alpha: 0.3) : Colors.transparent,
          side: isPrimary ? BorderSide.none : BorderSide(color: AppColors.primary.withValues(alpha: 0.2), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
        ),
      ),
    );
  }
}
