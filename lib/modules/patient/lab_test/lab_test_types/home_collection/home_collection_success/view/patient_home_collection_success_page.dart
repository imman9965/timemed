import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientHomeCollectionSuccessPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const PatientHomeCollectionSuccessPage({
    super.key,
    required this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    final test = bookingData["labTest"];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
appBar: CommonAppBar(title: "Booking Successful"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// 🔹 SUCCESS ICON
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(.1),
                ),
                child: Center(
                  child: Container(
                    height: 86,
                    width: 86,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// 🔹 TITLE
              const Text(
                "Booking Successful",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Your home sample collection has been booked successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 30),

              /// 🔹 BOOKING CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      color: Colors.black.withOpacity(.04),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// TEST INFO
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(.08),
                            borderRadius:
                            BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.science,
                            color: AppColors.primary,
                            size: 30,
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
                                  fontWeight:
                                  FontWeight.w700,
                                  fontSize: 17,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                test.category,
                                style: TextStyle(
                                  color:
                                  Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 22,
                      ),
                      child: Divider(),
                    ),

                    /// 🔹 DETAILS
                    _detailTile(
                      icon: Icons.calendar_month,
                      title: "Collection Date",
                      value:
                      bookingData["selectedDate"],
                    ),

                    _detailTile(
                      icon: Icons.access_time,
                      title: "Collection Time",
                      value:
                      bookingData["selectedTime"],
                    ),

                    _detailTile(
                      icon: Icons.person_outline,
                      title: "Patient Name",
                      value: bookingData["name"],
                    ),

                    _detailTile(
                      icon: Icons.location_on_outlined,
                      title: "Collection Address",
                      value:
                      "${bookingData["address"]}, ${bookingData["landmark"]}",
                    ),

                    _detailTile(
                      icon: Icons.payments_outlined,
                      title: "Payment ID",
                      value:
                      bookingData["paymentId"] ??
                          "TXN98456231",
                    ),

                    const SizedBox(height: 10),

                    /// 🔹 STATUS
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color:
                        Colors.green.withOpacity(.08),
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                      child: const Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.verified,
                            color: Colors.green,
                            size: 20,
                          ),

                          SizedBox(width: 10),

                          Text(
                            "Technician Assigned",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// 🔹 BUTTONS
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(AppRoutes.patientHome);
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
                    "Back To Home",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color:
                      AppColors.primary.withOpacity(.2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Download Receipt",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 18,
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
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}