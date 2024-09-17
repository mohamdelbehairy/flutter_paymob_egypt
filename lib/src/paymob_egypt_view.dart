import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_paymob_egypt/src/card_info.dart';
import 'billing_data.dart';
import 'items.dart';
import 'paymob_service.dart';

class PaymobEgyptView extends StatefulWidget {
  const PaymobEgyptView(
      {super.key,
      required this.cardInfo,
      required this.totalPrice,
      required this.successResult,
      required this.errorResult,
      this.billingData,
      this.items,
      this.loadingIndicator});
  final CardInfo cardInfo;
  final num totalPrice;
  final Function successResult, errorResult;
  final BillingData? billingData;
  final List<Items>? items;
  final Widget? loadingIndicator;

  @override
  State<PaymobEgyptView> createState() => _PaymobEgyptViewState();
}

class _PaymobEgyptViewState extends State<PaymobEgyptView> {
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
      getToken();
    }
  }

  void getToken() async {
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

    _isLoading = false;
    setState(() {});
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
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Paymob Payment'),
          backgroundColor: Colors.grey.shade50),
      body: _isLoading
          ? Center(
              child:
                  widget.loadingIndicator ?? const CircularProgressIndicator())
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
                          var orderID = await getOrderInfo(
                              authToken: _authToken!, orderID: _orderID!);
                          widget.successResult(orderID);
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
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
    );
  }
}
