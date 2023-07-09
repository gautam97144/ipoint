import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Screen/change_password.dart';
import 'package:ipoint/Screen/login_page.dart';
import 'package:ipoint/Screen/verification_screen.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
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
import 'dart:io';
import 'no_internet_screen.dart';

class Security extends StatefulWidget {
  const Security({Key? key}) : super(key: key);

  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  //veriable
  File? image;
  bool isVisible = false;
  bool isVisible1 = true;
  bool isVisible2 = false;
  bool isVisible3 = true;
  bool isVisible4 = false;
  bool isVisible5 = true;
  bool usernameerror = false;
  bool phoneerror = false;

  bool isRead1 = true;
  bool isRead2 = true;
  bool isRead3 = true;

  bool isSelecte = true;
  bool isSelecte1 = true;

  CommonModel? commonModel;
  UserModel? userModel;
  String token = '';

  bool is_loading = false;

  //controller
  TextEditingController usernameController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  final _formkey1 = GlobalKey<FormState>();

  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());
    userModel = UserModel.fromJson(jsondecode);
  }

  gettoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    setState(() {
      this.token = token ?? '';
    });
  }

  setmodel(value) async {
    String data = jsonEncode(value);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("abc", data);
  }

  clearSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('abc');
  }

  Future usernameUpdate() async {
    FormData formData = FormData.fromMap(
        {"edit": "username", "username": usernameController.text});

    try {
      Response response = await ApiClient().dio.post(Constant.updateProfile,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        print(response.data);
        userModel = UserModel.fromJson(response.data);

        setState(() {
          userModel?.data?.username = usernameController.text;
        });

        if (userModel?.success == 1) {
          setmodel(userModel!.toJson());
          Fluttertoast.showToast(msg: "${userModel?.message}");
        } else {
          Fluttertoast.showToast(msg: "${userModel?.message}");
        }
      }
    } on DioError catch (e) {
      print(e.message);
      // Fluttertoast.showToast(msg: "${commonModel?.message}");

    }
  }

  Future updateMobileGetOtp() async {
    FormData formData = FormData.fromMap(
        {"edit": "get_otp", "mobile": phonenumberController.text});

    try {
      Response response = await ApiClient().dio.post(
          Constant.updateMobileGetOtp,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        print(response.data);
        userModel = UserModel.fromJson(response.data);

        setState(() {
          userModel?.data?.mobile = phonenumberController.text;
        });

        if (userModel?.success == 1) {
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              fullscreenDialog: true,
              pageBuilder: (BuildContext context, _, __) =>
                  VerificationScreen(number: phonenumberController.text)));

          setmodel(userModel!.toJson());

          Fluttertoast.showToast(msg: "${userModel?.message}");
          // return
        } else {
          Fluttertoast.showToast(msg: "${userModel?.message}");
        }
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  @override
  initState() {
    super.initState();
    checkRealTime();
    getModel();
    gettoken();
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
      child: Stack(children: [
        SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  SizedBox(height: height / 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: CustomTheme.fontFamily),
                            ),
                            userModel?.data?.name == null
                                ? Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ))
                                : Text(
                                    '${userModel?.data?.name}',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: CustomTheme.fontFamily),
                                  ),
                          ],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          _showMyDialog();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: Container(
                            height: height / 13,
                            width: height / 13,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.grey.shade300,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(Images.logoutImage, scale: 3),
                                  Text("Logout",
                                      style: CustomTheme.textStyle.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      CustomProfilePicture(
                          status: 1,
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             MenuPage()));
                          },
                          url: userModel?.data?.profile)
                    ],
                  ),
                  SizedBox(height: height / 40),
                  Text("Security", style: CustomTheme.title),
                  SizedBox(height: height / 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Form(
                        key: _formkey,
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                width: width / 4,
                                child: Text(
                                  "Username",
                                  style: CustomTheme.title4,
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.only(
                                    left: width / 23, right: width / 23),
                                child: isSelecte
                                    ? Text(
                                        userModel?.data?.username ?? "",
                                        style: CustomTheme.body1.copyWith(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15),
                                      )
                                    : Visibility(
                                        visible: true,
                                        child: TextFormField(
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    r'^[a-z 0-9_\-=@,\.;]+$')),
                                            FilteringTextInputFormatter.deny(
                                                RegExp(r'\s')),
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
                                          controller: usernameController,
                                          readOnly: isRead1,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                              )),
                              Visibility(
                                visible: isVisible,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        height: height / 20,
                                        decoration: BoxDecoration(
                                            color: CustomTheme.primarycolor,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: TextButton(
                                            onPressed: () async {
                                              if (_formkey.currentState!
                                                  .validate()) {
                                                if (usernameerror == false) {
                                                  setState(() {
                                                    is_loading = true;
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                  });
                                                  await usernameUpdate();
                                                  setState(() {
                                                    is_loading = false;

                                                    isVisible1 = true;
                                                    isVisible = false;
                                                    isRead1 = true;
                                                  });
                                                }
                                              }
                                            },
                                            child: Text(
                                              'Update',
                                              style: CustomTheme.body2,
                                            ))),
                                    Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isSelecte = true;
                                            isVisible1 = true;
                                            isVisible = false;
                                            isRead1 = true;
                                            usernameerror = false;
                                          });
                                        },
                                        child: Icon(
                                          Icons.cancel,
                                          color: CustomTheme.red,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Visibility(
                              //   visible: isVisible1,
                              //   child: TextButton(
                              //       onPressed: () {
                              //         setState(() {
                              //           isSelecte = false;
                              //           isVisible = true;
                              //           isVisible1 = false;
                              //           isRead1 = false;
                              //         });
                              //       },
                              //       style: ButtonStyle(
                              //           backgroundColor:
                              //               MaterialStateProperty.all(
                              //                   CustomTheme.grey),
                              //           overlayColor: MaterialStateProperty.all(
                              //               Colors.transparent),
                              //           shape: MaterialStateProperty.all(
                              //               RoundedRectangleBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(30.0),
                              //           ))),
                              //       child:
                              //           Text("Edit", style: CustomTheme.body2)),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      // Visibility(
                      //   visible: usernameerror,
                      //   child: Text(
                      //     'please Enter username',
                      //     style: TextStyle(color: Colors.red),
                      //   ),
                      // ),
                      SizedBox(height: height / 20),
                      Row(
                        children: [
                          Container(
                            width: width / 4,
                            child: Text(
                              "Password",
                              style: CustomTheme.title4,
                            ),
                          ),
                          Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(
                                      left: width / 23, right: width / 23),
                                  child: Text(
                                    '********',
                                    style: CustomTheme.body1.copyWith(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15),
                                  ))),
                          Visibility(
                            visible: isVisible2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    height: height / 20,
                                    decoration: BoxDecoration(
                                        color: CustomTheme.primarycolor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangePassword()));
                                        },
                                        child: Text(
                                          'Update',
                                          style: CustomTheme.body2,
                                        ))),
                                Container(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isVisible3 = true;
                                        isVisible2 = false;
                                        isRead2 = true;
                                      });
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      color: CustomTheme.red,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isVisible3,
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible2 = true;
                                    isVisible3 = false;
                                    isRead2 = false;
                                  });
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        CustomTheme.grey),
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ))),
                                child: Text("Edit", style: CustomTheme.body2)),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 20),
                      Form(
                        key: _formkey1,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: width / 4,
                                child: Text(
                                  "Phone Number",
                                  style: CustomTheme.title4,
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          left: width / 23, right: width / 23),
                                      child: isSelecte1
                                          ? Text(
                                              userModel?.data?.mobile ?? "",
                                              style: CustomTheme.body1.copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15),
                                            )
                                          : Visibility(
                                              visible: true,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.phone,
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
                                                controller:
                                                    phonenumberController,
                                                readOnly: isRead3,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none),
                                              ),
                                            ))),
                              Visibility(
                                visible: isVisible4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        height: height / 20,
                                        decoration: BoxDecoration(
                                            color: CustomTheme.primarycolor,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: TextButton(
                                            onPressed: () async {
                                              if (_formkey1.currentState!
                                                  .validate()) {
                                                if (phoneerror == false) {
                                                  setState(() {
                                                    is_loading = true;
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                  });
                                                  await updateMobileGetOtp();

                                                  is_loading = false;

                                                  setState(() {
                                                    is_loading = false;
                                                    isVisible5 = true;
                                                    isVisible4 = false;
                                                    isRead3 = true;
                                                  });
                                                }
                                              }
                                            },
                                            child: Text(
                                              'Update',
                                              style: CustomTheme.body2,
                                            ))),
                                    Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isVisible5 = true;
                                            isVisible4 = false;
                                            isRead3 = true;
                                            phoneerror = false;
                                            isSelecte1 = true;
                                          });
                                        },
                                        child: Icon(
                                          Icons.cancel,
                                          color: CustomTheme.red,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: isVisible5,
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isSelecte1 = false;
                                        isVisible4 = true;
                                        isVisible5 = false;
                                        isRead3 = false;
                                      });
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                CustomTheme.grey),
                                        overlayColor: MaterialStateProperty.all(
                                            Colors.transparent),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ))),
                                    child:
                                        Text("Edit", style: CustomTheme.body2)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: phoneerror,
                        child: Text(
                          'Please Enter Phone Number',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(height: height / 20),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: width / 4,
                              child: Text(
                                "Refferal Code",
                                style: CustomTheme.title4,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(
                                      left: width / 23, right: width / 23),
                                  child: Text(
                                    userModel?.data?.refCode ?? "",
                                    style: CustomTheme.body1.copyWith(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: CustomTheme.body4,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Are you Sure you want to Logout ?',
                    style: CustomTheme.textStyle.copyWith(fontSize: 15)),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'No',
                style: TextStyle(color: CustomTheme.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Logout',
                style: TextStyle(color: CustomTheme.red),
              ),
              onPressed: () {
                clearSharedPrefs();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Loginpage()),
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
