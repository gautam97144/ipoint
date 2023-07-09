import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Screen/login_page.dart';
import 'package:ipoint/Widget/custom_blue_button.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/commonmodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';

import 'no_internet_screen.dart';

class OtpScreen extends StatefulWidget {
  String? username;
  OtpScreen({Key? key, this.username}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  CommonModel? commonModel;
  bool is_loading = false;

  TextEditingController _pinPutController = TextEditingController();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: CustomTheme.primarycolor,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(color: CustomTheme.primarycolor),
  );

  Future otpData() async {
    FormData formData = FormData.fromMap({
      "username": widget.username,
      "otp": _pinPutController.text,
    });

    try {
      Response response =
          await ApiClient().dio.post(Constant.otpVerify, data: formData);

      if (response.statusCode == 200) {
        print(response.data);
        commonModel = CommonModel.fromJson(response.data);
        print(commonModel?.toJson());

        if (commonModel?.success == 1) {
          Fluttertoast.showToast(msg: '${commonModel?.message}');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Loginpage()));
        } else {
          Fluttertoast.showToast(msg: '${commonModel?.message}');
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkRealTime();
  }

  checkRealTime() {
    Provider.of<InternetConnectivityCheck>(context, listen: false)
        .checkRealTimeConnectivity();
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
          SafeArea(
            child: Scaffold(
              body: Container(
                  padding: EdgeInsets.all(12),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "<Back",
                            style: CustomTheme.body3,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        height: hight / 10,
                        width: width / 2.6,
                        child: Image.asset(Images.splashIpoint),
                      ),
                    ),
                    Container(
                        margin:
                            EdgeInsets.only(left: width / 7, right: width / 7),
                        alignment: Alignment.center,
                        child: Center(
                            child: Text(
                          "Verification code has been sent to your phone number",
                          textAlign: TextAlign.center,
                          style: CustomTheme.headline,
                        ))),
                    SizedBox(height: 10),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: PinPut(
                          fieldsCount: 4,
                          textStyle: TextStyle(
                              fontSize: 25.0, color: CustomTheme.black),
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
                    Expanded(
                      child: SizedBox(),
                    ),

                    CustomBlueButton(
                      onPressed: () async {
                        setState(() {
                          is_loading = true;
                          FocusScope.of(context).unfocus();
                        });
                        await otpData();

                        setState(() {
                          is_loading = false;
                        });
                      },
                      title: 'Submit',
                    ),
                    //  SizedBox(height: 50),
                  ])),
            ),
          ),
          Provider.of<InternetConnectivityCheck>(context, listen: true)
                  .isNoInternet
              ? NoInterNetScreen()
              : SizedBox.shrink(),
          is_loading ? LoaderLayoutWidget() : SizedBox.shrink()
        ],
      ),
    );
  }
}
