import 'package:get/get.dart';

class VideoDoctorListController extends GetxController {
  var doctors = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    /// Dummy Data
    doctors.value = [
      {
        "name": "Dr. Priya Sharma",
        "speciality": "Cardiologist",
        "experience": "10 yrs",
        "fee": "₹500",
        "image": "https://i.pravatar.cc/150?img=47",
        "available": "Today, 5:00 PM",
      },
      {
        "name": "Dr. John Mathew",
        "speciality": "Dermatologist",
        "experience": "7 yrs",
        "fee": "₹400",
        "image": "https://i.pravatar.cc/150?img=12",
        "available": "Tomorrow, 11:00 AM",
      },
    ];
  }
}
