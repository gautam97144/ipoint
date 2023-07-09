import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/Widget/custom_yellow_button.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/payment_request_model.dart';
import 'package:ipoint/model/user_data_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu_page.dart';
import 'no_internet_screen.dart';

class Redeem_balance extends StatefulWidget {
  String? points;
  Redeem_balance({Key? key, this.points}) : super(key: key);

  @override
  _Redeem_balanceState createState() => _Redeem_balanceState();
}

class _Redeem_balanceState extends State<Redeem_balance> {
  UserModel? userModel;
  UserData? userData;
  File? image;
  var formatter = NumberFormat('#,##,000');
  String leftAmount = "";
  int? amount;
  bool isLoader = false;
  var totalPoint;

  RedeemRequest? redeemRequest;

  Future redeemData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    FormData data = FormData.fromMap({"points": widget.points});

    try {
      Response response = await ApiClient().dio.post(Constant.redeemRequest,
          data: data,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        redeemRequest = RedeemRequest.fromJson(response.data);
        print("gautam gohil" + response.data.toString() + "gautam gohil");

        if (redeemRequest?.success == 1) {
          Fluttertoast.showToast(msg: "${redeemRequest?.message}");
        } else {
          Fluttertoast.showToast(msg: "${redeemRequest?.message}");
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    setState(() {});
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());

    userModel = UserModel.fromJson(jsondecode);

    totalBalance(userModel!);
  }

  // int? leftamount() {
  //   amount = (userModel!.data!.ipointWallet) - (widget.points!);
  //   return amount;
  // }

  totalBalance(UserModel userModel) {
    totalPoint = double.parse(userModel.data!.ipointWallet!) -
        double.parse(widget.points!);
    print(totalPoint);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getModel();
    fetchUserData();
    print(widget.points.toString() + "lllll");
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
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            backgroundColor: CustomTheme.primarycolor,
            body: Column(
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
                                              fontFamily:
                                                  CustomTheme.fontFamily),
                                        ),
                                ],
                              ),
                            ),
                            CustomProfilePicture(
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
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Height / 70,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Amount of points you would like to redeem:',
                            style:
                                TextStyle(fontFamily: CustomTheme.fontFamily),
                          ),
                          //images
                        ],
                      ),
                      SizedBox(
                        height: Height / 50,
                      ),
                      IntrinsicWidth(
                        child: Row(
                          children: [
                            Container(
                                constraints: BoxConstraints(minWidth: 100),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: Height / 16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: CustomTheme.yellow,
                                ),
                                child: Row(
                                  children: [
                                    widget.points == null
                                        ? Text("")
                                        : Text(
                                            "${widget.points.toString()}",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontFamily:
                                                    CustomTheme.fontFamily,
                                                fontWeight: FontWeight.w800),
                                          ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'pts',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Height / 20,
                      ),
                      Text(
                        'Your balance points after redeem will be:',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: CustomTheme.fontFamily),
                      ),
                      SizedBox(
                        height: Height / 40,
                      ),
                      IntrinsicWidth(
                        child: Row(
                          children: [
                            Container(
                                constraints: BoxConstraints(
                                    // minWidth: Width / 3.6,
                                    ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: Height / 16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "$totalPoint",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: CustomTheme.fontFamily,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'pts',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Height / 40,
                      ),
                      Text(
                        'Please confirm your redeem and wait for the\n verification process before we proceed for your transaction.',
                        style: TextStyle(fontFamily: CustomTheme.fontFamily),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: Height / 5,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ))),
                      onPressed: () async {
                        setState(() {
                          isLoader = true;
                        });
                        await redeemData();
                        setState(() {
                          isLoader = false;
                        });
                      },
                      child: Text("Confirm", style: CustomTheme.body3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Provider.of<InternetConnectivityCheck>(context, listen: true)
                .isNoInternet
            ? NoInterNetScreen()
            : SizedBox.shrink(),
        isLoader == true ? LoaderLayoutWidget() : SizedBox.shrink()
      ],
    );
  }
}
