import 'package:get/get.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/video_consultation/filter/controller/video_filter_controller.dart';

class VideoFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoFilterController());
  }
}
