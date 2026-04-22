import 'dart:async';
import 'package:flutter/material.dart';

class WaitingDialog {
  static void show(
    BuildContext context, {
    int durationInSeconds = 120,
    VoidCallback? onAccept,
    VoidCallback? onReject,
  }) {
    int seconds = durationInSeconds;
    Timer? timer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            /// Start Timer once
            timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              if (seconds > 0) {
                setState(() => seconds--);
              } else {
                t.cancel();
                Navigator.pop(context);
              }
            });

            return WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Loader
                      const CircularProgressIndicator(),

                      const SizedBox(height: 20),

                      /// Title
                      const Text(
                        "Waiting for Doctor...",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Timer Text
                      Text(
                        "Time left: ${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}",
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 20),

                      /// Demo Buttons (Remove later when API ready)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                timer?.cancel();
                                Navigator.pop(context);
                                onAccept?.call();
                              },
                              child: const Text("Accept"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                timer?.cancel();
                                Navigator.pop(context);
                                onReject?.call();
                              },
                              child: const Text("Reject"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
