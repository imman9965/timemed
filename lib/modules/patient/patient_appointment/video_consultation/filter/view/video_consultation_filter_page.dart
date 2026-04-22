import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/filter/controller/video_filter_controller.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/waiting/view/video_waiting_page.dart';
import 'package:timesmed_project/routes/app_routes.dart';

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
      appBar: AppBar(title: const Text("Video Consultation")),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildExpandableTile(
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildExpandableTile(
                      keyName: "speciality",
                      title: "Speciality",
                      value: controller.selectedSpeciality,
                      list: controller.specialities,
                      onSelect: controller.selectSpeciality,
                      icon: Icons.medical_services,
                    ),

                    _buildExpandableTile(
                      keyName: "symptoms",
                      title: "Symptoms",
                      value: controller.selectedSymptoms,
                      list: controller.symptoms,
                      onSelect: controller.selectSymptoms,
                      icon: Icons.sick,
                    ),

                    _buildExpandableTile(
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
                        fontSize: 16,
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
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
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
                  child: OutlinedButton(
                    onPressed: () {
                      Get.toNamed('/video-schedule');
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

  /// 🔹 Reusable Tile
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
          /// 🔹 Header Tile
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

          /// 🔥 Expandable Section
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
                  /// 🔍 Search
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

                  /// 📋 List
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

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("OR", style: TextStyle(color: Colors.grey)),
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
            style: TextStyle(fontSize: 13, color: Colors.grey),
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
