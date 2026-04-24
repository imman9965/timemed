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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PremiumAppBar(
          title: "Home",
          showProfile: true,
          profileImage: "https://i.pravatar.cc/150?img=5",
          showNotification: true,
          notificationCount: 3,
          showLogout: true,
          onLogout: () {
            authController.logout();
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TOP PROFILE SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.background,
                            radius: 28,
                            child: Icon(Icons.person),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Andrew Vijay",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Age: 30"),
                            ],
                          ),
                        ],
                      ),

                      GestureDetector(
                        onTap: () {
                          _showSelectionDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.button,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_sharp,
                                color: AppColors.white,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Book Appointment",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// PREVIOUS APPOINTMENTS LIST
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          "Previous Appointments",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      Text("View more", style: TextStyle(color: Colors.blue)),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Column(
                    children: List.generate(3, (index) {
                      return Card(
                        color: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    child: Icon(Icons.person, size: 18),
                                  ),
                                  Space(width: 12),
                                  Text(
                                    "Mr. Andrew",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Dentist",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    "Appointment ID: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text("35648"),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    "Type: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Instant"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                      ),
                      onPressed: () {},
                      child: Text("View More"),
                    ),
                  ),

                  const Space(height: 20),

                  /// UPCOMING APPOINTMENTS
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Upcoming Appointments",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Column(
                    children: List.generate(2, (index) {
                      final data = [
                        {
                          "name": "Dr. Andrew",
                          "role": "Dentist",
                          "id": "35648",
                          "type": "Instant",
                          "statusColor": Colors.green,
                          "date": "15 Sep 2024",
                          "time": "10:30 AM",
                        },
                        {
                          "name": "Dr. John",
                          "role": "Cardiologist",
                          "id": "78521",
                          "type": "Scheduled",
                          "statusColor": Colors.orange,
                          "date": "15 Sep 2024",
                          "time": "10:30 AM",
                        },
                      ];

                      final item = data[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Card(
                          color: AppColors.primary.withOpacity(0.10),
                          elevation: 6,
                          shadowColor: Colors.black.withOpacity(0.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// 🔹 Top Row
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor: AppColors.primary
                                          .withOpacity(0.1),
                                      child: Icon(
                                        Icons.person,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    /// Name & Role
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item["name"].toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            item["role"].toString(),
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    /// Status Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (item["statusColor"] as Color)
                                            .withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        item["type"].toString(),
                                        style: TextStyle(
                                          color: item["statusColor"] as Color,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                /// 🔹 Date & Time Row
                                Row(
                                  children: [
                                    _infoIconText(
                                      Icons.calendar_today,
                                      item["date"].toString(),
                                    ),
                                    const SizedBox(width: 16),
                                    _infoIconText(
                                      Icons.access_time,
                                      item["time"].toString(),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                /// 🔹 Info Section
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.confirmation_number,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            "Appointment ID:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(item["id"].toString()),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.medical_services,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            "Type:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(item["type"].toString()),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  /// ACCOUNT SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Choose Account",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.add_circle, color: Colors.yellow),
                            const SizedBox(width: 10),
                            Text(
                              "Add Patient",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Card(
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(child: Icon(Icons.person)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Row(
                                  children: [
                                    Text(
                                      "Andrew Vijay",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Space(width: 30),
                                    Text("Age: 30"),
                                  ],
                                ),

                                Space(height: 4),
                                Text("8056567194"),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: AppColors.primary,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.delete,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
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

  Widget _infoIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/*  Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TOP PROFILE SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(radius: 28, child: Icon(Icons.person)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Andrew Vijay",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Age: 30"),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.notifications_none),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ACTION BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text("Book Appointment"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text("Previous Appointments"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// UPCOMING APPOINTMENTS
                  const Text(
                    "Upcoming Appointments",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text("Nothing to show")),
                  ),

                  const SizedBox(height: 20),

                  /// PREVIOUS APPOINTMENTS LIST
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Previous Appointments",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("View more", style: TextStyle(color: Colors.blue)),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Column(
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              child: Icon(Icons.medical_services),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Mr. Andrew",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Dentist"),
                                  Text("Appointment ID: 35648"),
                                  Text("Type: Instant"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  /// ACCOUNT SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Choose Account",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Add Patient"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(child: Icon(Icons.person)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Andrew Vijay",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("Age: 30"),
                              Text("Test"),
                              Text("8056567194"),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),*/
