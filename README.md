
# Flutter Paymob Payment

Easily accept payments Cards through [Paymob](https://accept.paymob.com/portal2/en/home) in your Flutter app.

<p align='center'>
    <video controls autoplay muted loop>
  <source src="https://github.com/user-attachments/assets/3ceacbef-d792-4021-b4f2-3aca7080d622" />
</p>

## 🚀  Installation

To install the Flutter Paymob Payment Package, follow these steps

1. Add the package to your project's dependencies in the `pubspec.yaml` file:
   ```yaml
   dependencies:
     flutter_paymob_egypt: ^0.0.4
    ``` 
2. Run the following command to fetch the package:

    ``` 
    flutter pub get
    ``` 

## Usage
1. Import the package into your Dart file:

    ``` 
    import 'package:flutter_paymob_egypt/flutter_paymob_egypt.dart';
    ```
2. Navigate to the Paymob Egypt View with the desired configuration:
    ```dart
    PaymobEgyptView(
    cardInfo: CardInfo(
      apiKey: "YOUR_API_KEY", // from dashboard Select Settings -> Account Info -> API Key
      iframesID: '123456', // from paymob Select Developers -> iframes
      integrationID: '123456', // from dashboard Select Developers -> Payment Integrations -> Online Card ID 
    ),
    totalPrice: 100, // 100 EGP --required pay with Egypt currency
    successResult: (data) {
        // Handle successful payment
    },
    errorResult: (error) {
        // Handle payment error
    });
    
    ```

## ⚡ Donate 

If you would like to support me, please consider making a donation through one of the following links:

* [PayPal](https://paypal.me/Elbehairy20)

Thank you for your support!