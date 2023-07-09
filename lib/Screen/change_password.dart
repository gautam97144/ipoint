import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Screen/login_page.dart';
import 'package:ipoint/Widget/custom_blue_button.dart';
import 'package:ipoint/Widget/custom_text_field.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/commonmodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'no_internet_screen.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool oldpassword = false;
  bool newpassworderror = false;
  bool confirmpassworderror = false;
  bool _obscureText = true;
  bool _obsText = true;
  bool _osText = true;
  bool is_loading = false;

  String? name;
  String? name1;

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    bool data = regExp.hasMatch(value);
    return data;
  }

  final _formkey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();

  CommonModel? commonModel;
  String token = '';

  Future changePassword() async {
    FormData formData = FormData.fromMap({
      "old_password": oldPasswordController.text,
      "new_password": newPasswordController.text
    });

    try {
      Response response = await ApiClient().dio.post(Constant.changePassword,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<InternetConnectivityCheck>(context, listen: false)
        .streamSubscription
        ?.cancel();
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
              body: Form(
                key: _formkey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                      SizedBox(height: height / 16),
                      CoustomInPutField(
                        validator: (value) {
                          if (value == '') {
                            setState(() {
                              oldpassword = true;
                            });
                          } else {
                            setState(() {
                              oldpassword = false;
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
                        obscureText: _obscureText,
                        fieldController: oldPasswordController,
                        cursorHeight: height / 34,
                        cursorcolor: CustomTheme.primarycolor,
                        hint: "Old Password",
                        fieldName: '',
                        hintStyle: CustomTheme.inputFieldHintStyle,
                        maxLines: 1,
                        autofocus: true,
                      ),
                      Visibility(
                        visible: oldpassword,
                        child: Text(
                          'please enter your old password',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(height: height / 16),
                      CoustomInPutField(
                        validator: (value) {
                          if (value == "") {
                            setState(() {
                              newpassworderror = true;
                              name = "Please Enter  Password";
                            });
                          } else if (value!.length < 6) {
                            setState(() {
                              newpassworderror = true;
                              name = "Password is  Short";
                            });
                          } else if (value.length > 6) {
                            bool data = validateStructure(value);
                            if (!data) {
                              setState(() {
                                newpassworderror = true;
                                name = "Password  is weak";
                              });
                            } else {
                              setState(() {
                                newpassworderror = false;
                                name = "";
                              });
                            }
                          } else {
                            setState(() {
                              newpassworderror = false;
                              name = "";
                            });
                          }
                        },
                        suffixIcon: IconButton(
                          color: Colors.grey.shade400,
                          icon: Icon(
                            _obsText ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obsText = !_obsText;
                            });
                          },
                        ),
                        obscureText: _obsText,
                        maxLines: 1,
                        fieldController: newPasswordController,
                        cursorHeight: height / 34,
                        cursorcolor: CustomTheme.primarycolor,
                        hint: "New Password",
                        fieldName: '',
                        hintStyle: CustomTheme.inputFieldHintStyle,
                        autofocus: false,
                      ),
                      Visibility(
                        visible: newpassworderror,
                        child: Text(
                          "$name",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(height: height / 16),
                      CoustomInPutField(
                        validator: (value) {
                          if (value == "") {
                            setState(() {
                              confirmpassworderror = true;
                              name1 = "Please Enter password";
                            });
                          } else if (value != newPasswordController.text) {
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
                            _osText ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _osText = !_osText;
                            });
                          },
                        ),
                        obscureText: _osText,
                        maxLines: 1,
                        fieldController: conformPasswordController,
                        cursorHeight: height / 34,
                        cursorcolor: CustomTheme.primarycolor,
                        hint: 'Conform Password',
                        fieldName: '',
                        hintStyle: CustomTheme.inputFieldHintStyle,
                        autofocus: false,
                      ),
                      Visibility(
                        visible: confirmpassworderror,
                        child: Text(
                          '$name1',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      CustomBlueButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            if (oldpassword == false &&
                                newpassworderror == false &&
                                confirmpassworderror == false) {
                              setState(() {
                                is_loading = true;
                                FocusScope.of(context).unfocus();
                              });
                              await changePassword();
                              setState(() {
                                is_loading = false;
                              });
                            }
                          }
                          ;
                        },
                        title: 'Submit',
                        backgroundColor: CustomTheme.primarycolor,
                      ),
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
