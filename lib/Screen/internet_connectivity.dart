import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:ipoint/Screen/no_internet_screen.dart';

class InternetConnectivity extends StatefulWidget {
  const InternetConnectivity({Key? key}) : super(key: key);

  @override
  _InternetConnectivityState createState() => _InternetConnectivityState();
}

class _InternetConnectivityState extends State<InternetConnectivity> {
  String status = "waiting";
  Connectivity connectivity = Connectivity();
  StreamSubscription? streamSubscription;
  bool isNoInternet = false;

  checkRealTimeConnectivity() {
    streamSubscription = connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        status = "mobile data";
        isNoInternet = false;
      } else if (event == ConnectivityResult.wifi) {
        status = "wifi data";
        isNoInternet = false;
      } else {
        isNoInternet = true;
      }
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text(status),
    ));
  }
}
