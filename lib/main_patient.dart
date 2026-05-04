import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig(
    baseUrl: "https://yourapi.com/api",
    appName: "TimesMed Health Care",
    flavor: AppFlavor.patient,
  );
  runApp(const MyApp());
}