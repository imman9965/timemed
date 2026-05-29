import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/routes/app_routes.dart';
import '../../../doctor/schedule_appointment/schedule_appointment.dart';
import '../controller/patient_order_controller.dart';

class PatientOrderPage extends StatefulWidget {
  const PatientOrderPage({super.key});

  @override
  State<PatientOrderPage> createState() => _PatientOrderPageState();
}

class _PatientOrderPageState extends State<PatientOrderPage> {
  final controller = Get.find<PatientOrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFCF5),
      // appBar: CommonAppBar(title: "My Orders"),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return _orderCard(order);
          },
        ),
      ),
    );
  }

  /// 🔥 Premium Order Card
  Widget _orderCard(Map order) {
    final status = order["status"];
    final bool isDelivered = status == "Delivered";

    Color statusColor;
    if (status == "Delivered") {
      statusColor = Colors.green;
    } else if (status == "Cancelled") {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order["orderId"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              /// STATUS CHIP
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// DATE
          Text(
            order["date"],
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 12),

          /// 🔹 MEDICINE LIST
          ...List.generate(order["medicines"].length, (index) {
            final med = order["medicines"][index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(Icons.medication, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      med["name"],
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Text(
                    "x${med["qty"]}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 14),

          /// 🔹 BOTTOM ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// TOTAL
              Row(
                children: [
                  const Icon(Icons.currency_rupee, size: 16),
                  Text(
                    order["total"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              /// ACTION BUTTON
              ElevatedButton(
                onPressed: () {
                  if (isDelivered) {
                    context.push(
                      AppRoutes.patientPrescriptionOrderDetails,
                      extra: order,
                    );
                  } else {
                    context.push(AppRoutes.patientPrescriptionOrderTracking);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDelivered
                      ? Colors.grey.shade200
                      : AppColors.primary,
                  foregroundColor: isDelivered ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(isDelivered ? "View Details" : "Track Order"),
              ),
            ],
          ),

          /// 🔥 OPTIONAL: REORDER BUTTON
          if (isDelivered) ...[
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                // TODO: Add items back to cart
                context.push(AppRoutes.patientMedicineCart);
              },
              child: const Text("Reorder"),
            ),
          ],
        ],
      ),
    );
  }
}
