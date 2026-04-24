import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/clinical_visit/filter/controller/clinical_filter_controller.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class ClinicalFilterPage extends StatefulWidget {
  const ClinicalFilterPage({super.key});

  @override
  State<ClinicalFilterPage> createState() => _ClinicalFilterPageState();
}

class _ClinicalFilterPageState extends State<ClinicalFilterPage> {
  final controller = Get.put(ClinicalFilterController());

  String? expandedSection;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clinical Visit")),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 TITLE
                    const Text(
                      "Find Doctors Near You",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// 🔹 CITY
                    _buildExpandableTile(
                      keyName: "city",
                      title: "City",
                      value: controller.selectedCity,
                      list: controller.cities,
                      onSelect: controller.selectCity,
                      icon: Icons.location_city,
                    ),

                    /// 🔹 LOCATION
                    _buildExpandableTile(
                      keyName: "location",
                      title: "Location",
                      value: controller.selectedLocation,
                      list: controller.locations,
                      onSelect: controller.selectLocation,
                      icon: Icons.place,
                    ),

                    /// 🔹 HOSPITAL
                    _buildExpandableTile(
                      keyName: "hospital",
                      title: "Hospital",
                      value: controller.selectedHospital,
                      list: controller.hospitals,
                      onSelect: controller.selectHospital,
                      icon: Icons.local_hospital,
                    ),

                    /// 🔹 SPECIALITY
                    _buildExpandableTile(
                      keyName: "speciality",
                      title: "Speciality",
                      value: controller.selectedSpeciality,
                      list: controller.specialities,
                      onSelect: controller.selectSpeciality,
                      icon: Icons.medical_services,
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 🔥 BOTTOM BUTTON
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                context.push(AppRoutes.clinicalDoctorList);
              },
              child: const Text("Select Doctor for Clinical Appointment"),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 REUSABLE TILE (Same Pattern)
  Widget _buildExpandableTile({
    required String keyName,
    required String title,
    required RxString value,
    required List<String> list,
    required Function(String) onSelect,
    required IconData icon,
  }) {
    return Obx(() {
      bool isExpanded = expandedSection == keyName;

      List<String> filteredList = list
          .where(
            (item) => item.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();

      return Column(
        children: [
          /// 🔹 HEADER
          GestureDetector(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedSection = null;
                  searchController.clear();
                } else {
                  expandedSection = keyName;
                  searchController.clear();
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(icon, color: const Color(0xff0673de)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value.value.isEmpty ? "Select $title" : value.value,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),

          /// 🔥 EXPAND LIST
          if (isExpanded)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  /// 🔍 SEARCH
                  TextField(
                    controller: searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Search $title",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 📋 LIST
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];

                        return ListTile(
                          title: Text(item),
                          trailing: value.value == item
                              ? const Icon(
                                  Icons.check,
                                  color: Color(0xff0673de),
                                )
                              : null,
                          onTap: () {
                            onSelect(item);
                            setState(() {
                              expandedSection = null;
                              searchController.clear();
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }
}
