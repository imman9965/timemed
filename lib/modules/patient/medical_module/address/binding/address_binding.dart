import 'package:get/get.dart';
import 'package:timesmed_project/modules/patient/medical_module/address/controller/address_controller.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressController>(() => AddressController());
  }
}
