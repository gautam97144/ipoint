import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ipoint/Screen/bottom_navigation.dart';
import 'package:ipoint/Screen/login_page.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/payment_token_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/provider/one_check_internet_connectivity.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'no_internet_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserModel? userModel;
  Token? paymentToken;

  getModel() async {
    await Provider.of<InternetConnectivityCheck>(context, listen: false)
        .checkRealTimeConnectivity();
    await Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
        .checkOneTimeConnectivity();

    if (Provider.of<InternetConnectivityCheck>(context, listen: false)
            .isNoInternet ||
        Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
            .isOneTimeInternet) {
      NoInterNetScreen();
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var mydata = (preferences.getString('abc'));

      if (mydata == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Loginpage()),
            (route) => false);
        await tokenRequest();
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation()),
            (route) => false);
        await tokenRequest();
      }
    }
  }

  Future tokenRequest() async {
    String username = "merchantdemo02@payex.io";
    String password = "zjm7Suz9ep7OA1R3Cdw8n9JafRzzfiIT";

    try {
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));

      Response response = await ApiClient().dio.post(
          "https://sandbox-payexapi.azurewebsites.net/api/Auth/Token",
          //data: jsonEncode(formData),
          //queryParameters: jsonEncode(formData),
          options: Options(
              contentType: "application/json",
              headers: {"Authorization": basicAuth}));

      if (response.statusCode == 200) {
        print(response.data);

        paymentToken = Token.fromJson(response.data);

        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("paymentToken", paymentToken!.token.toString());
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnection();
    Future.delayed(Duration(seconds: 2), () {
      getModel();
    });
  }

  checkConnection() async {
    await Provider.of<InternetConnectivityCheck>(context, listen: false)
        .checkRealTimeConnectivity();
    await Provider.of<InternetConnectivityCheckOneTime>(context, listen: false)
        .checkOneTimeConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var hight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Scaffold(
            body: Center(
                child: Container(
                    height: hight / 4.5,
                    width: width / 2,
                    child: Image.asset(Images.splashIpoint))),
          ),
          Provider.of<InternetConnectivityCheck>(context, listen: true)
                      .isNoInternet ||
                  Provider.of<InternetConnectivityCheckOneTime>(context,
                          listen: true)
                      .isOneTimeInternet
              ? NoInterNetScreen()
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
