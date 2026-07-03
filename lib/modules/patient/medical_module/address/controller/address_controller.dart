import 'package:get/get.dart';
import 'package:timesmed_project/modules/patient/medical_module/address/model/address_model.dart';

class AddressController extends GetxController {
  final addresses = <AddressModel>[].obs;

  final selectedShippingIndex = (-1).obs;
  final selectedBillingIndex = (-1).obs;

  final sameAsShipping = false.obs;

  /// Dropdowns
  final selectedCountry = ''.obs;
  final selectedState = ''.obs;

  final countries = ["India", "USA", "UK"];
  final states = ["Tamil Nadu", "Kerala", "Karnataka"];

  void selectShipping(int index) {
    selectedShippingIndex.value = index;
  }

  void selectBilling(int index) {
    selectedBillingIndex.value = index;
  }

  void addAddress(AddressModel model) {
    addresses.add(model);
  }

  void selectCountry(String value) {
    selectedCountry.value = value;
  }

  void selectState(String value) {
    selectedState.value = value;
  }

  var expandedSection = "".obs;
  var searchText = "".obs;

  void toggleDropdown(String key) {
    if (expandedSection.value == key) {
      expandedSection.value = "";
    } else {
      expandedSection.value = key;
      searchText.value = "";
    }
  }

  void updateSearch(String val) {
    searchText.value = val;
  }

  void closeDropdown() {
    expandedSection.value = "";
    searchText.value = "";
  }
}
