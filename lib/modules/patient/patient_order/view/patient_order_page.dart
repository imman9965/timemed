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
        /// 🔵 Header (like your Account page)
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

        /// 📦 Order List
        Expanded(
          child: Obx(
            () => ListView.builder(
              padding: const EdgeInsets.all(12),
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

  /// 🔥 Order Card UI
  Widget _orderCard(Map order) {
    Color statusColor = order["status"] == "Delivered"
        ? Colors.green
        : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order["orderId"],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  order["status"],
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// 📅 Date
          Text(order["date"], style: TextStyle(color: Colors.grey.shade600)),

          const Divider(height: 20),

          /// 💊 Medicines
          Column(
            children: (order["medicines"] as List)
                .map<Widget>(
                  (med) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(med["name"]), Text("x${med["qty"]}")],
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 10),

          /// 💰 Total + Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: ${order["total"]}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              TextButton(
                onPressed: () {
                  /// future: order details page
                },
                child: const Text("View Details"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
