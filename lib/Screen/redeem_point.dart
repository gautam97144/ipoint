import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/redeembalance.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/model/payment_request_model.dart';
import 'package:ipoint/model/user_data_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

import 'menu_page.dart';
import 'no_internet_screen.dart';

class Redeem_point extends StatefulWidget {
  const Redeem_point({Key? key}) : super(key: key);

  @override
  _Redeem_pointState createState() => _Redeem_pointState();
}

class _Redeem_pointState extends State<Redeem_point> {
  final formkey = GlobalKey<FormState>();

  UserModel? userModel;
  RedeemRequest? redeemRequest;
  UserData? userData;
  File? image;
  var formatter = NumberFormat('#,##,000');
  TextEditingController textEditingController = TextEditingController();

  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    setState(() {});
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());
    userModel = UserModel.fromJson(jsondecode);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getModel();
    fetchUserData();
  }

  Future fetchUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    try {
      Response response = await ApiClient().dio.post(Constant.userData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          userData = UserData.fromJson(response.data);
        });
      }
      if (response.statusCode == 200) {
        print("gautam gohil" + response.data.toString() + "gautam gohil");
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: CustomTheme.primarycolor,
              body: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: CustomTheme.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            SizedBox(
                              height: Height / 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  fontFamily:
                                                      CustomTheme.fontFamily),
                                            ),
                                    ],
                                  ),
                                ),
                                CustomProfilePicture(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MenuPage()));
                                    },
                                    url: userModel?.data?.profile)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Available', style: CustomTheme.body1),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'assets/images/ipoint.png',
                                height: 20,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Height / 125,
                          ),
                          IntrinsicWidth(
                            child: Wrap(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Colors.transparent,
                                  ),
                                  child: userData?.data?.ipointWallet == null
                                      ? Text("")
                                      : Wrap(
                                          children: [
                                            Text(
                                              "${userData?.data?.ipointWallet}",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontFamily:
                                                      CustomTheme.fontFamily,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Text(
                                                'pts',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Height / 35,
                          ),
                          Text(
                            'Redeem',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: CustomTheme.fontFamily),
                          ),
                          SizedBox(
                            height: Height / 50,
                          ),
                          Text(
                            'Points available for redeem is upto:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: CustomTheme.fontFamily),
                          ),
                          SizedBox(
                            height: Height / 40,
                          ),
                          IntrinsicWidth(
                            child: Wrap(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: CustomTheme.yellow,
                                  ),
                                  constraints: BoxConstraints(minWidth: 100),
                                  child: Wrap(
                                      runAlignment: WrapAlignment.center,
                                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          "100000",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontFamily:
                                                  CustomTheme.fontFamily,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            'pts',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      ]),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Height / 30,
                          ),
                          Text(
                            'Amount of points you would like to redeem:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: CustomTheme.fontFamily),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: CustomTheme.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == "") {
                                    return "";
                                  }
                                },
                                controller: textEditingController,
                                cursorColor: CustomTheme.primarycolor,
                                decoration: const InputDecoration(
                                  hintText: 'points to redeem',
                                  hintStyle: TextStyle(fontSize: 12),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: Height / 8,
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final GlobalKey<SlideActionState> _key = GlobalKey();
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: SlideAction(
                            elevation: 0,
                            sliderButtonIconSize: 16,
                            height: 60,
                            text: "Swipe to Redeem",
                            textStyle: CustomTheme.body3,
                            key: _key,
                            onSubmit: () {
                              if (formkey.currentState!.validate()) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Redeem_balance(
                                            points: textEditingController.text
                                                .toString()))).then(
                                    (value) => textEditingController.clear());
                                Future.delayed(
                                  Duration(seconds: 2),
                                  () => _key.currentState?.reset(),
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg: "please Enter Point");
                              }
                            },
                            innerColor: CustomTheme.black,
                            outerColor: CustomTheme.yellow,
                          ),
                        );
                      },
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
        ],
      ),
    );
  }
}
