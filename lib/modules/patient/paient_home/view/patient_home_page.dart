import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/core/widgets/premium_app_bar.dart';
import 'package:timesmed_project/core/widgets/sapce.dart';
import 'package:timesmed_project/modules/auth/controller/auth_controller.dart';
import 'package:timesmed_project/modules/patient/paient_home/controller/patient_home_controller.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  final patientHomeController = Get.find<PatientHomeController>();
  final authController = Get.find<AuthController>();

  String? selectedType; // 'clinical' or 'video'
  bool showAllSpecialities = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPremiumHeader(),
          Expanded(
            child: ListView(
              children: [
                _buildBookAppointment(),
                const SizedBox(height: 20),

                _buildSpecialities(),
                const SizedBox(height: 14), // 🔥 reduce gap

                _buildUpcomingCard(),
                const SizedBox(height: 20),

                _buildPreviousList(),
                const SizedBox(height: 20),

                _buildPatientSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      decoration: BoxDecoration(
        color: Colors.transparent,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// 👤 Profile
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: const NetworkImage(
              "https://i.pravatar.cc/150?img=5",
            ),
          ),

          const SizedBox(width: 12),

          /// 🧠 Name + Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, John 👋",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 2),

                const Text(
                  "30 yrs • Male",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                const SizedBox(height: 4),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "Self",
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 🔔 Actions
          Row(
            children: [
              _headerIcon(Icons.sync_alt, () {
                // switch patient
              }),
              _headerIcon(Icons.notifications_none, () {
                // notifications
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
      ),
    );
  }

  /// 🔹 Book Appointment Button
  Widget _buildBookAppointment() {
    return GestureDetector(
      onTap: _showSelectionDialog,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Book Appointment",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Clinic or Video Consultation",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> specialities = [
    {"name": "General Physician", "icon": Icons.local_hospital},
    {"name": "Gynecology", "icon": Icons.pregnant_woman},
    {"name": "Obstetrics", "icon": Icons.child_friendly},
    {"name": "Pediatrics", "icon": Icons.child_care},
    {"name": "Cardiology", "icon": Icons.favorite},
    {"name": "Diabetology", "icon": Icons.bloodtype},
    {"name": "Endocrinology", "icon": Icons.science},
    {"name": "Neurology", "icon": Icons.psychology},
    {"name": "Psychiatry", "icon": Icons.self_improvement},
    {"name": "Pulmonology", "icon": Icons.air},
    {"name": "Gastroenterology", "icon": Icons.restaurant},
  ];

  Widget _buildSpecialities() {
    final isExpanded = showAllSpecialities;

    final displayList = isExpanded
        ? [
            ...specialities,
            {"name": "Show Less", "icon": Icons.expand_less},
          ]
        : [
            ...specialities.take(7),
            {"name": "View More", "icon": Icons.more_horiz},
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Specialities",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 6), // 🔥 reduce from 10 → 6

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final item = displayList[index];
            final name = item["name"];

            final isToggleBtn = name == "View More" || name == "Show Less";

            return GestureDetector(
              onTap: () {
                if (isToggleBtn) {
                  setState(() {
                    showAllSpecialities = !showAllSpecialities;
                  });
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                      shape: BoxShape.circle,
                      color: isToggleBtn
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.grey.shade100,
                    ),
                    child: Icon(item["icon"], color: AppColors.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isToggleBtn
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isToggleBtn ? AppColors.primary : Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /// 🔹 UpcomingCard Appointments List
  Widget _buildUpcomingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Row(
            children: [
              const Text(
                "Upcoming",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Confirmed",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// Doctor Row
          Row(
            children: [
              const CircleAvatar(radius: 24, child: Icon(Icons.person)),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dr. John",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Cardiologist",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// Date Time
          Row(
            children: [
              _chip(Icons.calendar_today, "15 Sep"),
              const SizedBox(width: 10),
              _chip(Icons.access_time, "10:30 AM"),
            ],
          ),

          const SizedBox(height: 14),

          /// CTA Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("Reschedule"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Join"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  ///
  Widget _buildPreviousList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Previous", style: TextStyle(fontWeight: FontWeight.bold)),

        const SizedBox(height: 10),

        ...List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),

                const CircleAvatar(
                  radius: 18,
                  child: Icon(Icons.person, size: 18),
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dr. Andrew",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Dentist • ID: 35648",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.chevron_right),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPatientSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Patients",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.addPatient),
              child: const Text("Add"),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
            ],
          ),
          child: Row(
            children: [
              const CircleAvatar(radius: 22, child: Icon(Icons.person)),
              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Andrew Vijay",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Age 30 • 8056567194", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Show Selection Clinical Visit And Video Consultation Dialog

  void _showSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Choose Appointment Type",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// Clinical Visit Card
                  _buildOptionCard(
                    title: "Clinical Visit",
                    subtitle: "Visit hospital & meet doctor",
                    icon: Icons.local_hospital,
                    isSelected: selectedType == 'clinical',
                    onTap: () {
                      setState(() {
                        selectedType = 'clinical';
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  /// Video Consultation Card
                  _buildOptionCard(
                    title: "Video Consultation",
                    subtitle: "Consult doctor from home",
                    icon: Icons.video_call,
                    isSelected: selectedType == 'video',
                    onTap: () {
                      setState(() {
                        selectedType = 'video';
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedType == null
                            ? Colors.grey
                            : const Color(0xff0673de),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: selectedType == null
                          ? null
                          : () {
                              if (selectedType == 'clinical') {
                                context.push(AppRoutes.clinicalFilter);
                              } else {
                                context.push(AppRoutes.videoFilter);
                              }
                              Navigator.pop(context);
                            },
                      child: const Text(
                        "Continue",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🔹 Reusable Card Widget
  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffe8f1ff) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xff0673de) : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Row(
          children: [
            /// Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xff0673de).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xff0673de)),
            ),

            const SizedBox(width: 12),

            /// Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            /// Check Icon
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xff0673de)),
          ],
        ),
      ),
    );
  }
}
