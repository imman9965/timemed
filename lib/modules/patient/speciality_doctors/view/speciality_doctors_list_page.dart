import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/modules/patient/speciality_doctors/controller/speciality_doctor_controller.dart';
import 'package:timesmed_project/routes/app_routes.dart';

import '../../../doctor/schedule_appointment/schedule_appointment.dart';

class SpecialityDoctorsListPage extends StatefulWidget {
  final Map<String, dynamic>? speciality;

  const SpecialityDoctorsListPage({super.key, this.speciality});

  @override
  State<SpecialityDoctorsListPage> createState() =>
      _SpecialityDoctorsListPageState();
}

class _SpecialityDoctorsListPageState extends State<SpecialityDoctorsListPage> {
  final controller = Get.find<SpecialityDoctorController>();

  @override
  void initState() {
    super.initState();

    /// 🔥 Apply initial speciality
    if (widget.speciality != null) {
      controller.selectedSpecialityId.value = widget.speciality!["id"];
      controller.applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6f8),
      appBar: CommonAppBar(title: "Doctors"),
      body: Column(
        children: [
          _premiumSearchWithFilter(),

          Expanded(
            child: Obx(() {
              final list = controller.filteredDoctors;

              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "No doctors found",
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Try different search or filter",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final doc = list[index];
                  return _doctorCard(context, doc);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// DOCTOR INFO
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
                        fontSize: 14,
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
                    fontSize: 13,
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

  /// INFO
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

  ///
  Widget _premiumSearchWithFilter() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          /// 🔍 SEARCH
          _searchField(),

          const SizedBox(height: 12),

          /// 🔥 FILTER CHIPS
          _specialityChips(),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Obx(() {
      final hasSearch = controller.searchText.value.isNotEmpty;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey.shade600),

            const SizedBox(width: 8),

            Expanded(
              child: TextField(
                controller: controller.searchCtrl,
                onChanged: (value) {
                  controller.searchText.value = value;
                  controller.applyFilters();
                },
                decoration: const InputDecoration(
                  hintText: "Search doctor or speciality",
                  border: InputBorder.none,
                ),
              ),
            ),

            if (hasSearch)
              GestureDetector(
                onTap: controller.clearSearch,
                child: const Icon(Icons.close),
              ),
          ],
        ),
      );
    });
  }

  Widget _specialityChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.specialities.length,
        itemBuilder: (context, index) {
          final item = controller.specialities[index];

          return Obx(() {
            final isSelected =
                controller.selectedSpecialityId.value == item["id"];

            return GestureDetector(
              onTap: () => controller.selectSpeciality(item["id"]),

              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item["name"],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),

                    if (isSelected) ...[
                      const SizedBox(width: 4),

                      GestureDetector(
                        onTap: controller.clearSpeciality,
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
