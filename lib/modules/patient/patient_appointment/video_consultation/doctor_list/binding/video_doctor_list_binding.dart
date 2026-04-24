import 'package:get/get.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/doctor_list/controller/video_doctor_list_controller.dart';

class VideoDoctorListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoDoctorListController());
  }
}
