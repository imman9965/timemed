import 'package:get/get.dart';
import 'package:timesmed_project/modules/patient/patient_order/controller/patient_order_controller.dart';

class PatientOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PatientOrderController());
  }
}
