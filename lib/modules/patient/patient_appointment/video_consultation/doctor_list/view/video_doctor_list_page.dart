import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/waiting/view/video_waiting_page.dart';
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
      appBar: AppBar(title: const Text("Available Doctors")),
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
  Widget _doctorCard(BuildContext context, Map doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xfff5f9ff), Colors.white],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          /// Top Section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                /// Doctor Image
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(doctor["image"]),
                ),

                const SizedBox(width: 12),

                /// Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor["name"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor["speciality"],
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${doctor["experience"]} experience",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),

                /// Fee
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff0673de).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    doctor["fee"],
                    style: const TextStyle(
                      color: Color(0xff0673de),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Divider
          Divider(color: Colors.grey.shade200),

          /// Bottom Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Availability
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 18,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      doctor["available"],
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),

                /// Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0673de),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    /// 🔥 Call Waiting Dialog
                    WaitingDialog.show(
                      context,
                      onAccept: () {
                        context.push('/video-payment');
                      },
                    );
                  },
                  child: const Text("Book"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
