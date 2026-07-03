import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/modules/patient/medical_module/track_order/controller/patient_prescription_track_order_controller.dart';
import 'package:timesmed_project/routes/app_routes.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';

class PatientPrescriptionTrackOrderPage extends StatelessWidget {
  const PatientPrescriptionTrackOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PatientPrescriptionTrackOrderController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(title: 'Track Order'),
      body: Stack(
        children: [
          /// 🔹 MAP IMAGE (Premium Look)
          Positioned.fill(
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/track_order/track_order.png",
                  fit: BoxFit.cover,
                ),

                /// 🔥 DARK GRADIENT OVERLAY
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 TOP STATUS BAR
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order #OD12345", style: TextStyle(color: Colors.white)),
                  Text(
                    "20 mins",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 🔹 PREMIUM DRAGGABLE SHEET
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F8FB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    /// HANDLE
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    /// 🔥 STATUS TITLE
                    const Text(
                      "On the way",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Arriving in 20–30 minutes",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 16),

                    /// 🔹 DELIVERY PARTNER (Premium Card)
                    _premiumCard(
                      child: Row(
                        children: [
                          const CircleAvatar(radius: 24),
                          const SizedBox(width: 12),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Imman",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Delivery Partner",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                context.push(
                                  AppRoutes.patientPrescriptionOrderStatus,
                                );
                              },
                              icon: const Icon(Icons.call, color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// 🔹 ORDER SUMMARY
                    _premiumCard(
                      child: Column(
                        children: [
                          _row("Cetaphil Cleanser x1", "₹45"),
                          const Divider(),
                          _row("Delivery Fee", "₹40"),
                          const Divider(),
                          _row("Total", "₹85", isBold: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// 🔹 ADDRESS
                    _premiumCard(
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.red),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "220, Whites Road, Chennai",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// 🔹 BUTTON
                    ElevatedButton(
                      onPressed: () {
                        context.push(AppRoutes.patientPrescriptionOrderStatus);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("View Order Status"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _premiumCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12),
        ],
      ),
      child: child,
    );
  }

  Widget _row(String t, String v, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(t),
        Text(
          v,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

Widget _card({required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
      ],
    ),
    child: child,
  );
}

Widget _row(String title, String value, {bool isBold = false}) {
  return Row(
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
  );
}

Widget _buildMap(PatientPrescriptionTrackOrderController controller) {
  return Obx(() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(controller.riderLat.value, controller.riderLng.value),
        zoom: 14,
      ),
      markers: {
        Marker(
          markerId: const MarkerId("rider"),
          position: LatLng(
            controller.riderLat.value,
            controller.riderLng.value,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
        Marker(
          markerId: const MarkerId("destination"),
          position: LatLng(controller.destLat.value, controller.destLng.value),
        ),
      },
      polylines: {
        Polyline(
          polylineId: const PolylineId("route"),
          points: [
            LatLng(controller.riderLat.value, controller.riderLng.value),
            LatLng(controller.destLat.value, controller.destLng.value),
          ],
          color: Colors.blue,
          width: 4,
        ),
      },
    );
  });
}
