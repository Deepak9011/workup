import 'dart:async';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  late Razorpay _razorpay;
  late Completer<bool> _paymentCompleter;

  PaymentService() {
    _razorpay = Razorpay();
  }

  Future<bool> openCheckout({required int amount}) {
    _paymentCompleter = Completer<bool>();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    var options = {
      'key': 'rzp_test_tMVhEwUhMfx3Xu',
      'amount': amount * 100 * 0, // Convert to paise
      'name': 'Work Up',
      'description': 'Payment for Order #1234',
      'prefill': {'contact': '8974863731', 'email': 'workupsgsits@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
      _paymentCompleter.complete(false);
    }

    return _paymentCompleter.future;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Successful: ${response.paymentId}");
    _paymentCompleter.complete(true);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.code} - ${response.message}");
    _paymentCompleter.complete(false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet Selected: ${response.walletName}");
  }

  void dispose() {
    _razorpay.clear();
  }
}
