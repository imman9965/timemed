import 'package:get/get.dart';

class PatientPrescriptionTrackOrderController extends GetxController {
  final RxDouble riderLat = 13.0827.obs;
  final RxDouble riderLng = 80.2707.obs;

  final RxDouble destLat = 13.0674.obs;
  final RxDouble destLng = 80.2376.obs;

  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    startTracking();
  }

  /// 🔥 Replace with API / WebSocket
  void startTracking() {
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;

      /// Simulate live movement
      ever(riderLat, (_) {});
      _simulateMovement();
    });
  }

  void _simulateMovement() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));

      riderLat.value += 0.0003;
      riderLng.value += 0.0003;
    }
  }
}
