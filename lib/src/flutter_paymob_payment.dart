import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_paymob_egypt/src/card_info.dart';
import 'billing_data.dart';
import 'items.dart';
import 'paymob_service.dart';

class FlutterPaymobPayment extends StatefulWidget {
  const FlutterPaymobPayment(
      {super.key,
      required this.cardInfo,
      required this.totalPrice,
      required this.successResult,
      required this.errorResult,
      this.billingData,
      this.items,
      this.loadingIndicator,
      this.appBar});
  final CardInfo cardInfo;
  final num totalPrice;
  final Function successResult, errorResult;
  final BillingData? billingData;
  final List<Items>? items;
  final Widget? loadingIndicator;
  final PreferredSizeWidget? appBar;

  @override
  State<FlutterPaymobPayment> createState() => _FlutterPaymobPaymentState();
}

class _FlutterPaymobPaymentState extends State<FlutterPaymobPayment> {
  InAppWebViewController? _webViewController;

  String? _authToken, _orderID, _token;
  bool _isLoading = true;
  bool _isError = false;
  double _progress = 0;
  String _error = '';

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _getToken();
    }
  }

  void _getToken() async {
    var authToken = await getAuthToken(apiKey: widget.cardInfo.apiKey);
    if (authToken['error'] == 'false') {
      log('step 1');
      _authToken = authToken['auth_token'];
      var orderID = await getOrderID(
          authToken: _authToken!,
          price: widget.totalPrice,
          items: widget.items);

      if (orderID['error'] == 'false') {
        log('step 2');
        _orderID = orderID['id'];
        var finalToken = await getFinalToken(
            authToken: _authToken!,
            orderID: _orderID!,
            price: widget.totalPrice,
            integrationID: widget.cardInfo.integrationID,
            billingData: widget.billingData);

        if (finalToken['error'] == 'false') {
          log('step 3');
          _token = finalToken['token'];
        } else {
          widget.errorResult(finalToken);
          setState(() {
            _isError = true;
            _error = finalToken['message'];
          });
        }
      } else {
        widget.errorResult(orderID);
        setState(() {
          _isError = true;
          _error = orderID['message'];
        });
      }
    } else {
      widget.errorResult(authToken);
      setState(() {
        _isError = true;
        _error = authToken['message'];
      });
    }

    if (mounted) {
      _isLoading = false;
      setState(() {});
    }
  }

  void _startPayment() async {
    _webViewController?.loadUrl(
        urlRequest: URLRequest(
      url: WebUri(
          'https://accept.paymob.com/api/acceptance/iframes/${widget.cardInfo.iframesID}?payment_token=$_token'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: widget.appBar ??
          AppBar(
              centerTitle: true,
              title: const Text('Paymob Payment'),
              backgroundColor: Colors.grey.shade50),
      body: _isLoading
          ? Center(
              child: widget.loadingIndicator ??
                  const CircularProgressIndicator(color: Colors.blue))
          : _isError
              ? Center(child: Text(_error))
              : Stack(
                  children: [
                    InAppWebView(
                      // initialOptions: InAppWebViewGroupOptions(
                      //     crossPlatform:
                      //         InAppWebViewOptions(javaScriptEnabled: true)),
                      onWebViewCreated: (controller) {
                        _webViewController = controller;
                        _startPayment();
                      },
                      onLoadStop: (controller, url) async {
                        if (url != null &&
                            url.queryParameters.containsKey('success') &&
                            url.queryParameters['success'] == 'true') {
                          var orderData = await getOrderInfo(
                              authToken: _authToken!, orderID: _orderID!);

                          Map<String, dynamic> data = {
                            'error': orderData['error'],
                            'success': orderData['data']['success'],
                            'amount_cents': orderData['data']['amount_cents'],
                            'order_id': orderData['data']['order']['id'],
                            'created_at': orderData['data']['order']
                                ['created_at'],
                            'delivery_needed': orderData['data']['order']
                                ['delivery_needed'],
                            'currency': orderData['data']['payment_key_claims']
                                ['currency'],
                            'first_name': orderData['data']
                                    ['payment_key_claims']['billing_data']
                                ['first_name'],
                            'last_name': orderData['data']['payment_key_claims']
                                ['billing_data']['last_name'],
                            'street': orderData['data']['payment_key_claims']
                                ['billing_data']['street'],
                            'building': orderData['data']['payment_key_claims']
                                ['billing_data']['building'],
                            'floor': orderData['data']['payment_key_claims']
                                ['billing_data']['floor'],
                            'apartment': orderData['data']['payment_key_claims']
                                ['billing_data']['apartment'],
                            'city': orderData['data']['payment_key_claims']
                                ['billing_data']['city'],
                            'email': orderData['data']['payment_key_claims']
                                ['billing_data']['email'],
                            'phone_number': orderData['data']
                                    ['payment_key_claims']['billing_data']
                                ['phone_number'],
                            'shipping_method': orderData['data']
                                    ['payment_key_claims']['billing_data']
                                ['shipping_method'],
                            'postal_code': orderData['data']
                                    ['payment_key_claims']['billing_data']
                                ['postal_code'],
                            'state': orderData['data']['payment_key_claims']
                                ['billing_data']['state'],
                          };
                          widget.successResult(data);
                        }
                      },
                      onProgressChanged: (controller, progress) {
                        setState(() {
                          _progress = progress / 100;
                        });
                      },
                    ),
                    _progress < 1
                        ? SizedBox(
                            height: 3,
                            child: LinearProgressIndicator(
                              value: _progress,
                              color: Colors.blue,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
    );
  }
}
