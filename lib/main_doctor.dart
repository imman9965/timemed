import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/services/local_notification_service.dart';
import 'modules/doctor/doctor_basic_details/dummy_data_5.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig(
    baseUrl: "https://yourapi.com/api", // Same base URL
    appName: "TimesMed Health Care",
    flavor: AppFlavor.doctor,
  );
  await DoctorProfileStore.load();
  await LocalNotificationService.instance.init();
  runApp(const MyApp());
}
