import 'package:get/get.dart';
import 'package:timesmed_project/modules/patient/patient_signup_page/controller/patient_signup_controller.dart';

class PatientSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PatientSignupController());
  }
}
