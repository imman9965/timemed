import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/doctor_call_card.dart';
import 'dummy_data_4.dart';

// ─── Data Model ──────────────────────────────────────────────────────────────

// ─── Static Data ─────────────────────────────────────────────────────────────

// ─── Screen ──────────────────────────────────────────────────────────────────

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _menuExpanded = true;

  static const _blue = Color(0xFF1A6BF5);
  static const _darkBg = Color(0xFF1C1C1E);

  @override
  Widget build(BuildContext context) {
    // debugPrint(_test);
    return Scaffold(
      backgroundColor: _darkBg,
      body: Stack(
        children: [
          // ── Full-screen doctor "video" background ──────────────────────
          Positioned.fill(
            child: Container(
              color: const Color(0xFFD6DCE5),
              child: const Center(
                child: Icon(Icons.person, size: 220, color: Color(0xFFB0BAC8)),
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

          // ── Slide panel + chevron ──────────────────────────────────────
          Positioned(
            bottom: 110,
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Chevron toggle button
                GestureDetector(
                  onTap: () => setState(() => _menuExpanded = !_menuExpanded),
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
                      _menuExpanded ? Icons.chevron_right : Icons.chevron_left,
                      color: _blue,
                      size: 26,
                    ),
                  ),
                ),

                // Side menu panel
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: _menuExpanded
                      ? _buildSideMenu(context)
                      : const SizedBox(width: 0),
                ),
              ],
            ),
          ),

          // ── Bottom call controls bar ───────────────────────────────────
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: _buildCallControls(),
          ),
        ],
      ),
    );
  }

  // ─── Side Menu ────────────────────────────────────────────────────────────

  Widget _buildSideMenu(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A6BF5),
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
        children: menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == menuItems.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () {
                  if (item.route.isNotEmpty) {
                    context.go(item.route); // ✅ safe navigation
                  }
                },
                borderRadius: BorderRadius.only(
                  topLeft: index == 0 ? const Radius.circular(18) : Radius.zero,
                  bottomLeft: isLast ? const Radius.circular(18) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded( // ✅ prevents overflow
                        child: Text(
                          item.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                          ),
                        ),
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
        color: const Color(0xFF1A6BF5),
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
            onTap: () {},
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ctrl.isRed
                    ? const Color(0xFFE53935)
                    : const Color(0xFF2C2C2E),
                shape: BoxShape.circle,
              ),
              child: Icon(
                ctrl.icon,
                color: Colors.white,
                size: ctrl.isRed ? 22 : 20,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
