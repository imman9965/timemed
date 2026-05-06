import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/core/widgets/sapce.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class VideoQueuePage extends StatefulWidget {
  const VideoQueuePage({super.key});

  @override
  State<VideoQueuePage> createState() => _VideoQueuePageState();
}

class _VideoQueuePageState extends State<VideoQueuePage> {
  int seconds = 14 * 60 + 59; // 14:59 mins
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        t.cancel();
      }
    });
  }

  List<PlatformFile> selectedFiles = [];
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatTime() {
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    return "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }

  void pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png'],
      );

      if (result != null) {
        setState(() {
          selectedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CommonAppBar(title: "Call Request"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔵 Queue Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, blurRadius: 6),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "You are in Queue",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// ⏱ Approx Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Approximate waiting time : ",
                          style: const TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${formatTime()} Mins",
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// 🔵 Circle Timer
                    SizedBox(
                      height: 140,
                      width: 140,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          /// 🔵 Background Circle
                          SizedBox(
                            height: 140,
                            width: 140,
                            child: CircularProgressIndicator(
                              value: seconds / (14 * 60 + 59), // progress
                              strokeWidth: 8,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation(
                                Colors.blue,
                              ),
                            ),
                          ),

                          /// 🔵 Inner Circle (Design)
                          Container(
                            height: 110,
                            width: 110,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [AppColors.primary, Colors.blueAccent],
                              ),
                            ),
                          ),

                          /// ⏱ Timer Text
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                formatTime(), // show full mm:ss
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "mins",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Kindly wait on the queue to consult Dr. Mariappan \n identify you are offline",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// 🖼 Illustration
                    Image.asset(
                      "assets/images/queue_waiting.png", // add your image
                      height: 160,
                    ),

                    const SizedBox(height: 16),

                    /// 📅 Appointment Details
                    const Text(
                      "Appointment Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 6),
                        Text("1/7/2026"),
                        SizedBox(width: 40),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 6),
                        Text("12:20 PM"),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const SizedBox(height: 20),
                    _buildFileUploadSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRoutes.videoCall);
        },
        child: const Icon(Icons.video_camera_back),
      ),
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Medical Records",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        /// Upload Card
        GestureDetector(
          onTap: pickFile,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.upload_file,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upload Medical Records",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "PDF, Image, Reports",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        /// File List
        if (selectedFiles.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedFiles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final file = selectedFiles[index];

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary),
                  color: AppColors.primary.withOpacity(0.05),
                ),
                child: Row(
                  children: [
                    /// File Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.insert_drive_file,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// File Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${(file.size / 1024).toStringAsFixed(1)} KB",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Remove Button
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          selectedFiles.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
