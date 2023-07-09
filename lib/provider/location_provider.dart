import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class LocationProvider extends ChangeNotifier {
  String address = '';
  String lat = '';
  String long = '';

  setAddress(
      {required String addressData,
      required String latData,
      required String longData}) {
    address = addressData;
    lat = latData;
    long = longData;

    notifyListeners();
  }
}
