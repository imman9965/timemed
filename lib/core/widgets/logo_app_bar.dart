import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:timesmed_project/core/constants/app_colors.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const LogoAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      backgroundColor: Colors.transparent,

      /// 🔥 Gradient background
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),

      /// 🔙 Back button
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            )
          : null,

      /// 🧾 Logo + Title
      title: Container(
        padding: const EdgeInsets.all(6),

        child: SvgPicture.asset(
          "assets/logos/svg/timesmed_logo.svg",
          height: 28,
          width: 28,
          color: Colors.white,
        ),
      ),

      centerTitle: true,

      /// Actions
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
