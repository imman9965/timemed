import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timesmed_project/routes/app_routes.dart';

class VideoPaymentPage extends StatelessWidget {
  const VideoPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Doctor Info
            ListTile(
              leading: const CircleAvatar(),
              title: const Text("Dr. Priya"),
              subtitle: const Text("Consultation Fee"),
              trailing: const Text("₹500"),
            ),

            const SizedBox(height: 20),

            /// Payment Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                /// After Payment → Queue Page
                context.push(AppRoutes.videoQueue);
              },
              child: const Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}
