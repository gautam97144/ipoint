// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:ipoint/model/usermodel.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class UsernameProvider extends ChangeNotifier {
//   UserModel? userModel;
//
//   getModel() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.reload();
//     var mydata = (preferences.getString('abc'));
//     var jsondecode = jsonDecode(mydata.toString());
//     userModel = UserModel.fromJson(jsondecode);
//     notifyListeners();
//   }
// }
