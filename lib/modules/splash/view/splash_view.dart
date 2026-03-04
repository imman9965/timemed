import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/modules/splash/controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}
