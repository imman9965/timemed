import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/waiting/view/video_waiting_page.dart';
import 'package:timesmed_project/routes/app_routes.dart';
import '../../../../../doctor/schedule_appointment/schedule_appointment.dart';
import '../controller/video_doctor_list_controller.dart';

class VideoDoctorListPage extends StatefulWidget {
  const VideoDoctorListPage({super.key});

  @override
  State<VideoDoctorListPage> createState() => _VideoDoctorListPageState();
}

class _VideoDoctorListPageState extends State<VideoDoctorListPage> {
  final controller = Get.find<VideoDoctorListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Available Doctors"),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.doctors.length,
          itemBuilder: (context, index) {
            final doctor = controller.doctors[index];
            return _doctorCard(context, doctor);
          },
        ),
      ),
    );
  }

  /// 🔥 Doctor Card UI
  Widget _doctorCard(BuildContext context, Map<String, dynamic> doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TOP SECTION
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Avatar with subtle border
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(doc["image"]),
                ),
              ),

              const SizedBox(width: 12),

              /// Name + Speciality
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
                      doc["speciality"],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              /// Fee Badge (clean + premium)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  doc["fee"],
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// 🔹 INFO ROW (chips style)
          Row(
            children: [
              _infoChip(Icons.work_outline, doc["experience"]),
              const SizedBox(width: 8),
              _infoChip(Icons.star, "4.5 Rating"),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 AVAILABILITY
          Row(
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                doc["available"],
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 🔹 BOOK BUTTON (full width - premium feel)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                WaitingDialog.show(
                  context,
                  onAccept: () {
                    context.push(AppRoutes.videoPayment);
                  },
                );
              },
              child: const Text(
                "Book Consultation",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 SMALL CHIP
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
}
