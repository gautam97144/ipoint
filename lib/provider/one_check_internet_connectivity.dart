import 'package:flutter/material.dart';

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetConnectivityCheckOneTime extends ChangeNotifier {
  Connectivity connectivity = Connectivity();
  StreamSubscription? streamSubscription;
  bool isOneTimeInternet = false;

  checkOneTimeConnectivity() async {
    var checkConnection = await connectivity.checkConnectivity();

    if (checkConnection == ConnectivityResult.mobile) {
      isOneTimeInternet = false;
    } else if (checkConnection == ConnectivityResult.wifi) {
      isOneTimeInternet = false;
    } else {
      isOneTimeInternet = true;
    }
    notifyListeners();
  }
}
