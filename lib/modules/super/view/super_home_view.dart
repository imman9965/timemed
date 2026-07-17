import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class SuperHomeView extends StatefulWidget {
  const SuperHomeView({super.key});

  @override
  State<SuperHomeView> createState() => _SuperHomeViewState();
}

class _SuperHomeViewState extends State<SuperHomeView> {
  final List<_AppItem> apps = [
    _AppItem("Patient", Icons.person, Colors.blue),
    _AppItem("Doctor", Icons.medical_services, Colors.teal),
    _AppItem("Pharmacy", Icons.local_pharmacy, Colors.orange),
    _AppItem("Admin", Icons.admin_panel_settings, Colors.deepPurple),
  ];

  void _navigate(int index) {
    switch (index) {
      case 0:
        context.push(AppRoutes.patientSelection);
        break;
      case 1:
        context.push(AppRoutes.doctorWaitingList);
        break;
      case 2:
        context.push(AppRoutes.pharmacyLogin);
        break;
      case 3:
        context.push(AppRoutes.adminLogin);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,

      /// ✅ AppBar Style Header
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 4,
        title: const Text(
          "Super Admin Panel",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        /// ✅ Compact Grid
        child: GridView.builder(
          itemCount: apps.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.2, // 🔥 makes it compact like buttons
          ),
          itemBuilder: (context, index) {
            return TweenAnimationBuilder(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 400 + (index * 100)),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: _smallCard(
                item: apps[index],
                onTap: () => _navigate(index),
              ),
            );
          },
        ),
      ),
    );
  }

  /// ✅ Small Button Style Card
  Widget _smallCard({required _AppItem item, required VoidCallback onTap}) {
    return _PressableCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [item.color.withOpacity(0.9), item.color.withOpacity(0.7)],
          ),
          boxShadow: [
            BoxShadow(
              color: item.color.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(item.icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

/// Model
class _AppItem {
  final String title;
  final IconData icon;
  final Color color;

  _AppItem(this.title, this.icon, this.color);
}

/// Tap Animation
class _PressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PressableCard({required this.child, required this.onTap});

  @override
  State<_PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<_PressableCard> {
  double scale = 1;

  void _onTapDown(_) => setState(() => scale = 0.96);
  void _onTapUp(_) => setState(() => scale = 1);
  void _onTapCancel() => setState(() => scale = 1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}
