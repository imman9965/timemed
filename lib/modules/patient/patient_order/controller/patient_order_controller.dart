import 'package:get/get.dart';

class PatientOrderController extends GetxController {
  var orders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    orders.value = [
      {
        "orderId": "#ORD1234",
        "date": "22 Apr 2026",
        "status": "Delivered",
        "total": "₹850",
        "medicines": [
          {"name": "Paracetamol", "qty": "2"},
          {"name": "Vitamin C", "qty": "1"},
        ],
      },
      {
        "orderId": "#ORD5678",
        "date": "20 Apr 2026",
        "status": "Pending",
        "total": "₹420",
        "medicines": [
          {"name": "Cough Syrup", "qty": "1"},
        ],
      },
    ];
  }
}
