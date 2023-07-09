import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Widget/custom_yellow_button.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/commonmodel.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'no_internet_screen.dart';

class VerificationScreen extends StatefulWidget {
  String? number;
  VerificationScreen({Key? key, this.number}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController _pinPutController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();

  CommonModel? commonModel;
  UserModel? userModel;
  String token = '';
  bool is_loading = false;

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: CustomTheme.primarycolor,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(color: CustomTheme.primarycolor),
  );

  Future updateMobileVerifyOtp() async {
    print(userModel?.data?.mobile);

    FormData formData = FormData.fromMap({
      "edit": "verify_otp",
      "mobile": widget.number,
      "otp": _pinPutController.text,
    });

    try {
      Response response = await ApiClient().dio.post(
          Constant.updateMobileVerifyOtp,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        print(response.data);
        commonModel = CommonModel.fromJson(response.data);

        if (commonModel?.success == 1) {
          Navigator.pop(context);

          Fluttertoast.showToast(msg: "${commonModel?.message}");
        } else {
          Fluttertoast.showToast(msg: "${commonModel?.message}");
        }
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  gettoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    setState(() {
      this.token = token ?? '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettoken();
    checkRealTime();
  }

  checkRealTime() {
    Provider.of<InternetConnectivityCheck>(context, listen: false)
        .checkRealTimeConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Stack(children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent.withOpacity(.6),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         Navigator.pop(context);
                  //       },
                  //       child: Icon(
                  //         Icons.close,
                  //         color: Colors.white,
                  //         size: 30,
                  //       ),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: height / 3,
                  ),
                  Container(
                      margin:
                          EdgeInsets.only(left: width / 7, right: width / 7),
                      alignment: Alignment.center,
                      child: Center(
                          child: Text(
                              "Verification code has been sent to your phone number",
                              textAlign: TextAlign.center,
                              style: CustomTheme.headline
                                  .copyWith(color: Colors.white)))),
                  SizedBox(height: 10),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: PinPut(
                        fieldsCount: 4,
                        textStyle:
                            TextStyle(fontSize: 25.0, color: CustomTheme.black),
                        eachFieldHeight: 60.0,
                        eachFieldWidth: 60.0,
                        controller: _pinPutController,
                        selectedFieldDecoration: pinPutDecoration,
                        submittedFieldDecoration: pinPutDecoration,
                        followingFieldDecoration: pinPutDecoration,
                        onSubmit: (pin) {},
                      ),
                    ),
                  ),
                  SizedBox(height: height / 30),
                  Container(
                    margin: EdgeInsets.only(left: width / 7, right: width / 7),
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    child: Text(
                        "*Please key in the code sent to you in order to complete the updating process.",
                        style: CustomTheme.headline.copyWith(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                            color: Colors.white)),
                  ),
                  Expanded(child: SizedBox()),
                  CustomYellowButton(
                    title: 'Update',
                    onPressed: () async {
                      setState(() {
                        is_loading = true;
                        FocusScope.of(context).unfocus();
                      });
                      await updateMobileVerifyOtp();

                      setState(() {
                        is_loading = false;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          Provider.of<InternetConnectivityCheck>(context, listen: true)
                  .isNoInternet
              ? NoInterNetScreen()
              : SizedBox.shrink(),
          is_loading ? LoaderLayoutWidget() : SizedBox.shrink()
        ]),
      ),
    );
  }
}
