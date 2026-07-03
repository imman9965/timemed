import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/doctor_call_card.dart';
import '../../../routes/app_routes.dart';
import '../theme/doctor_colors.dart';
import 'dummy_data_4.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _doctorMenuExpanded = true;
  bool _patientMenuExpanded = false;

  static const _blue = DoctorColors.primaryVivid;
  static const _darkBg = DoctorColors.callDarkBg;

  @override
  Widget build(BuildContext context) {
    // debugPrint(_test);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: _darkBg,
          body: Stack(
            children: [
              // ── Full-screen doctor "video" background ──────────────────────
              Positioned.fill(
                child: Container(
                  color: DoctorColors.avatarLight,
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 220,
                      color: DoctorColors.avatarMid,
                    ),
                  ),
                ),
              ),

              // ── Top status bar ─────────────────────────────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: DoctorCallCard(key: const ValueKey('doctor_call_card')),
              ),

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
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: _buildCallControls(),
              ),
            ],
          ),
        ),
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
              color: Colors.white,
              shape: BoxShape.circle,
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
              color: _blue,
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
        color: DoctorColors.primaryVivid,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          bottomLeft: Radius.circular(18),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: DoctorColors.primaryVivid,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
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
                    ? DoctorColors.error
                    : DoctorColors.callDarkSurface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  ctrl.icon,
                  width: ctrl.isRed ? 25 : 20,
                  height: ctrl.isRed ? 25 : 20,
                  color: Colors.white, // optional
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
