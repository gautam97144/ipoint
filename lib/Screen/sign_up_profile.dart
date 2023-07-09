import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Screen/otp_screen.dart';
import 'package:ipoint/Widget/custom_blue_button.dart';
import 'package:ipoint/Widget/custom_text_field.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/commonmodel.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'no_internet_screen.dart';

class SignUpProfile extends StatefulWidget {
  String name;
  String dob;
  String location;
  String latitude;
  String longitude;
  String prifixname;

  SignUpProfile(
      {Key? key,
      required this.name,
      required String this.dob,
      required String this.location,
      required this.longitude,
      required this.latitude,
      required this.prifixname})
      : super(key: key);

  @override
  _SignUpProfileState createState() => _SignUpProfileState();
}

class _SignUpProfileState extends State<SignUpProfile> {
  bool usernameerror = false;
  bool passworderror = false;
  bool confirmpassworderror = false;
  bool emailerror = false;
  bool phoneerror = false;
  String? name, name1, name2, name3;
  bool _obscureText = true;
  bool _obText = true;

  bool is_loading = false;

  setmodel(value) async {
    String data = jsonEncode(value);
    print(data + "dddddddddddd");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("model", data);
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    bool data = regExp.hasMatch(value);
    return data;
  }

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter valid email';
    else
      return null;
  }

  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController referalcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  UserModel? userModel;
  CommonModel? commonModel;

  Future registerData() async {
    FormData formData = FormData.fromMap({
      "name_prefix": widget.prifixname,
      "name": widget.name,
      "dob": widget.dob,
      "location": widget.location,
      "latitude": widget.latitude,
      "longitude": widget.longitude,
      "username": usernamecontroller.text,
      "password": passwordcontroller.text,
      "devicee_id": 'yyyyy',
      "email": emailcontroller.text,
      "mobile": mobilecontroller.text,
      "refferalCode": referalcontroller.text
    });

    try {
      Response response =
          await ApiClient().dio.post(Constant.registration, data: formData);

      if (response.statusCode == 200) {
        print(response.data);

        userModel = UserModel.fromJson(response.data);
        print(userModel?.toJson().toString());

        // setmodel(userModel);
        if (userModel?.success == 1) {
          Fluttertoast.showToast(msg: '${userModel?.message}');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OtpScreen(username: userModel?.data?.username)));
        } else {
          Fluttertoast.showToast(msg: '${userModel?.message}');
        }
      }
    } on DioError catch (e) {
      print(e.message);
      // Fluttertoast.showToast(msg: '${e.message}');
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
    var height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              height: height / 10,
                              width: width / 2.6,
                              child: Image.asset(Images.splashIpoint),
                            ),
                          ),
                          CoustomInPutField(
                              autofocus: true,
                              inputFormatter: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[a-z 0-9_\-=@,\.;]+$')),
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              validator: (value) {
                                if (value == "") {
                                  setState(() {
                                    usernameerror = true;
                                  });
                                } else {
                                  setState(() {
                                    usernameerror = false;
                                  });
                                }
                              },
                              cursorHeight: height / 34,
                              cursorcolor: CustomTheme.primarycolor,
                              fieldController: usernamecontroller,
                              hint: "User Name",
                              hintStyle: CustomTheme.inputFieldHintStyle),
                          Visibility(
                            visible: usernameerror,
                            child: Text(
                              'Please enter your username',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          SizedBox(height: height / 30),
                          CoustomInPutField(
                            validator: (value) {
                              if (value == "") {
                                setState(() {
                                  passworderror = true;
                                  name = "Please enter  password";
                                });
                              } else if (value!.length < 6) {
                                setState(() {
                                  passworderror = true;
                                  name = "Password is  Short";
                                });
                              } else if (value.length > 6) {
                                bool data = validateStructure(value);
                                if (!data) {
                                  setState(() {
                                    passworderror = true;
                                    name = "Password  is weak";
                                  });
                                } else {
                                  setState(() {
                                    passworderror = false;
                                    name = "";
                                  });
                                }
                              } else {
                                setState(() {
                                  passworderror = false;
                                  name = "";
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
                            cursorHeight: height / 34,
                            cursorcolor: CustomTheme.primarycolor,
                            obscureText: _obscureText,
                            maxLines: 1,
                            fieldController: passwordcontroller,
                            hint: "Password",
                            hintStyle: CustomTheme.inputFieldHintStyle,
                            autofocus: false,
                          ),
                          Visibility(
                            visible: passworderror,
                            child: Text(
                              "$name",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          SizedBox(height: height / 40),
                          Text(
                              "Your password must include upper case, lower case, numbers and symbols. Length of your password must be at least 8 character",
                              style: CustomTheme.italic),
                          SizedBox(height: height / 30),
                          CoustomInPutField(
                            validator: (value) {
                              if (value == "") {
                                setState(() {
                                  confirmpassworderror = true;
                                  name1 = "Please Enter password";
                                });
                              } else if (value != passwordcontroller.text) {
                                setState(() {
                                  confirmpassworderror = true;
                                  name1 = 'Confirm Password is wrong';
                                });
                              } else {
                                setState(() {
                                  confirmpassworderror = false;
                                  name1 = '';
                                });
                              }
                            },
                            suffixIcon: IconButton(
                              color: Colors.grey.shade400,
                              icon: Icon(
                                _obText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obText = !_obText;
                                });
                              },
                            ),
                            cursorHeight: height / 34,
                            cursorcolor: CustomTheme.primarycolor,
                            obscureText: _obText,
                            fieldController: confirmpasswordcontroller,
                            hint: "Confirm Password",
                            hintStyle: CustomTheme.inputFieldHintStyle,
                            maxLines: 1,
                            autofocus: false,
                          ),
                          Visibility(
                            visible: confirmpassworderror,
                            child: Text(
                              '$name1',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          SizedBox(height: height / 30),
                          CoustomInPutField(
                            fieldInputType: TextInputType.emailAddress,
                            autofocus: false,
                            validator: (value) {
                              if (value == "") {
                                setState(() {
                                  emailerror = true;
                                  name3 = "Please enter your email";
                                });
                              } else if (validateEmail(value!) != null) {
                                setState(() {
                                  emailerror = true;
                                  name3 = "Enter Valid Email";
                                });
                              } else {
                                setState(() {
                                  emailerror = false;
                                  name3 = '';
                                });
                              }
                            },
                            cursorHeight: height / 34,
                            cursorcolor: CustomTheme.primarycolor,
                            fieldController: emailcontroller,
                            hint: "Email",
                            hintStyle: CustomTheme.inputFieldHintStyle,
                          ),
                          Visibility(
                            visible: emailerror,
                            child: Text(
                              '$name3',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          SizedBox(height: height / 30),
                          CoustomInPutField(
                            autofocus: false,
                            validator: (value) {
                              if (value == "") {
                                setState(() {
                                  phoneerror = true;
                                });
                              } else {
                                setState(() {
                                  phoneerror = false;
                                });
                              }
                            },
                            fieldInputType: TextInputType.phone,
                            fieldController: mobilecontroller,
                            cursorHeight: height / 34,
                            cursorcolor: CustomTheme.primarycolor,
                            hint: "Phone Number",
                            hintStyle: CustomTheme.inputFieldHintStyle,
                          ),
                          Visibility(
                            visible: phoneerror,
                            child: Text(
                              'Please enter your  phone number',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          SizedBox(height: height / 30),
                          CoustomInPutField(
                            autofocus: false,
                            fieldController: referalcontroller,
                            hint: "Refferal Code",
                            hintStyle: CustomTheme.inputFieldHintStyle,
                            cursorcolor: CustomTheme.primarycolor,
                            cursorHeight: height / 34,
                          ),
                          SizedBox(height: height / 15),
                          CustomBlueButton(
                              title: 'Next',
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  if (usernameerror == false &&
                                      passworderror == false &&
                                      confirmpassworderror == false &&
                                      emailerror == false &&
                                      phoneerror == false) {
                                    setState(() {
                                      is_loading = true;
                                      FocusScope.of(context).unfocus();
                                    });
                                    await registerData();
                                    setState(() {
                                      is_loading = false;
                                    });
                                  }
                                }
                              })
                        ]),
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
