import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class ClinicalDoctorListController extends GetxController {
  RxList<Map<String, dynamic>> doctors = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredDoctors = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    doctors.value = [
      {
        "name": "Dr. Mariappan",
        "degree": "MBBS",
        "speciality": "Child Specialist",
        "specialityId": 4,
        "experience": "3 Years",
        "fee": "₹550",
        "image": "https://i.pravatar.cc/150?img=3",
      },
      {
        "name": "Dr. Arjun",
        "degree": "MD",
        "speciality": "Cardiologist",
        "specialityId": 5,
        "experience": "8 Years",
        "fee": "₹700",
        "image": "https://i.pravatar.cc/150?img=5",
      },
      {
        "name": "Dr. Priya",
        "degree": "MBBS, DGO",
        "speciality": "Gynecologist",
        "specialityId": 6,
        "experience": "5 Years",
        "fee": "₹600",
        "image": "https://i.pravatar.cc/150?img=10",
      },
    ];

    filteredDoctors.value = doctors;
  }

  void searchDoctor(String query) {
    if (query.isEmpty) {
      filteredDoctors.value = doctors;
    } else {
      filteredDoctors.value = doctors
          .where(
            (doc) =>
                doc["name"].toLowerCase().contains(query.toLowerCase()) ||
                doc["speciality"].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
  }
}

class ClinicalDoctorListPage extends StatelessWidget {
  ClinicalDoctorListPage({super.key});

  final controller = Get.put(ClinicalDoctorListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6f8),
      appBar: CommonAppBar(title: "Doctors"),
      body: Column(
        children: [
          /// 🔍 SEARCH BAR
          _buildPremiumSearch(controller),

          /// 👨‍⚕️ LIST
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doc = controller.filteredDoctors[index];

                  return _doctorCard(context, doc);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 🔥 DOCTOR CARD
  Widget _doctorCard(BuildContext context, Map<String, dynamic> doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TOP ROW (Doctor + Fee Badge)
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(doc["image"]),
              ),

              const SizedBox(width: 12),

              /// NAME + SPECIALITY
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${doc["speciality"]} • ${doc["degree"]}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              /// FEE BADGE (like status badge)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  doc["fee"],
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// 🔹 DETAILS (like appointment info row)
          Row(
            children: [
              _infoChip(Icons.work_outline, doc["experience"]),
              const SizedBox(width: 10),
              _infoChip(Icons.medical_services_outlined, doc["speciality"]),
            ],
          ),

          const SizedBox(height: 12),

          /// 🔹 LOCATION (optional - matches your appointment style)
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  "Chennai - Apollo Clinic",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 🔹 CTA (same pattern as your appointment card)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    context.push(AppRoutes.clinicalDoctorDetails, extra: doc);
                  },
                  child: const Text("View Profile"),
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
                    context.push(AppRoutes.clinicalSchedule, extra: doc);
                  },
                  child: const Text("Book Now"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// Search
  Widget _buildPremiumSearch(ClinicalDoctorListController controller) {
    final TextEditingController searchCtrl = TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /// 🔍 ICON
              Icon(Icons.search, color: Colors.grey.shade600, size: 20),

              const SizedBox(width: 8),

              /// TEXT FIELD
              Expanded(
                child: TextField(
                  controller: searchCtrl,
                  onChanged: (value) {
                    controller.searchDoctor(value);
                    setState(() {});
                  },
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "Search doctor, speciality...",
                    border: InputBorder.none,
                  ),
                ),
              ),

              /// ❌ CLEAR BUTTON
              if (searchCtrl.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    searchCtrl.clear();
                    controller.searchDoctor("");
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
