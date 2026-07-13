import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';
import 'dummy_data_4.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _doctorMenuExpanded = true;
  bool _patientMenuExpanded = false;

  // Floating menu colours — glass style based on the dark background
  static final Color _menuBg = Colors.black.withOpacity(0.55);
  static final Color _menuToggleBg = Colors.black.withOpacity(0.55);
  static const Color _menuBorder = Colors.white24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔴 PATIENT VIDEO (Background)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/video_call/patient_video_call.jpg", // 👤 patient image
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
                /// Patient Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "John Doe",
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

          /// 🟡 DOCTOR PREVIEW (Floating)
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
                    "assets/images/video_call/doctor_video_call.jpg", // 👨‍⚕️ doctor image
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

          /// ── Floating side menus (unchanged options) ──
          Positioned(
            bottom: 148,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Doctor menu: Lab Test, Prescription, History ──────────
                _buildMenuRow(
                  context: context,
                  expanded: _doctorMenuExpanded,
                  collapsedIcon: Icons.medical_services,
                  items: doctorMenuItems,
                  onToggle: () => setState(
                    () => _doctorMenuExpanded = !_doctorMenuExpanded,
                  ),
                ),
                const SizedBox(height: 35),
                // ── Patient menu: Notes, Medical Records ──────────────────
                _buildMenuRow(
                  context: context,
                  expanded: _patientMenuExpanded,
                  collapsedIcon: Icons.person_outline,
                  items: patientMenuItems,
                  onToggle: () => setState(
                    () => _patientMenuExpanded = !_patientMenuExpanded,
                  ),
                ),
              ],
            ),
          ),

          /// 🔵 BOTTOM CONTROLS (GLASS STYLE — same options)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: _buildCallControls(),
          ),
        ],
      ),
    );
  }

  // ─── Side Menu ────────────────────────────────────────────────────────────

  /// One toggle button + its slide-out menu.
  Widget _buildMenuRow({
    required BuildContext context,
    required bool expanded,
    required IconData collapsedIcon,
    required List<MenuItem> items,
    required VoidCallback onToggle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Toggle button — group icon when closed, chevron when open
        GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _menuToggleBg,
              shape: BoxShape.circle,
              border: Border.all(color: _menuBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(-2, 0),
                ),
              ],
            ),
            child: Icon(
              expanded ? Icons.chevron_right : collapsedIcon,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: expanded
              ? _buildSideMenu(context, items)
              : const SizedBox(width: 0),
        ),
      ],
    );
  }

  Widget _buildSideMenu(BuildContext context, List<MenuItem> items) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: _menuBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          bottomLeft: Radius.circular(18),
        ),
        border: Border.all(color: _menuBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(-4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () {
                  if (item.route.isNotEmpty) {
                    context.push(item.route);
                  }
                },
                borderRadius: BorderRadius.only(
                  topLeft: index == 0 ? const Radius.circular(18) : Radius.zero,
                  topRight: index == 0
                      ? const Radius.circular(18)
                      : Radius.zero,
                  bottomLeft: isLast ? const Radius.circular(18) : Radius.zero,
                  bottomRight: isLast ? const Radius.circular(18) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        item.icon.toString(),
                        width: 22,
                        height: 22,
                        color: Colors.white,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          item.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

              if (!isLast)
                const Divider(
                  color: Colors.white30,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ─── Call Controls ────────────────────────────────────────────────────────

  Widget _buildCallControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: callControls.map((ctrl) {
          return GestureDetector(
            onTap: () {
              context.push(AppRoutes.consultationSummaryScreen);
            },
            child: Container(
              width: ctrl.isRed ? 60 : 48,
              height: ctrl.isRed ? 60 : 48,
              decoration: BoxDecoration(
                color: ctrl.isRed
                    ? Colors.red
                    : Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  ctrl.icon,
                  width: ctrl.isRed ? 25 : 20,
                  height: ctrl.isRed ? 25 : 20,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
