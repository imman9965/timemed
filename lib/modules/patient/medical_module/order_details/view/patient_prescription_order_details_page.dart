import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/core/constants/app_colors.dart';
import 'package:timesmed_project/core/widgets/common_app_bar.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class PatientPrescriptionOrderDetailsPage extends StatelessWidget {
  final Map order;

  const PatientPrescriptionOrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final bool isDelivered = order["status"] == "Delivered";

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: CommonAppBar(title: "Order Details"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 HEADER CARD
            _card(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _safe(order["orderId"]),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      _statusChip(order["status"]),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(_safe(order["date"])),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// 🔹 DELIVERY ADDRESS
            _card(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: Text(_safe(order["address"])),
                subtitle: const Text("Delivery Address"),
              ),
            ),

            const SizedBox(height: 14),

            /// 🔹 MEDICINES LIST
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Medicines",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  ...order["medicines"].map<Widget>((med) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.medication,
                            size: 18,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(width: 8),

                          Expanded(child: Text(_safe(med["name"]))),

                          Text("x${_safe(med["qty"])}"),

                          const SizedBox(width: 10),

                          Text("₹${_safe(med["price"])}"),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// 🔹 BILL DETAILS
            _card(
              child: Column(
                children: [
                  _billRow("Subtotal", _safe(order["subtotal"])),
                  _billRow("Delivery Fee", "₹40"),
                  const Divider(),
                  _billRow("Total", _safe(order["total"]), isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// 🔹 PAYMENT INFO
            _card(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.payment, color: Colors.green),
                title: const Text("Payment Method"),
                subtitle: Text(_safe(order["payment"])),
                trailing: Text(
                  _safe(order["paymentStatus"]),
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 ACTION BUTTONS
            if (!isDelivered)
              _primaryButton(
                text: "Track Order",
                onTap: () {
                  context.push(AppRoutes.patientPrescriptionOrderTracking);
                },
              ),

            if (isDelivered)
              Column(
                children: [
                  _primaryButton(
                    text: "Reorder",
                    onTap: () {
                      // 👉 add items back to cart
                    },
                  ),

                  const SizedBox(height: 10),

                  _outlineButton(text: "Need Help", onTap: () {}),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// 🔹 CARD UI
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  /// 🔹 BILL ROW
  Widget _billRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
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
      ),
    );
  }

  String _safe(dynamic value, {String fallback = "-"}) {
    if (value == null) return fallback;
    return value.toString();
  }

  /// 🔹 STATUS CHIP
  Widget _statusChip(String status) {
    final isDelivered = status == "Delivered";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDelivered
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isDelivered ? Colors.green : Colors.orange,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  /// 🔹 PRIMARY BUTTON
  Widget _primaryButton({required String text, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  /// 🔹 OUTLINE BUTTON
  Widget _outlineButton({required String text, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
