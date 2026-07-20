import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/services/local_notification_service.dart';
import 'modules/doctor/doctor_basic_details/dummy_data_5.dart';
import 'modules/doctor/doctor_management/doctor_registry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig(
    baseUrl: "https://yourapi.com/api",
    appName: "TimesMed Health Care",
    flavor: AppFlavor.patient,
  );
  // Load the saved doctor profile from local storage (letterhead details).
  await DoctorProfileStore.load();
  await DoctorRegistry.instance.load();
  // Set up local notifications (channel + runtime permission).
  await LocalNotificationService.instance.init();
  runApp(const MyApp());
}
