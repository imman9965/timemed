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
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildPremiumHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  _buildAppointmentActions(),
                  const SizedBox(height: 20),

                  _buildSpecialities(),
                  const SizedBox(height: 14), // 🔥 reduce gap

                  _buildUpcomingCard(),
                  const SizedBox(height: 20),

                  _buildPreviousList(),

                  // _buildPatientSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.primary.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔝 TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Avatar
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xff0673de).withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=5",
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              /// INFO
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "John Doe",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _statusBadge("Active"),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _infoChip("30 yrs"),
                        _infoChip("Male"),
                        _infoChip("Self"),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Patient ID: TM-10234",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              /// ACTIONS
              Flexible(
                child: Column(
                  children: [
                    _actionIcon(Icons.notifications_none, () {}),
                    const SizedBox(height: 8),
                    _actionIcon(Icons.sync_alt, () {
                      _showPatientSwitchSheet(context);
                    }),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 🔹 SECTION TITLE (instead of divider)
          Text(
            "Personal Info",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 10),

          /// 🔹 DETAILS
          Row(
            children: [
              Expanded(
                child: _detailItem(
                  icon: Icons.phone,
                  label: "Phone",
                  value: "8056567194",
                ),
              ),
              Expanded(
                child: _detailItem(
                  icon: Icons.bloodtype,
                  label: "Blood",
                  value: "O+",
                ),
              ),
              Expanded(
                child: _detailItem(
                  icon: Icons.cake,
                  label: "DOB",
                  value: "12 May 1994",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.green,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _detailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 14, color: AppColors.primary),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: Colors.black87),
        ),
      ),
    );
  }

  /// 🔹 Book Appointment Button
  Widget _buildAppointmentActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Book Appointment",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  context.push(AppRoutes.clinicalFilter);
                },
                child: const Text("Clinical Visit"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  context.push(AppRoutes.videoFilter);
                },
                child: const Text("Video Consultation"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _appointmentButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isPrimary ? AppColors.primary : AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isPrimary ? AppColors.primary : Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            onPressed: onTap,
            child: Text(
              title,
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> specialities = [
    {"name": "General Physician", "image": "General Physician.png"},
    {"name": "Gynecology", "image": "Gynecology.png"},
    {"name": "Obstetrics", "image": "Obstetrics.png"},
    {"name": "Pediatrics", "image": "Pediatrics.png"},
    {"name": "Cardiology", "image": "Cardiology.png"},
    {"name": "Diabetology", "image": "Diabetology.png"},
    {"name": "Endocrinology", "image": "Endocrinology.png"},
    {"name": "Neurology", "image": "Neurology.png"},
    {"name": "Psychiatry", "image": "Psychiatry.png"},
    {"name": "Pulmonology", "image": "Pulmonology.png"},
    {"name": "Gastroenterology", "image": "Gastroenterology.png"},
    {"name": "Orthopedics", "image": "Orthopedics.png"},
    {"name": "Dermatology", "image": "Dermatology.png"},
    {"name": "Ophthalmology", "image": "Ophthalmology.png"},
    {"name": "ENT (Ear, Nose, Throat)", "image": "ENT.png"},
    {"name": "Urology", "image": "Urology.png"},
    {"name": "Oncology", "image": "Oncology.png"},
    {"name": "Physiotherapy", "image": "Physiotherapy.png"},
    {"name": "Nephrology (Kidney-related care)", "image": "Nephrology.png"},
    {"name": "General Surgery", "image": "General Surgery.png"},
  ];

  Widget _buildSpecialities() {
    final isExpanded = showAllSpecialities;

    final displayList = isExpanded
        ? [
            ...specialities,
            {"name": "Show Less", "image": "more.png"},
          ]
        : [
            ...specialities.take(7),
            {"name": "View More", "image": "more.png"},
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Specialities",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),

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
                    // child: Icon(item["icon"], color: AppColors.primary),
                    child: Image.asset(
                      "assets/icons/speciality/${item["image"]}",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isToggleBtn ? AppColors.primary : Colors.black,
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
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TOP ROW (Doctor + Status)
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?img=12",
                ),
              ),

              const SizedBox(width: 12),

              /// Doctor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dr. John Mathew",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "Cardiologist • Apollo Clinic",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              /// Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
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

          /// 🔹 APPOINTMENT DETAILS
          Row(
            children: [
              _detailBlock(Icons.calendar_today, "15 Sep"),
              const SizedBox(width: 14),
              _detailBlock(Icons.access_time, "10:30 AM"),
              const SizedBox(width: 14),
              _detailBlock(Icons.video_call, "Video"),
            ],
          ),

          const SizedBox(height: 12),

          /// 🔹 LOCATION / NOTE
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  "Chennai - Apollo Hospital, T Nagar",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 🔹 CTA
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Reschedule"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Join Now"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Previous Appointments List - Show 3 previous appointments with status
  Widget _buildPreviousList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Previous Appointments",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ...List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                /// Doctor Image
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=8",
                  ),
                ),

                const SizedBox(width: 12),

                /// DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Dr. Andrew",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        "Dentist • MIOT Hospital",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          _smallInfo(Icons.calendar_today, "12 Aug"),
                          const SizedBox(width: 10),
                          _smallInfo(Icons.video_call, "Video"),
                        ],
                      ),
                    ],
                  ),
                ),

                /// STATUS + ACTION
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Completed",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _detailBlock(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _smallInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey),
        const SizedBox(width: 3),
        Text(text, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  void _showPatientSwitchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag Handle
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 12),

              /// Title
              const Text(
                "Switch Patient",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 16),

              /// Patient List
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _patientSwitchCard(),
                  _patientSwitchCard(),
                  _patientSwitchCard(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _patientSwitchCard() {
    return InkWell(
      onTap: () {
        Navigator.pop(context); // switch logic later
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            /// Avatar
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withOpacity(0.4)),
              ),
              child: const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?img=5",
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Andrew Vijay",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      _miniChip("30 yrs"),
                      const SizedBox(width: 6),
                      _miniChip("Male"),
                      const SizedBox(width: 6),
                      _miniChip("O+"),
                    ],
                  ),
                ],
              ),
            ),

            /// Select indicator
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _miniChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
