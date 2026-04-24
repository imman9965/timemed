import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
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
        "experience": "3 Years",
        "fee": "₹550",
        "image": "https://i.pravatar.cc/150?img=3",
      },
      {
        "name": "Dr. Arjun",
        "degree": "MD",
        "speciality": "Cardiologist",
        "experience": "8 Years",
        "fee": "₹700",
        "image": "https://i.pravatar.cc/150?img=5",
      },
      {
        "name": "Dr. Priya",
        "degree": "MBBS, DGO",
        "speciality": "Gynecologist",
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
      appBar: AppBar(title: const Text("Doctors")),
      body: Column(
        children: [
          /// 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: controller.searchDoctor,
              decoration: InputDecoration(
                hintText: "Search doctor or speciality...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

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
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          children: [
            /// 🔹 TOP ROW
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGE WITH BORDER
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(doc["image"]),
                  ),
                ),

                const SizedBox(width: 12),

                /// DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc["name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),

                      /// DEGREE CHIP
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          doc["degree"],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        doc["speciality"],
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                /// FEE TAG
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    doc["fee"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// 🔹 BOTTOM ROW
            Row(
              children: [
                /// RATING / EXPERIENCE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        doc["experience"],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// BOOK BUTTON (MODERN)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.push(AppRoutes.clinicalDoctorDetails, extra: doc);
                  },
                  child: const Text(
                    "Book Now",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
