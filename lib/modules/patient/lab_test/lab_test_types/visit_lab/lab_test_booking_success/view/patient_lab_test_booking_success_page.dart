import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/routes/app_routes.dart';


class PatientLabTestBookingSuccessPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const PatientLabTestBookingSuccessPage({
    super.key,
    required this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: CommonAppBar(
        title: "Booking Confirmed",
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              color: Colors.black.withOpacity(.05),
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                context.go(AppRoutes.patientHome);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Back To Home",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// SUCCESS ICON
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(.12),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 72,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Lab Test Booked Successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Your lab slot has been confirmed successfully.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 28),

            /// BOOKING CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.04),
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _row(
                    "Booking ID",
                    bookingData["bookingId"],
                  ),

                  _divider(),

                  _row(
                    "Lab Test",
                    bookingData["testName"],
                  ),

                  _divider(),

                  _row(
                    "Laboratory",
                    bookingData["labName"],
                  ),

                  _divider(),

                  _row(
                    "Date",
                    bookingData["date"],
                  ),

                  _divider(),

                  _row(
                    "Time",
                    bookingData["time"],
                  ),

                  _divider(),

                  _row(
                    "Location",
                    bookingData["location"],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// STATUS CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: AppColors.primary.withOpacity(.08),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(.15),
                    ),
                    child: const Icon(
                      Icons.science,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Sample Collection Status",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Please visit the lab 10 mins before your slot timing.",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Divider(
        height: 1,
        color: Colors.grey.shade200,
      ),
    );
  }
}