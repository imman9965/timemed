import 'package:get/get.dart';
import 'package:timesmed_project/modules/patient/patient_login/controller/patient_login_controller.dart';

class PatientLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PatientLoginController());
  }
}
