import 'package:flutter/material.dart';
import 'package:flutter_paymob_egypt/flutter_paymob_egypt.dart';

void main() {
  runApp(const FlutterPaymentDemo());
}

class FlutterPaymentDemo extends StatelessWidget {
  const FlutterPaymentDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterPaymobDemo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => PaymobEgyptView(
                  cardInfo: CardInfo(
                    apiKey:
                        "YOUR_API_KEY", // from dashboard Select Settings -> Account Info -> API Key
                    iframesID:
                        '123456', // from paymob Select Developers -> iframes
                    integrationID:
                        '123456', // from dashboard Select Developers -> Payment Integrations -> Online Card ID
                  ),
                  totalPrice: 10000, // 100 EGP
                  successResult: (data) {
                    // Handle successful payment
                  },
                  errorResult: (error) {
                    // Handle payment error
                  },
                ),
              ));
            },
            child: const Text('Pay with paymob'),
          ),
        ),
      ),
    );
  }
}
