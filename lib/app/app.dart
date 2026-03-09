import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesmed_project/app/theme/app_text_theme.dart';
import '../../core/config/app_config.dart';
import '../../routes/app_pages.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      /// 🔥 Dynamic App Name
      title: AppConfig.instance.appName,

      /// 🌍 Global Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,

      /// 🚀 Initial Route
      initialRoute: AppRoutes.splash,

      /// 📌 All Routes
      getPages: AppPages.routes,

      /// 🌐 Default Transition
      defaultTransition: Transition.cupertino,
    );
  }

  /// 🔥 Decide First Screen
  // String _initialRoute() {
  //   switch (AppConfig.instance.flavor) {
  //     case AppFlavor.superApp:
  //       return AppRoutes.superHome;
  //     //return AppRoutes.login;
  //
  //     case AppFlavor.patient:
  //     case AppFlavor.doctor:
  //     case AppFlavor.pharmacy:
  //     case AppFlavor.admin:
  //       return AppRoutes.login;
  //   }
  // }

  /// 🎨 Flavor Based Color
  MaterialColor _getPrimaryColor() {
    switch (AppConfig.instance.flavor) {
      case AppFlavor.superApp:
        return Colors.purple;

      case AppFlavor.patient:
        return Colors.blue;

      case AppFlavor.doctor:
        return Colors.green;

      case AppFlavor.pharmacy:
        return Colors.orange;

      case AppFlavor.admin:
        return Colors.red;
    }
  }
}
