import 'package:get/get.dart';

class VideoFilterController extends GetxController {
  var selectedDoctor = ''.obs;
  var selectedSpeciality = ''.obs;
  var selectedSymptoms = ''.obs;
  var selectedLanguage = ''.obs;

  /// Dummy Data
  final doctors = ['Dr. John', 'Dr. Smith', 'Dr. Priya'];
  final specialities = ['Cardiology', 'Dermatology', 'General'];
  final symptoms = ['Fever', 'Cold', 'Headache'];
  final languages = ['English', 'Tamil', 'Hindi'];

  void selectDoctor(String value) => selectedDoctor.value = value;
  void selectSpeciality(String value) => selectedSpeciality.value = value;
  void selectSymptoms(String value) => selectedSymptoms.value = value;
  void selectLanguage(String value) => selectedLanguage.value = value;

  bool get isDoctorSelected => selectedDoctor.value.isNotEmpty;
}
