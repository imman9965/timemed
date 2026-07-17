import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';

import 'package:timesmed_project/modules/patient/lab_test/lab_test_types/visit_lab/lab_test_checkout/service/payment_service.dart';
import 'package:timesmed_project/modules/patient/medical_module/records/model/medical_record_model.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientLabTestCheckoutPage extends StatefulWidget {
  final List<LabTest> labTest;
  final Map<String, dynamic> selectedLab;
  final String selectedTime;
  final String selectedDate;

  const PatientLabTestCheckoutPage({
    super.key,
    required this.labTest,
    required this.selectedLab,
    required this.selectedTime,
    required this.selectedDate,
  });

  @override
  State<PatientLabTestCheckoutPage> createState() =>
      _PatientLabTestCheckoutPageState();
}

class _PatientLabTestCheckoutPageState
    extends State<PatientLabTestCheckoutPage> {
  late LabTestCheckoutRazorpayService razorpayService;

  @override
  void initState() {
    super.initState();

    razorpayService = LabTestCheckoutRazorpayService();

    razorpayService.init(
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentFailure,
      onExternal: _handleExternalWallet,
    );
  }

  @override
  void dispose() {
    razorpayService.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(
      PaymentSuccessResponse response,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Successful"),
      ),
    );

    context.go(
      AppRoutes.patientLabTestBookingSuccess,
      extra: {
        "bookingId": "LAB248763",
        "labName": widget.selectedLab["name"],
        "testName": widget.labTest.length == 1 
            ? widget.labTest.first.testName 
            : "${widget.labTest.length} Tests",
        "date": widget.selectedDate,
        "time": widget.selectedTime,
        "location": widget.selectedLab["address"],
      },
    );
  }

  void _handlePaymentFailure(
      PaymentFailureResponse response,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
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
  Widget build(BuildContext context) {
    final lab = widget.selectedLab;
    final tests = widget.labTest;

    final int unitAmount = lab["price"];
    final int totalAmount = unitAmount * tests.length;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: CommonAppBar(
        title: "Confirm Booking",
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
              color: Colors.black.withOpacity(.05),
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                razorpayService.openCheckout(
                  amount: totalAmount * 100,
                  name: lab["name"],
                  description: tests.length == 1 
                      ? tests.first.testName 
                      : "${tests.length} Lab Tests",
                  contact: "9876543210",
                  email: "patient@gmail.com",
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(18),
                ),
              ),
              child: Text(
                "Pay ₹$totalAmount",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 SUCCESS HEADER
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(.82),
                  ],
                ),
                borderRadius:
                BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color:
                      Colors.white.withOpacity(.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.science,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    tests.length == 1 
                        ? tests.first.testName 
                        : "${tests.length} Tests Selected",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    tests.length == 1 
                        ? tests.first.category 
                        : tests.map((e) => e.testName).join(", "),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 LAB DETAILS
            _buildCard(
              title: "Laboratory Details",
              child: Column(
                children: [
                  _tile(
                    Icons.local_hospital,
                    "Lab Name",
                    lab["name"],
                  ),

                  _divider(),

                  _tile(
                    Icons.location_on_outlined,
                    "Address",
                    lab["address"],
                  ),

                  _divider(),

                  _tile(
                    Icons.star_outline,
                    "Rating",
                    lab["rating"],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 SLOT DETAILS
            _buildCard(
              title: "Appointment Slot",
              child: Column(
                children: [
                  _tile(
                    Icons.calendar_month,
                    "Date",
                    widget.selectedDate,
                  ),

                  _divider(),

                  _tile(
                    Icons.access_time,
                    "Time",
                    widget.selectedTime,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 PRICE CARD
            _buildCard(
              title: "Payment Summary",
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: [
                      Text(
                        "${tests.length} Lab Test Charge${tests.length > 1 ? 's' : ''}",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),

                      Text(
                        "₹$totalAmount",
                        style: const TextStyle(
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const Divider(),

                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: [
                      const Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),

                      Text(
                        "₹$totalAmount",
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.primary,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }

  Widget _tile(
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
            AppColors.primary.withOpacity(.08),
            borderRadius:
            BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Divider(
        color: Colors.grey.shade200,
      ),
    );
  }
}