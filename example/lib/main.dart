import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_paymob_egypt/flutter_paymob_egypt.dart';

void main() {
  runApp(const FlutterPaymobDemo());
}

class FlutterPaymobDemo extends StatelessWidget {
  const FlutterPaymobDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Flutter Paymob Demo',
        debugShowCheckedModeBanner: false,
        home: FluterPaymobEgypt());
  }
}

class FluterPaymobEgypt extends StatelessWidget {
  const FluterPaymobEgypt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue),
      body: Center(
        child: ElevatedButton(
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
                loadingIndicator: null, // optional
                billingData: null, // optional => your data
                items: const [], // optional
                successResult: (data) {
                  log('successResult: $data');
                },
                errorResult: (error) {
                  log('errorResult: $error');
                },
              ),
            ));
          },
          child: const Text('Pay with paymob'),
        ),
      ),
    );
  }
}
