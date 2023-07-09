import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ipoint/Screen/payment_failed_screen.dart';
import 'package:ipoint/Screen/payment_success_screen.dart';
import 'package:ipoint/model/payment_detail_model.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'choose_payment_method_screen.dart';

class MyAppWebView extends StatelessWidget {
  String? url;
  String? paymentIntent;
  String? appointmentId;
  String? amount;
  MyAppWebView(
      {Key? key, this.url, this.paymentIntent, this.appointmentId, this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("My url" + url.toString());
    return Scaffold(
      body: SafeArea(
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          zoomEnabled: false,
          initialUrl: "$url",
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains("Return")) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentSuccessScreen(
                          amount: amount,
                          appointmentId: appointmentId,
                          paymentIntent: paymentIntent)));

              return NavigationDecision.navigate;
            } else if (request.url.contains("Error")) {
              print('hello');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PaymentFailed(paymentIntent: paymentIntent)));
            }

            return NavigationDecision.navigate;
          },
          // onPageStarted: (String url) {
          //   bool isSuccess = url.contains("Error");
          //
          //   if (isSuccess) {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => ChoosePaymentMethodSCreen()));
          //   }
          //  },
        ),
      ),
    );
  }

  getSingleItem(String id) {}
}
