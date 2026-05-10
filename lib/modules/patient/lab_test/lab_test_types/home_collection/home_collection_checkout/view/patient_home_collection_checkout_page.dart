import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/modules/patient/lab_test/lab_test_types/home_collection/home_collection_checkout/service/payment_service.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/model/medical_record_model.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientHomeCollectionCheckoutPage extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const PatientHomeCollectionCheckoutPage({
    super.key,
    required this.bookingData,
  });

  @override
  State<PatientHomeCollectionCheckoutPage> createState() =>
      _PatientHomeCollectionCheckoutPageState();
}

class _PatientHomeCollectionCheckoutPageState
    extends State<PatientHomeCollectionCheckoutPage> {
  final razorpayService = HomeCollectionCheckoutRazorpayService();

  late LabTest test;

  @override
  void initState() {
    super.initState();

    test = widget.bookingData["labTest"];

    razorpayService.init(
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentFailure,
      onExternal: _handleExternalWallet,
    );
  }

  void _handlePaymentSuccess(
      PaymentSuccessResponse response,
      ) {
    context.pushReplacement(
      AppRoutes.patientHomeCollectionSuccess,
      extra: {
        ...widget.bookingData,
        "paymentId": response.paymentId,
      },
    );
  }

  void _handlePaymentFailure(
      PaymentFailureResponse response,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          response.message ?? "Payment Failed",
        ),
      ),
    );
  }

  void _handleExternalWallet(
      ExternalWalletResponse response,
      ) {}

  @override
  void dispose() {
    razorpayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.bookingData;

    final double testPrice = 799;
    final double collectionFee = 99;
    final double platformFee = 29;
    final double total =
        testPrice + collectionFee + platformFee;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: CommonAppBar(
        title: "Checkout",
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              offset: const Offset(0, -3),
              color: Colors.black.withOpacity(.05),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    "₹${total.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    razorpayService.openCheckout(
                      amount: (total * 100).toInt(),
                      name: test.testName,
                      description:
                      "Home Collection Lab Test",
                      contact: data["mobile"],
                      email: "patient@gmail.com",
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Pay Now",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 TEST CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(.82),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(.14),
                          borderRadius:
                          BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.science,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              test.testName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              test.category,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _topCard(
                          Icons.calendar_month,
                          data["selectedDate"],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _topCard(
                          Icons.access_time,
                          data["selectedTime"],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            /// 🔹 ADDRESS CARD
            _sectionCard(
              title: "Collection Address",
              child: Column(
                children: [
                  _infoTile(
                    Icons.person_outline,
                    data["name"],
                  ),

                  _infoTile(
                    Icons.call_outlined,
                    data["mobile"],
                  ),

                  _infoTile(
                    Icons.location_on_outlined,
                    "${data["address"]}, ${data["landmark"]}",
                  ),

                  _infoTile(
                    Icons.pin_drop_outlined,
                    data["pincode"],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// 🔹 PAYMENT SUMMARY
            _sectionCard(
              title: "Payment Summary",
              child: Column(
                children: [
                  _priceRow(
                    "Lab Test Fee",
                    "₹799",
                  ),

                  const SizedBox(height: 14),

                  _priceRow(
                    "Home Collection Fee",
                    "₹99",
                  ),

                  const SizedBox(height: 14),

                  _priceRow(
                    "Platform Fee",
                    "₹29",
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                    ),
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  ),

                  _priceRow(
                    "Total",
                    "₹${total.toStringAsFixed(0)}",
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(.04),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }

  Widget _topCard(
      IconData icon,
      String text,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.14),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
      IconData icon,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
      String title,
      String value, {
        bool isBold = false,
      }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),

        const Spacer(),

        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}