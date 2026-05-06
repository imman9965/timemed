import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/rating/view/rating_page.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({super.key});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool isMuted = false;
  bool isCameraOff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔴 DOCTOR VIDEO (Background)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/video_call/doctor_video_call.jpg", // 👨‍⚕️ doctor image
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 🌑 DARK OVERLAY (for readability)
          Container(color: Colors.black.withOpacity(0.3)),

          /// 🟢 TOP INFO BAR
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Doctor Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Dr. John Doe",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text("00:12:45", style: TextStyle(color: Colors.white70)),
                  ],
                ),

                /// Call Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "LIVE",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          /// 🟡 PATIENT PREVIEW (Floating)
          Positioned(
            top: 120,
            right: 16,
            child: Container(
              height: 140,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 2),
                image: const DecorationImage(
                  image: AssetImage(
                    "assets/images/video_call/patient_video_call.jpg", // 👤 patient image
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          /// 🔵 BOTTOM CONTROLS (GLASS STYLE)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// Mute
                  _controlButton(
                    icon: isMuted ? Icons.mic_off : Icons.mic,
                    onTap: () => setState(() => isMuted = !isMuted),
                  ),

                  /// End Call
                  _endCallButton(context),

                  /// Camera
                  _controlButton(
                    icon: isCameraOff ? Icons.videocam_off : Icons.videocam,
                    onTap: () => setState(() => isCameraOff = !isCameraOff),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔘 CONTROL BUTTON
  Widget _controlButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.black.withOpacity(0.6),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  /// 🔴 END CALL BUTTON
  Widget _endCallButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (_) => const RatingPage()),
        // );
        context.pushReplacement(AppRoutes.rating);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: const Icon(Icons.call_end, color: Colors.white),
      ),
    );
  }
}
