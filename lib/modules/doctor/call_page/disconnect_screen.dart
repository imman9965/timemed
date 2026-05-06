import 'package:flutter/material.dart';
import 'package:timesmed_project/modules/doctor/schedule_appointment/schedule_appointment.dart';

class ConsultationSummaryScreen extends StatelessWidget {
  const ConsultationSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Top section — call ended badge
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF27500A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Color(0xFFC0DD97),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "Consultation ended",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Duration · 24 min 38 sec",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom sheet — white card
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor info card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F1FB),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 23,
                            backgroundColor: const Color(0xFF185FA5),
                            child: const Text(
                              "DR",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFE6F1FB),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Dr. Ramesh Kumar",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0C447C),
                                  ),
                                ),
                                Text(
                                  "General Physician · MBBS, MD",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF185FA5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: List.generate(5, (i) => Icon(
                                  i < 4 ? Icons.star_rounded : Icons.star_outline_rounded,
                                  size: 14,
                                  color: i < 4 ? const Color(0xFFBA7517) : const Color(0xFFD3D1C7),
                                )),
                              ),
                              const Text(
                                "4.0",
                                style: TextStyle(fontSize: 11, color: Color(0xFF185FA5)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),
                    _sectionLabel("Summary"),
                    const SizedBox(height: 10),
                    _summaryCard(),
                    const SizedBox(height: 22),
                    _sectionLabel("Prescription"),
                    const SizedBox(height: 10),
                    _medicineCard(
                      name: "Paracetamol 500mg",
                      dosage: "1 tab · 3× daily · 5 days",
                      bgColor: const Color(0xFFFCEBEB),
                      iconColor: const Color(0xFFA32D2D),
                    ),
                    const SizedBox(height: 8),
                    _medicineCard(
                      name: "ORS Sachet",
                      dosage: "1 sachet · 2× daily · 3 days",
                      bgColor: const Color(0xFFE1F5EE),
                      iconColor: const Color(0xFF0F6E56),
                    ),

                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: _actionButton(
                            label: "Download",
                            icon: Icons.download_rounded,
                            bgColor: const Color(0xFFEAF3DE),
                            textColor: const Color(0xFF3B6D11),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _actionButton(
                            label: "Book follow-up",
                            icon: Icons.calendar_month_rounded,
                            bgColor: const Color(0xFFE6F1FB),
                            textColor: const Color(0xFF185FA5),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Back to home",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
        color: Color(0xFF888780),
      ),
    );
  }

  Widget _summaryCard() {
    final items = [
      ("Diagnosis", "Viral Fever"),
      ("Follow-up", "3 days"),
      ("Prescribed", "2 medicines"),
    ];
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFE8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(items[i].$1, style: const TextStyle(fontSize: 13, color: Color(0xFF5F5E5A))),
                    Text(items[i].$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF2C2C2A))),
                  ],
                ),
              ),
              if (i < items.length - 1)
                const Divider(height: 1, thickness: 0.5, color: Color(0xFFD3D1C7), indent: 14, endIndent: 14),
            ],
          );
        }),
      ),
    );
  }

  Widget _medicineCard({
    required String name,
    required String dosage,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD3D1C7), width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.medication_rounded, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF2C2C2A))),
              Text(dosage, style: const TextStyle(fontSize: 11, color: Color(0xFF888780))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
  }) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, color: textColor, size: 17),
      label: Text(label, style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w500)),
    );
  }
}