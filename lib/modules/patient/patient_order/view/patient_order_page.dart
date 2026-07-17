import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/routes/app_routes.dart';
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
      backgroundColor: const Color(0xffF8FAFD),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 98),
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
    final bool isCancelled = status == "Cancelled";

    Color statusColor;
    if (isDelivered) {
      statusColor = Colors.green;
    } else if (isCancelled) {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.shade300, // Border color
          width: 1.0,                  // Border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TOP HEADER SECTION
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.03),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order["orderId"],
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: -0.5,
                        color: Color(0xff1A1C1E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order["date"],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                /// STATUS CHIP
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 MEDICINE LIST
                const Text(
                  "ORDERED ITEMS",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(order["medicines"].length, (index) {
                  final med = order["medicines"][index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.medication_outlined, size: 16, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            med["name"],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff2C3E50),
                            ),
                          ),
                        ),
                        Text(
                          "x${med["qty"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: Color(0xff1A1C1E),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1),
                ),

                /// 🔹 BOTTOM ACTION ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// TOTAL
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "TOTAL AMOUNT",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey),
                        ),
                        Text(
                          order["total"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),

                    /// ACTION BUTTON
                    Row(
                      children: [
                        if (isDelivered)
                          _orderActionBtn(
                            label: "View Details",
                            onTap: () {
                              context.push(
                                AppRoutes.patientPrescriptionOrderDetails,
                                extra: order,
                              );
                            },
                            isPrimary: false,
                          )
                        else
                          _orderActionBtn(
                            label: "Track",
                            onTap: () {
                              context.push(AppRoutes.patientPrescriptionOrderTracking);
                            },
                            isPrimary: true,
                          ),
                        if (isDelivered) ...[
                          const SizedBox(width: 10),
                          _orderActionBtn(
                            label: "Reorder",
                            onTap: () {
                              context.push(AppRoutes.patientMedicineCart);
                            },
                            isPrimary: true,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderActionBtn({required String label, required VoidCallback onTap, required bool isPrimary}) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : Colors.white,
          foregroundColor: isPrimary ? Colors.white : AppColors.primary,
          elevation: isPrimary ? 4 : 0,
          shadowColor: isPrimary ? AppColors.primary.withValues(alpha: 0.3) : Colors.transparent,
          side: isPrimary ? BorderSide.none : const BorderSide(color: Color(0xffE9EEF5), width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
        ),
      ),
    );
  }
}
