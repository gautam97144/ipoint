import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetConnectivityCheck extends ChangeNotifier {
  Connectivity connectivity = Connectivity();
  StreamSubscription? streamSubscription;
  bool isNoInternet = false;

  checkRealTimeConnectivity() {
    streamSubscription = connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        isNoInternet = false;
      } else if (event == ConnectivityResult.wifi) {
        isNoInternet = false;
      } else {
        isNoInternet = true;
      }
      notifyListeners();
    });
  }

  checkOneTimeConnectivity() {}
}
