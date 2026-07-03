import 'package:get/get.dart';

class ClinicalFilterController extends GetxController {
  RxString selectedCity = ''.obs;
  RxString selectedLocation = ''.obs;
  RxString selectedHospital = ''.obs;
  RxString selectedSpeciality = ''.obs;

  List<String> cities = [
    "Chennai",
    "Madurai",
    "Coimbatore",
    "Trichy",
    "Salem",
    "Tirunelveli",
    "Erode",
    "Vellore",
    "Thoothukudi",
    "Dindigul",
    "Kanchipuram",
    "Cuddalore",
  ];
  List<String> locations = [
    "Velachery",
    "T Nagar",
    "Anna Nagar",
    "Adyar",
    "OMR",
    "Porur",
    "Tambaram",
    "Chromepet",
    "Perambur",
    "Vadapalani",
    "Guindy",
    "Medavakkam",
    "Sholinganallur",
    "Ambattur",
    "Mylapore",
  ];
  List<String> hospitals = [
    "Apollo Hospitals",
    "Fortis Malar Hospital",
    "MIOT International",
    "Global Hospitals",
    "SRM Hospital",
    "Kauvery Hospital",
    "SIMS Hospital",
    "Billroth Hospital",
    "Vijaya Hospital",
    "Prashanth Hospitals",
    "Gleneagles Global Health City",
    "Chettinad Hospital",
  ];
  List<String> specialities = [
    "General Physician",
    "Cardiology",
    "Dermatology",
    "ENT",
    "Orthopedics",
    "Pediatrics",
    "Gynecology",
    "Neurology",
    "Psychiatry",
    "Gastroenterology",
    "Urology",
    "Oncology",
    "Pulmonology",
    "Endocrinology",
    "Diabetology",
    "Nephrology",
    "Ophthalmology",
    "Radiology",
    "Anesthesiology",
    "Physiotherapy",
  ];

  void selectCity(String v) => selectedCity.value = v;
  void selectLocation(String v) => selectedLocation.value = v;
  void selectHospital(String v) => selectedHospital.value = v;
  void selectSpeciality(String v) => selectedSpeciality.value = v;
}
