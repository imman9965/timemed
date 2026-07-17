import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/core/widgets/title_Text_form_field.dart';
import 'package:timesmed_project/modules/patient/medical_module/address/controller/address_controller.dart';
import 'package:timesmed_project/modules/patient/medical_module/address/model/address_model.dart';
import 'package:timesmed_project/routes/app_routes.dart';

import '../../../../doctor/schedule_appointment/schedule_appointment.dart';

class AddressSelectionPage extends StatefulWidget {
  const AddressSelectionPage({super.key});

  @override
  State<AddressSelectionPage> createState() => _AddressSelectionPageState();
}

class _AddressSelectionPageState extends State<AddressSelectionPage> {
  String? expandedSection;
  final TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),

      appBar: CommonAppBar(title: "Select Address"),

      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  /// 🔹 SHIPPING
                  _sectionTitle("Shipping Address"),
                  _addressList(isShipping: true),

                  _addNewButton(context, isShipping: true),

                  const SizedBox(height: 20),

                  /// 🔹 BILLING
                  Row(
                    children: [
                      Obx(
                        () => Checkbox(
                          value: controller.sameAsShipping.value,
                          onChanged: (v) =>
                              controller.sameAsShipping.value = v!,
                        ),
                      ),
                      const Text("Same as Shipping"),
                    ],
                  ),

                  if (!controller.sameAsShipping.value) ...[
                    const SizedBox(height: 10),
                    _sectionTitle("Billing Address"),
                    _addressList(isShipping: false),
                    _addNewButton(context, isShipping: false),
                  ],
                ],
              ),
            ),

            _bottomButton(context),
          ],
        );
      }),
    );
  }

  Widget _addressList({required bool isShipping}) {
    final controller = Get.find<AddressController>();

    return Obx(() {
      return Column(
        children: controller.addresses.asMap().entries.map((entry) {
          int index = entry.key;
          final address = entry.value;

          final selected = isShipping
              ? controller.selectedShippingIndex.value == index
              : controller.selectedBillingIndex.value == index;

          return GestureDetector(
            onTap: () => isShipping
                ? controller.selectShipping(index)
                : controller.selectBilling(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withOpacity(0.08)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? AppColors.primary : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(address.address),
                        Text("${address.state}, ${address.country}"),
                        Text("Pin: ${address.pincode}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _addNewButton(BuildContext context, {required bool isShipping}) {
    final controller = Get.find<AddressController>();

    return GestureDetector(
      onTap: () {
        _showAddAddressDialog(context, controller, isShipping: isShipping);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 6, bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            /// ICON
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, color: AppColors.primary, size: 18),
            ),

            const SizedBox(width: 10),

            /// TEXT
            Expanded(
              child: Text(
                isShipping
                    ? "Add New Shipping Address"
                    : "Add New Billing Address",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog(
    BuildContext context,
    AddressController controller, {
    required bool isShipping,
  }) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final landmarkCtrl = TextEditingController();
    final pinCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxHeight: 600),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8FB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                /// 🔹 HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isShipping
                          ? "Add Shipping Address"
                          : "Add Billing Address",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// 🔹 FORM
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _premiumField(
                          TitleTextFormField(
                            controller: nameCtrl,
                            title: "Full Name",
                            hintText: "Enter Full Name",
                            prefixIcon: const Icon(Icons.person_outline),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),

                        _premiumField(
                          TitleTextFormField(
                            controller: phoneCtrl,
                            title: "Mobile Number",
                            maxLength: 10,
                            hintText: "Enter Mobile Number",
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(Icons.phone_outlined),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),

                        _premiumField(
                          TitleTextFormField(
                            controller: emailCtrl,
                            title: "Email",
                            hintText: "Enter Email",
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),

                        /// 🔹 COUNTRY
                        _premiumField(
                          _buildModernDropdown(
                            keyName: "country",
                            title: "Country",
                            value: controller.selectedCountry,
                            list: controller.countries,
                            onSelect: controller.selectCountry,
                            icon: Icons.public,
                          ),
                        ),

                        /// 🔹 STATE
                        _premiumField(
                          _buildModernDropdown(
                            keyName: "state",
                            title: "State",
                            value: controller.selectedState,
                            list: controller.states,
                            onSelect: controller.selectState,
                            icon: Icons.map,
                          ),
                        ),

                        _premiumField(
                          TitleTextFormField(
                            controller: addressCtrl,
                            title: "Address",
                            hintText: "Enter Address",
                            maxLines: 2,
                            prefixIcon: const Icon(Icons.home_outlined),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),

                        _premiumField(
                          TitleTextFormField(
                            controller: landmarkCtrl,
                            title: "Landmark",
                            hintText: "Enter Landmark",
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),

                        _premiumField(
                          TitleTextFormField(
                            controller: pinCtrl,
                            title: "Pincode",
                            hintText: "Enter Pincode",
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            prefixIcon: const Icon(Icons.pin_drop_outlined),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔥 ACTION BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final model = AddressModel(
                        name: nameCtrl.text,
                        phone: phoneCtrl.text,
                        email: emailCtrl.text,
                        country: controller.selectedCountry.value,
                        state: controller.selectedState.value,
                        landmark: landmarkCtrl.text,
                        address: addressCtrl.text,
                        pincode: pinCtrl.text,
                      );

                      controller.addAddress(model);

                      final index = controller.addresses.length - 1;

                      if (isShipping) {
                        controller.selectShipping(index);
                      } else {
                        controller.selectBilling(index);
                      }

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Save Address",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _premiumField(Widget child) {
    return Padding(padding: const EdgeInsets.only(bottom: 14), child: child);
  }

  Widget _bottomButton(BuildContext context) {
    final controller = Get.find<AddressController>();

    return Obx(() {
      final valid = controller.selectedShippingIndex.value != -1;

      return Container(
        padding: const EdgeInsets.all(16),
        child: CommonButton(
          title: "Continue to Payment",
          color: AppColors.primary,
          onPressed: () {
            if (valid) {
              context.push(AppRoutes.patientPrescriptionPayment);
            } else {
              null;
            }
          },
        ),
      );
    });
  }

  Widget _buildModernDropdown({
    required String keyName,
    required String title,
    required RxString value,
    required List<String> list,
    required Function(String) onSelect,
    required IconData icon,
  }) {
    final controller = Get.find<AddressController>();

    return Obx(() {
      final isOpen = controller.expandedSection.value == keyName;

      final filteredList = list
          .where(
            (e) => e.toLowerCase().contains(
              controller.searchText.value.toLowerCase(),
            ),
          )
          .toList();

      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          border: Border.all(
            color: isOpen ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            /// 🔹 HEADER
            InkWell(
              onTap: () => controller.toggleDropdown(keyName),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 12)),
                        Text(
                          value.value.isEmpty ? "Select $title" : value.value,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),

            /// 🔥 DROPDOWN BODY
            if (isOpen) ...[
              const SizedBox(height: 10),

              /// SEARCH
              TextField(
                onChanged: controller.updateSearch,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search),
                ),
              ),

              const SizedBox(height: 10),

              /// LIST
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredList.length,
                  itemBuilder: (_, index) {
                    final item = filteredList[index];
                    final selected = value.value == item;

                    return ListTile(
                      title: Text(item),
                      trailing: selected
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        onSelect(item);
                        controller.closeDropdown();
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
