import 'package:flutter/material.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';

class PatientLabTrackingPage extends StatefulWidget {
  const PatientLabTrackingPage({super.key});

  @override
  State<PatientLabTrackingPage> createState() =>
      _PatientLabTrackingPageState();
}

class _PatientLabTrackingPageState
    extends State<PatientLabTrackingPage> {
  final List<Map<String, dynamic>> bookings = [
    {
      "testName": "Complete Blood Count",
      "bookingId": "#LAB1025",
      "date": "12 May 2026",
      "time": "08:30 AM",
      "status": "Sample Collected",
      "type": "Home Collection",
      "price": "₹850",
      "lab": "Apollo Diagnostics",
      "icon": Icons.home_rounded,
      "color": Colors.green,
      "steps": [
        {
          "title": "Booking Confirmed",
          "done": true,
        },
        {
          "title": "Technician Assigned",
          "done": true,
        },
        {
          "title": "Sample Collected",
          "done": true,
        },
        {
          "title": "Report Processing",
          "done": false,
        },
        {
          "title": "Report Ready",
          "done": false,
        },
      ],
    },
    {
      "testName": "Vitamin D Test",
      "bookingId": "#LAB1088",
      "date": "14 May 2026",
      "time": "11:00 AM",
      "status": "Visit Scheduled",
      "type": "Visit Lab",
      "price": "₹1200",
      "lab": "Medall Healthcare",
      "icon": Icons.local_hospital_rounded,
      "color": Colors.orange,
      "steps": [
        {
          "title": "Booking Confirmed",
          "done": true,
        },
        {
          "title": "Slot Reserved",
          "done": true,
        },
        {
          "title": "Visit Lab",
          "done": false,
        },
        {
          "title": "Sample Processing",
          "done": false,
        },
        {
          "title": "Report Ready",
          "done": false,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFCF5),

      // appBar: CommonAppBar(title: "Lab Test Tracking",),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                  color: Colors.black.withOpacity(.05),
                ),
              ],
            ),
            child: Column(
              children: [
                /// TOP HEADER
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
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
                              color: Colors.white.withOpacity(.15),
                              borderRadius:
                              BorderRadius.circular(18),
                            ),
                            child: Icon(
                              booking["icon"],
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
                                  booking["testName"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  booking["bookingId"],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                              Colors.white.withOpacity(.16),
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                            child: Text(
                              booking["price"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          _topInfo(
                            Icons.calendar_today,
                            booking["date"],
                          ),

                          const SizedBox(width: 16),

                          _topInfo(
                            Icons.access_time,
                            booking["time"],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.14),
                          borderRadius:
                          BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              color: Colors.white,
                              size: 18,
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                booking["lab"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: booking["color"]
                                    .withOpacity(.2),
                                borderRadius:
                                BorderRadius.circular(30),
                              ),
                              child: Text(
                                booking["type"],
                                style: TextStyle(
                                  color: booking["color"],
                                  fontWeight:
                                  FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// BODY
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      /// STATUS
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: booking["color"],
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            booking["status"],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: booking["color"],
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// TRACKING
                      Column(
                        children: List.generate(
                          booking["steps"].length,
                              (i) {
                            final step =
                            booking["steps"][i];

                            final bool done =
                            step["done"];

                            final bool isLast =
                                i ==
                                    booking["steps"]
                                        .length -
                                        1;

                            return Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration:
                                      BoxDecoration(
                                        shape:
                                        BoxShape.circle,
                                        color: done
                                            ? AppColors
                                            .primary
                                            : Colors
                                            .grey
                                            .shade300,
                                      ),
                                      child: Icon(
                                        done
                                            ? Icons.check
                                            : Icons
                                            .radio_button_unchecked,
                                        size: 14,
                                        color:
                                        Colors.white,
                                      ),
                                    ),

                                    if (!isLast)
                                      Container(
                                        width: 2,
                                        height: 45,
                                        color: done
                                            ? AppColors
                                            .primary
                                            : Colors
                                            .grey
                                            .shade300,
                                      ),
                                  ],
                                ),

                                const SizedBox(width: 14),

                                Padding(
                                  padding:
                                  const EdgeInsets.only(
                                    top: 3,
                                  ),
                                  child: Text(
                                    step["title"],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w600,
                                      color: done
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// BUTTONS
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.call_outlined,
                              ),
                              label:
                              const Text("Support"),
                              style:
                              OutlinedButton.styleFrom(
                                foregroundColor:
                                AppColors.primary,
                                side: BorderSide(
                                  color: AppColors.primary
                                      .withOpacity(.3),
                                ),
                                padding:
                                const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    16,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child:
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.description_outlined,
                              ),
                              label:
                              const Text("View Report"),
                              style:
                              ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                AppColors.primary,
                                padding:
                                const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _topInfo(
      IconData icon,
      String text,
      ) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),

        const SizedBox(width: 6),

        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}