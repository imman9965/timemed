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

  double get total => subtotal + delivery;

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
                /// 🔹 ADDRESS CARD
                _card(
                  child: Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.blue),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Deliver to:\nMr. Vignesh, Chennai - 600001",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                /// 🔹 ORDER SUMMARY
                _card(
                  child: Column(
                    children: [
                      _row("Subtotal", "₹$subtotal"),
                      _row("Delivery", "₹$delivery"),
                      const Divider(),
                      _row("Total", "₹$total", isBold: true),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                /// 🔹 PAYMENT METHOD
                _card(
                  child: Row(
                    children: const [
                      Icon(Icons.account_balance_wallet, color: Colors.green),
                      SizedBox(width: 10),
                      Expanded(child: Text("Pay using Razorpay")),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 PAY BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: CommonButton(
              color: AppColors.primary,
              onPressed: _startPayment,
              title: "Pay ₹$total",
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _row(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
