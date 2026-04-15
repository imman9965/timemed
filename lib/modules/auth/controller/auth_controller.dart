import 'package:get/get.dart';
import 'package:timesmed_project/core/config/app_config.dart';
import 'package:timesmed_project/core/storage/secure_storage.dart';
import 'package:timesmed_project/routes/app_pages.dart';

class AuthController extends GetxController {
  Future<void> logout() async {
    final SecureStorage storage = SecureStorage();

    /// remove token and role
    await storage.clearAll();
    await storage.logout();

    /// redirect based on flavor
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
        Get.offAllNamed(AppRoutes.superAdminHome);
        break;
    }
  }
}
