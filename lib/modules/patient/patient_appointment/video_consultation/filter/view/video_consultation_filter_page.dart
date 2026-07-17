import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/filter/controller/video_filter_controller.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/waiting/view/video_waiting_page.dart';
import 'package:timesmed_project/routes/app_routes.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import '../../../../../doctor/schedule_appointment/schedule_appointment.dart'
    hide AppColors;

class VideoConsultationFilterPage extends StatefulWidget {
  VideoConsultationFilterPage({super.key});

  @override
  State<VideoConsultationFilterPage> createState() =>
      _VideoConsultationFilterPageState();
}

class _VideoConsultationFilterPageState
    extends State<VideoConsultationFilterPage> {
  final controller = Get.find<VideoFilterController>();

  String? expandedSection; // doctor, speciality, symptoms, language
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Video Consultation"),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 SECTION 1: Doctor
                    const Text(
                      "Search by Doctor",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildModernDropdown(
                      keyName: "doctor",
                      title: "Doctor",
                      value: controller.selectedDoctor,
                      list: controller.doctors,
                      onSelect: controller.selectDoctor,
                      icon: Icons.person,
                    ),

                    const SizedBox(height: 10),

                    /// 🔸 OR Divider
                    _buildOrDivider(),

                    const SizedBox(height: 10),

                    /// 🔹 SECTION 2: Filters
                    const Text(
                      "Filter by Details",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildModernDropdown(
                      keyName: "speciality",
                      title: "Speciality",
                      value: controller.selectedSpeciality,
                      list: controller.specialities,
                      onSelect: controller.selectSpeciality,
                      icon: Icons.medical_services,
                    ),

                    _buildModernDropdown(
                      keyName: "symptoms",
                      title: "Symptoms",
                      value: controller.selectedSymptoms,
                      list: controller.symptoms,
                      onSelect: controller.selectSymptoms,
                      icon: Icons.sick,
                    ),

                    _buildModernDropdown(
                      keyName: "language",
                      title: "Language",
                      value: controller.selectedLanguage,
                      list: controller.languages,
                      onSelect: controller.selectLanguage,
                      icon: Icons.language,
                    ),

                    const SizedBox(height: 10),

                    /// 🔸 OR Divider
                    _buildOrDivider(),

                    const SizedBox(height: 10),

                    /// 🔹 SECTION 3: Post Query (Improved UI)
                    const Text(
                      "Post Your Query",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildQueryBox(),
                  ],
                ),
              ),
            ),
          ),

          /// Bottom Buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (controller.isDoctorSelected) {
                        WaitingDialog.show(
                          context,

                          onAccept: () {
                            context.push(AppRoutes.videoPayment);
                          },

                          onReject: () {
                            // optional: show snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Doctor rejected")),
                            );
                          },
                        );
                      } else {
                        context.push(AppRoutes.videoDoctorList);
                      }
                    },
                    child: const Text("Instant"),
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
                      context.push(AppRoutes.videoSchedule);
                    },
                    child: const Text("Schedule"),
                  ),
                ),
              ],
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
            color: isOpen ? Color(0xff0673de) : AppColors.black,
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
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value.value.isEmpty ? "Select $title" : value.value,
                          style: TextStyle(
                            fontSize: 13,
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

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("OR", style: TextStyle(color: AppColors.primary)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildQueryBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Describe your problem",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 6),

          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "E.g. I have fever and headache for 2 days...",
              border: InputBorder.none,
            ),
          ),

          const SizedBox(height: 10),

          /// Optional Attach / Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.mic, size: 18, color: Colors.grey),
                  SizedBox(width: 6),
                  Text("Voice"),
                ],
              ),
              Row(
                children: const [
                  Icon(Icons.image, size: 18, color: Colors.grey),
                  SizedBox(width: 6),
                  Text("Attach"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
