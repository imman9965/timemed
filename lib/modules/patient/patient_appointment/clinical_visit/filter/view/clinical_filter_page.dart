import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/core/widgets/sapce.dart';
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
      appBar: CommonAppBar(title: "Clinical Visit"),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    const Space(height: 18),

                    /// 🔹 CITY
                    _buildModernDropdown(
                      keyName: "city",
                      title: "City",
                      value: controller.selectedCity,
                      list: controller.cities,
                      onSelect: controller.selectCity,
                      icon: Icons.location_city,
                    ),
                    const Space(height: 12),

                    /// 🔹 LOCATION
                    _buildModernDropdown(
                      keyName: "location",
                      title: "Location",
                      value: controller.selectedLocation,
                      list: controller.locations,
                      onSelect: controller.selectLocation,
                      icon: Icons.place,
                    ),
                    const Space(height: 12),

                    /// 🔹 HOSPITAL
                    _buildModernDropdown(
                      keyName: "hospital",
                      title: "Hospital",
                      value: controller.selectedHospital,
                      list: controller.hospitals,
                      onSelect: controller.selectHospital,
                      icon: Icons.local_hospital,
                    ),
                    const Space(height: 12),

                    /// 🔹 SPECIALITY
                    _buildModernDropdown(
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CommonButton(
              color: AppColors.primary,
              onPressed: () {
                context.push(AppRoutes.clinicalDoctorList);
              },
              title: "Find Doctors",
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 REUSABLE TILE (Same Pattern)
  Widget _buildModernDropdown({
    required String keyName,
    required String title,
    required RxString value,
    required List<String> list,
    required Function(String) onSelect,
    required IconData icon,
  }) {
    return Obx(() {
      final isOpen = expandedSection == keyName;

      final filteredList = list
          .where(
            (e) =>
                e.toLowerCase().contains(searchController.text.toLowerCase()),
          )
          .toList();

      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOpen ? const Color(0xff0673de) : AppColors.black,
            width: 1.2,
          ),
          color: Colors.white,
          boxShadow: [
            if (isOpen)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),

        child: Column(
          children: [
            /// 🔹 HEADER
            InkWell(
              onTap: () {
                setState(() {
                  expandedSection = isOpen ? null : keyName;
                  searchController.clear();
                });
              },
              child: Row(
                children: [
                  Icon(icon, color: const Color(0xff0673de), size: 20),
                  const SizedBox(width: 10),

                  /// TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value.value.isEmpty ? "Select $title" : value.value,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: value.value.isEmpty
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),

            /// 🔥 DROPDOWN CONTENT
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: isOpen
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox(),
              secondChild: Column(
                children: [
                  const SizedBox(height: 10),

                  /// 🔍 SEARCH
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: "Search...",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, size: 18),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 📋 LIST
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 180),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        final selected = value.value == item;

                        return InkWell(
                          onTap: () {
                            onSelect(item);
                            setState(() {
                              expandedSection = null;
                              searchController.clear();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selected
                                  ? const Color(0xff0673de).withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(item)),
                                if (selected)
                                  const Icon(
                                    Icons.check,
                                    color: Color(0xff0673de),
                                    size: 18,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  /// 🔹 REUSABLE TILE (Same Pattern)
  Widget _buildChips({
    required String title,
    required RxString selectedValue,
    required List<String> list,
    required Function(String) onSelect,
  }) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: list.map((item) {
              final isSelected = selectedValue.value == item;

              return ChoiceChip(
                label: Text(item),
                selected: isSelected,
                onSelected: (_) => onSelect(item),
                selectedColor: Color(0xff0673de),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 20),
        ],
      );
    });
  }
}
