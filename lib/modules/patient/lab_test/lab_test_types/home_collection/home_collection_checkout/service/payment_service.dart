import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HomeCollectionCheckoutRazorpayService {
  late Razorpay _razorpay;

  void init({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
    required Function(ExternalWalletResponse) onExternal,
  }) {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternal);
  }

  void openCheckout({
    required int amount,
    required String name,
    required String description,
    required String contact,
    required String email,
    String? orderId,
  }) {
    var options = {
      'key': 'rzp_test_UQu4zdljD2dohm',
      'amount': amount,
      'name': name,
      'description': description,
      if (orderId != null) 'order_id': orderId,
      'prefill': {'contact': contact, 'email': email},
      'theme': {'color': '#0673de'},
    };

    _razorpay.open(options);
  }

  void dispose() {
    _razorpay.clear();
  }
}
