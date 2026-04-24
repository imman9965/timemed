import 'package:get/get.dart';

class ClinicalFilterController extends GetxController {
  RxString selectedCity = ''.obs;
  RxString selectedLocation = ''.obs;
  RxString selectedHospital = ''.obs;
  RxString selectedSpeciality = ''.obs;

  List<String> cities = ["Chennai", "Madurai", "Coimbatore"];
  List<String> locations = ["Velachery", "T Nagar", "OMR"];
  List<String> hospitals = ["Apollo", "SRM", "Global Hospital"];
  List<String> specialities = ["Cardiology", "Dermatology", "ENT"];

  void selectCity(String v) => selectedCity.value = v;
  void selectLocation(String v) => selectedLocation.value = v;
  void selectHospital(String v) => selectedHospital.value = v;
  void selectSpeciality(String v) => selectedSpeciality.value = v;
}
