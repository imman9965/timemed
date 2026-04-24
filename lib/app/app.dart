import 'package:flutter/material.dart';
import 'package:timesmed_project/app/theme/app_theme.dart';
import '../../core/config/app_config.dart';
import '../../routes/app_pages.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConfig.instance.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }

}
