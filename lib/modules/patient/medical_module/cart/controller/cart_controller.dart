import 'package:get/get.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/model/medical_record_model.dart';

class CartController extends GetxController {
  final cartItems = <PrescriptionItem>[].obs;

  double get totalAmount =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  int get totalItems => cartItems.length;

  void setCartItems(List<PrescriptionItem> items) {
    cartItems.assignAll(items);
  }

  /// 🔹 Increase
  void increaseQty(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  /// 🔹 Decrease (auto remove if 1)
  void decreaseQty(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
    } else {
      cartItems.removeAt(index); // ✅ remove when 1
    }
    cartItems.refresh();
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
  }
}
