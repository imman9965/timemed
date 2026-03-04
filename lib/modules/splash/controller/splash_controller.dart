import 'package:get/get.dart';
import 'package:timesmed_project/core/config/app_config.dart';
import 'package:timesmed_project/core/storage/secure_storage.dart';
import 'package:timesmed_project/routes/app_pages.dart';

class SplashController extends GetxController {
  final SecureStorage _storage = SecureStorage();

  @override
  void onInit() {
    super.onInit();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final token = await _storage.getToken();
    final role = await _storage.getRole();

    /// 🟢 If No Token → Go To Correct Login Based On Flavor
    if (token == null || token.isEmpty) {
      switch (AppConfig.instance.flavor) {
        case AppFlavor.patient:
          Get.offAllNamed(AppRoutes.patientLogin);
          break;

        case AppFlavor.doctor:
          Get.offAllNamed(AppRoutes.doctorLogin);
          break;

        case AppFlavor.pharmacy:
          Get.offAllNamed(AppRoutes.pharmacyLogin);
          break;

        case AppFlavor.admin:
          Get.offAllNamed(AppRoutes.adminLogin);
          break;

        case AppFlavor.superApp:
          Get.offAllNamed(AppRoutes.superHome);
          break;
      }
      return;
    }

    /// 🔵 If Token Exists → Navigate Based On Role
    switch (role) {
      case 'patient':
        Get.offAllNamed(AppRoutes.patientHome);
        break;

      case 'doctor':
        Get.offAllNamed(AppRoutes.doctorDashboard);
        break;

      case 'pharmacy':
        Get.offAllNamed(AppRoutes.pharmacyHome);
        break;

      case 'admin':
        Get.offAllNamed(AppRoutes.adminDashboard);
        break;

      default:
        Get.offAllNamed(AppRoutes.patientLogin);
    }
  }
}
