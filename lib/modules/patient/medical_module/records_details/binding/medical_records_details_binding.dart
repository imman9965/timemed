import 'package:get/get.dart';
import 'package:timesmed_project/modules/patient/medical_module/records_details/controller/midical_record_details_controller.dart';

class MedicalRecordsDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicalRecordsDetailsController>(
      () => MedicalRecordsDetailsController(),
    );
  }
}
