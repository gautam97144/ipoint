import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Screen/bottom_navigation.dart';
import 'package:ipoint/Screen/forgot_password.dart';
import 'package:ipoint/Screen/no_internet_screen.dart';
import 'package:ipoint/Screen/sign_up_page.dart';
import 'package:ipoint/Widget/custom_text_field.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/commonmodel.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

import 'internet_connectivity.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool username = false;
  bool password = false;
  bool _obscureText = true;
  bool is_loading = false;
  bool? isInternet;

  setmodel(value) async {
    String data = jsonEncode(value);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("abc", data);
  }

  final _formkey = GlobalKey<FormState>();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  InternetConnectivity? internetConnectivity;
  UserModel? userModel;
  CommonModel? commonModel;

  Future loginData() async {
    FormData formData = FormData.fromMap({
      "username": usernamecontroller.text,
      "password": passwordcontroller.text
    });

    try {
      Response response = await ApiClient().dio.post(
            Constant.login,
            data: formData,
            //    options: Options(headers: {"Authorization": "Bearer $token"})
          );

      if (response.statusCode == 200) {
        print(response.data);

        userModel = UserModel.fromJson(response.data);
        print(userModel?.toJson());

        if (userModel?.success == 1) {
          setmodel(userModel!.toJson());

          setToken(userModel!.data!.apiToken!);

          Fluttertoast.showToast(msg: '${userModel?.message}');

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigation()),
              (route) => false).then((value) {
            usernamecontroller.clear();
            passwordcontroller.clear();
          });
        } else {
          Fluttertoast.showToast(msg: '${userModel?.message}');
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  setToken(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", value);
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // streamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: Form(
                key: _formkey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "User",
                              style: CustomTheme.body2,
                            ),
                            width: width / 5,
                            height: height / 30,
                            decoration: BoxDecoration(
                                color: CustomTheme.primarycolor,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height / 16,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: width / 3,
                              height: height / 6,
                              child: Image.asset(
                                Images.logo,
                                fit: BoxFit.cover,
                              )),
                        ],
                      ),
                      SizedBox(height: height / 15),
                      CoustomInPutField(
                        validator: (value) {
                          if (value == '') {
                            setState(() {
                              username = true;
                            });
                          } else {
                            setState(() {
                              username = false;
                            });
                          }
                        },
                        fieldController: usernamecontroller,
                        cursorHeight: height / 34,
                        cursorcolor: CustomTheme.primarycolor,
                        hint: "Username",
                        fieldName: '',
                        hintStyle: CustomTheme.inputFieldHintStyle,
                        autofocus: false,
                      ),
                      Visibility(
                        visible: username,
                        child: Text(
                          'please enter your username',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(
                        height: height / 39,
                      ),
                      CoustomInPutField(
                        validator: (value) {
                          if (value == '') {
                            setState(() {
                              password = true;
                            });
                          } else {
                            setState(() {
                              password = false;
                            });
                          }
                        },
                        suffixIcon: IconButton(
                          color: Colors.grey.shade400,
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        fieldController: passwordcontroller,
                        obscureText: _obscureText,
                        cursorHeight: height / 34,
                        cursorcolor: CustomTheme.primarycolor,
                        hint: "Password",
                        hintStyle: CustomTheme.inputFieldHintStyle,
                        maxLines: 1,
                        autofocus: false,
                      ),
                      Visibility(
                        visible: password,
                        child: Text(
                          'please enter your password',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(
                        height: height / 30,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: CustomTheme.body2.copyWith(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 20,
                      ),
                      Builder(
                        builder: (context) {
                          final GlobalKey<SlideActionState> _key = GlobalKey();
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: SlideAction(
                              elevation: 0,
                              sliderButtonIconSize: 16,
                              height: 60,
                              text: "Swipe to Login",
                              textStyle:
                                  //TextStyle(fontFamily: "Noto_Sans"),
                                  CustomTheme.body3,
                              key: _key,
                              onSubmit: () async {
                                if (_formkey.currentState!.validate()) {
                                  if (username == false && password == false) {
                                    setState(() {
                                      is_loading = true;
                                      FocusScope.of(context).unfocus();
                                    });
                                    await loginData();
                                    setState(() {
                                      is_loading = false;
                                    });
                                  }
                                }

                                Future.delayed(
                                  Duration(seconds: 5),
                                  () => _key.currentState?.reset(),
                                );
                              },
                              innerColor: CustomTheme.white,
                              outerColor: CustomTheme.yellow,
                            ),
                          );
                        },
                      ),
                      Expanded(child: SizedBox(height: height / 7)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // SizedBox(width: 130),
                          Text(
                            'New User?',
                            style: CustomTheme.body2,
                          ),
                          SizedBox(
                            width: width / 20,
                          ),
                          Container(
                              alignment: Alignment.center,
                              height: height / 19.8,
                              width: width / 4,
                              decoration: BoxDecoration(
                                  color: CustomTheme.yellow,
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()));
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: CustomTheme.body2,
                                  ))),
                        ],
                      )
                    ],
                  ),
                ),
              ),
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
