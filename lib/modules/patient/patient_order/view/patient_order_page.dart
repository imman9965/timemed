import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Column(
      children: [
        /// 🔵 Header
        Container(
          height: 70,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: Colors.blue,
          child: const Center(
            child: Text(
              "My Orders",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        /// 📦 Orders
        Expanded(
          child: Obx(
            () => ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: controller.orders.length,
              itemBuilder: (context, index) {
                final order = controller.orders[index];
                return _orderCard(order);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 🔥 Premium Order Card
  Widget _orderCard(Map order) {
    final bool isDelivered = order["status"] == "Delivered";
    final Color statusColor = isDelivered ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Left Status Bar
          Container(
            width: 5,
            height: 150,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 10),

          /// 🔹 Card Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Top Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order["orderId"],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      /// Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order["status"],
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

                  /// 📅 Date Row
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order["date"],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 20),

                  /// 💊 Medicines
                  Column(
                    children: (order["medicines"] as List)
                        .map<Widget>(
                          (med) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.medication,
                                      size: 16,
                                      color: Colors.blueGrey,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      med["name"],
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                                Text(
                                  "x${med["qty"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 12),

                  /// 💰 Total + Action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.currency_rupee,
                            size: 18,
                            color: Colors.green,
                          ),
                          Text(
                            order["total"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      TextButton(
                        onPressed: () {},
                        child: const Text("View Details"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
