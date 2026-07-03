import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/modules/patient/patient_appointment/clinical_visit/payment/service/payment_service.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class ClinicalVisitPaymentPage extends StatefulWidget {
  const ClinicalVisitPaymentPage({super.key});

  @override
  State<ClinicalVisitPaymentPage> createState() =>
      _ClinicalVisitPaymentPageState();
}

class _ClinicalVisitPaymentPageState extends State<ClinicalVisitPaymentPage> {
  final ClinicalRazorpayService _razorpayService = ClinicalRazorpayService();

  @override
  void initState() {
    super.initState();

    _razorpayService.init(
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentFailure,
      onExternal: _handleExternalWallet,
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("SUCCESS: ${response.paymentId}");

    /// ✅ Navigate after success
    context.push(AppRoutes.clinicalConfirmation);
  }

  void _handlePaymentFailure(PaymentFailureResponse response) {
    debugPrint("ERROR: ${response.message}");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("WALLET: ${response.walletName}");
  }

  void _startPayment() {
    _razorpayService.openCheckout(
      amount: 500 * 100, // ₹500 → paise
      name: "TimesMed",
      description: "Doctor Consultation",
      contact: "8610346904",
      email: "test@gmail.com",
      // orderId: "optional_if_you_have_backend"
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
      appBar: CommonAppBar(title: "Payment"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Doctor Card (Clean UI)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade200, blurRadius: 10),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(radius: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dr. Priya",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Consultation Fee",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "₹500",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// Pay Button
            ElevatedButton(
              onPressed: _startPayment,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}
