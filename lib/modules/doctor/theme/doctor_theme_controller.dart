import 'package:get/get.dart';

/// Controls light / dark theme state for the Doctor module.
///
/// Register in [DoctorShellScreen.initState] via [Get.put].
/// Access anywhere in the doctor module via [DoctorThemeController.to].
class DoctorThemeController extends GetxController {
  static DoctorThemeController get to => Get.find<DoctorThemeController>();

  final _isDark = false.obs;

  bool get isDark => _isDark.value;

  void toggle() => _isDark.value = !_isDark.value;
  void setLight() => _isDark.value = false;
  void setDark() => _isDark.value = true;
}
