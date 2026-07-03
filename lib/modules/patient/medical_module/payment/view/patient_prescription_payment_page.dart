import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/core/widgets/common_elevate_button.dart';
import 'package:timesmed_project/modules/patient/medical_module/payment/controller/patient_prescription_payment_controller.dart';
import 'package:timesmed_project/routes/app_routes.dart';

import '../../../../doctor/schedule_appointment/schedule_appointment.dart';

class PatientPrescriptionPaymentPage extends StatefulWidget {
  const PatientPrescriptionPaymentPage({super.key});

  @override
  State<PatientPrescriptionPaymentPage> createState() =>
      _PatientPrescriptionPaymentPageState();
}

class _PatientPrescriptionPaymentPageState
    extends State<PatientPrescriptionPaymentPage> {
  final PatientPrescriptionRazorpayService _razorpayService =
      PatientPrescriptionRazorpayService();

  final double subtotal = 500;
  final double delivery = 40;
  final double gstRate = 0.18;

  double get gstAmount => subtotal * gstRate;
  double get total => subtotal + delivery + gstAmount;

  @override
  void initState() {
    super.initState();

    _razorpayService.init(
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentFailure,
      onExternal: (_) {},
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final orderId =
        response.paymentId ?? "ORD${DateTime.now().millisecondsSinceEpoch}";

    context.pushReplacement(
      AppRoutes.patientPrescriptionOrderSuccess,
      extra: {"orderId": orderId, "amount": total},
    );
  }

  void _handlePaymentFailure(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _startPayment() {
    _razorpayService.openCheckout(
      amount: (total * 100).toInt(),
      name: "TimesMed",
      description: "Medicine Order",
      contact: "8610346904",
      email: "test@gmail.com",
    );
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),

      appBar: CommonAppBar(title: "Payment"),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// 🔹 ADDRESS SECTION
                const Text(
                  "Delivery Address",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.location_on,
                                color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "Mr. Vignesh",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Change",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Text(
                          "No 12, Gandhi Street, T.Nagar,\nChennai - 600017",
                          style: TextStyle(
                            color: AppColors.textSecond,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// 🔹 ORDER SUMMARY
                const Text(
                  "Order Summary",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                _card(
                  child: Column(
                    children: [
                      _row("Subtotal", "₹${subtotal.toStringAsFixed(2)}"),
                      _row("GST (18%)", "₹${gstAmount.toStringAsFixed(2)}"),
                      _row("Delivery Charges", "₹${delivery.toStringAsFixed(2)}"),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(height: 1, thickness: 1),
                      ),
                      _row(
                        "Total Amount",
                        "₹${total.toStringAsFixed(2)}",
                        isBold: true,
                        valueColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// 🔹 PAYMENT METHOD
                const Text(
                  "Payment Method",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                _card(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.account_balance_wallet,
                            color: Colors.green, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Pay using Razorpay",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 PAY BUTTON
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: CommonButton(
              color: AppColors.primary,
              onPressed: _startPayment,
              title: "Proceed to Pay ₹${total.toStringAsFixed(2)}",
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: child,
    );
  }

  Widget _row(String title, String value,
      {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? AppColors.textDark : AppColors.textSecond,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
