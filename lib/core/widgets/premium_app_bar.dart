import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';

class PremiumAppBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;

  final bool showProfile;
  final String? profileImage;

  final bool showNotification;
  final int notificationCount;

  final bool showLogout;
  final VoidCallback? onLogout;

  final List<Widget>? actions;

  const PremiumAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBack,
    this.showProfile = false,
    this.profileImage,
    this.showNotification = false,
    this.notificationCount = 0,
    this.showLogout = false,
    this.onLogout,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          /// 🔥 BACKGROUND ICON (SUBTLE)
          /* Positioned(
            right: 20,
            top: 10,
            child: SvgPicture.asset(
              "assets/logos/svg/timesmed_logo.svg",
              width: 70,
              height: 70,
              color: Colors.white.withOpacity(0.1),
            ),
          ),*/
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  /// 🔙 BACK
                  if (showBack)
                    IconButton(
                      onPressed: onBack ?? () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),

                  /// 👤 PROFILE (OPTIONAL)
                  if (showProfile)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: profileImage != null
                            ? NetworkImage(profileImage!)
                            : null,
                        child: profileImage == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                    ),

                  /// 📝 TITLE
                  Expanded(
                    child: Text(
                      title,
                      textAlign: showBack || showProfile
                          ? TextAlign.start
                          : TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /// 🔔 NOTIFICATION
                  if (showNotification)
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                        ),
                        if (notificationCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "$notificationCount",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                  /// ⚙️ CUSTOM ACTIONS
                  if (actions != null) ...actions!,

                  /// 🚪 LOGOUT
                  if (showLogout)
                    IconButton(
                      onPressed: onLogout,
                      icon: const Icon(Icons.logout, color: Colors.white),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
