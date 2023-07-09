import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

import 'login_page.dart';
import 'no_internet_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool email = false;
  bool is_loading = false;

  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  CommonModel? commonModel;
  String token = '';

  Future forgotPassword() async {
    FormData formData = FormData.fromMap({
      "email": emailController.text,
    });

    try {
      Response response = await ApiClient().dio.post(Constant.forgotPassword,
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
      child: Stack(children: [
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
                    SizedBox(height: height / 10),
                    CoustomInPutField(
                      fieldInputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == '') {
                          setState(() {
                            email = true;
                          });
                        } else {
                          setState(() {
                            email = false;
                          });
                        }
                      },
                      fieldController: emailController,
                      cursorHeight: height / 34,
                      cursorcolor: CustomTheme.primarycolor,
                      hint: "Email",
                      fieldName: '',
                      hintStyle: CustomTheme.inputFieldHintStyle,
                      autofocus: true,
                    ),
                    Visibility(
                      visible: email,
                      child: Text(
                        'please enter your email',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    CustomBlueButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          if (email == false) {
                            setState(() {
                              is_loading = true;
                              FocusScope.of(context).unfocus();
                            });
                            await forgotPassword();
                            setState(() {
                              is_loading = false;
                            });
                          }
                          ;
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
      ]),
    );
  }
}
