import 'package:get/get.dart';
import 'package:timesmed_project/modules/patient/speciality_doctors/controller/speciality_doctor_controller.dart';

class SpecialityDoctorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpecialityDoctorController());
  }
}
