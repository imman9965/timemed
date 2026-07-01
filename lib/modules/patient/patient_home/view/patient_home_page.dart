import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/modules/auth/controller/auth_controller.dart';
import 'package:timesmed_project/modules/patient/patient_home/controller/patient_home_controller.dart';
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          children: [
            _buildPremiumHeader(),
            const SizedBox(height: 20),
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
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.9),
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage(
                        "assets/icons/gender/category/man/adult_man.png",
                      ),
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
                            "Vignesh",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // _statusBadge("Active"),
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
                      _showPatientDialog(context);
                    }),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 🔹 SECTION TITLE (instead of divider)
          Row(
            children: [
              Container(
                width: 4,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "Personal Info",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
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

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
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
            color: AppColors.white,
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
      child: Container(
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
              child: CommonButton(
                isOutlined: true,
                title: "Clinical Visit",
                onPressed: () {
                  context.push(AppRoutes.clinicalFilter);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CommonButton(
                title: "Video Consultation",
                onPressed: () {
                  context.push(AppRoutes.videoFilter);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> specialities = [
    {"id": 1, "name": "General Physician", "image": "General Physician.png"},
    {"id": 2, "name": "Gynecology", "image": "Gynecology.png"},
    {"id": 3, "name": "Obstetrics", "image": "Obstetrics.png"},
    {"id": 4, "name": "Pediatrics", "image": "Pediatrics.png"},
    {"id": 5, "name": "Cardiology", "image": "Cardiology.png"},
    {"id": 6, "name": "Diabetology", "image": "Diabetology.png"},
    {"id": 7, "name": "Endocrinology", "image": "Endocrinology.png"},
    {"id": 8, "name": "Neurology", "image": "Neurology.png"},
    {"id": 9, "name": "Psychiatry", "image": "Psychiatry.png"},
    {"id": 10, "name": "Pulmonology", "image": "Pulmonology.png"},
    {"id": 11, "name": "Gastroenterology", "image": "Gastroenterology.png"},
    {"id": 12, "name": "Orthopedics", "image": "Orthopedics.png"},
    {"id": 13, "name": "Dermatology", "image": "Dermatology.png"},
    {"id": 14, "name": "Ophthalmology", "image": "Ophthalmology.png"},
    {"id": 15, "name": "ENT (Ear, Nose, Throat)", "image": "ENT.png"},
    {"id": 16, "name": "Urology", "image": "Urology.png"},
    {"id": 17, "name": "Oncology", "image": "Oncology.png"},
    {"id": 18, "name": "Physiotherapy", "image": "Physiotherapy.png"},
    {"id": 19, "name": "Nephrology", "image": "Nephrology.png"},
    {"id": 20, "name": "General Surgery", "image": "General Surgery.png"},
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
                } else {
                  context.push(
                    AppRoutes.specialityDoctorList,
                    extra: item, // 🔥 pass full speciality
                  );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "UpComing Appointment",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Container(
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
                      "https://manage.healu360.com/uploads/2024/09/5a4d97684d10837be6911fab06257c86.jpg",
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Doctor Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Dr. Mariappan",
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
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "Chennai - Apollo Hospital, T Nagar",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
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
        ),
      ],
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
                    "https://manage.healu360.com/uploads/2024/09/5a4d97684d10837be6911fab06257c86.jpg",
                  ),
                ),

                const SizedBox(width: 12),

                /// DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Dr. Mariappan",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        "Cardiologist • Apollo Clinic",
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

  void _showPatientDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔹 HEADER
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.people, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Switch Patient",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Select active profile",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// 🔹 PATIENT LIST
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) {
                      return _premiumPatientItem(isSelected: index == 0);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 ADD PATIENT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(AppRoutes.addPatient);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text(
                      "Add New Patient",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _premiumPatientItem({bool isSelected = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isSelected
            ? LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.12),
            AppColors.primary.withOpacity(0.05),
          ],
        )
            : null,
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          /// 👤 AVATAR WITH STATUS RING
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=5"),
            ),
          ),

          const SizedBox(width: 12),

          /// 🧾 DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "John Doe",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(Icons.male, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    const Text("Male", style: TextStyle(fontSize: 11)),
                    const SizedBox(width: 10),

                    /// Blood Group Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "B+",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Text(
                      "30 yrs",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// ✅ SELECT INDICATOR
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.primary : Colors.grey.shade200,
            ),
            child: Icon(
              isSelected ? Icons.check : Icons.circle,
              size: 14,
              color: isSelected ? Colors.white : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
