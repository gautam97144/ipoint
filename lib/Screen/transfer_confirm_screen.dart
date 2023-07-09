import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/bottom_navigation.dart';
import 'package:ipoint/Screen/new_update_screen.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/commonmodel.dart';
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

class TransferConfirm extends StatefulWidget {
  String? point;
  String? cod;
  TransferConfirm({Key? key, this.point, this.cod}) : super(key: key);

  @override
  _TransferConfirmState createState() => _TransferConfirmState();
}

class _TransferConfirmState extends State<TransferConfirm> {
  UserModel? userModel;
  UserData? userData;
  File? image;
  bool isLoader = false;
  CommonModel? commonModel;
  var formatter = NumberFormat('#,##,000');
  var totalPoint;

  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    setState(() {});
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());
    userModel = UserModel.fromJson(jsondecode);

    totalBalance(userModel!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getModel();
    fetchUserData();
    print(widget.cod);
    print(widget.point);
  }

  Future transferIpoint() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    FormData data = FormData.fromMap(
        {"tansfer_to_ref_code": widget.cod, "tansfer_point": widget.point});

    try {
      Response response = await ApiClient().dio.post(Constant.transfer,
          data: data,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          commonModel = CommonModel.fromJson(response.data);
        });
      }
      if (response.statusCode == 200) {
        if (commonModel?.success == 1) {
          CustomToast.toast("${commonModel?.message}");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BottomNavigation()));
        } else {
          CustomToast.toast("${commonModel?.message}");
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
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

  totalBalance(UserModel userModel) {
    totalPoint = double.parse(userModel.data!.ipointWallet!) -
        double.parse(widget.point!);
    print(totalPoint);
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            backgroundColor: CustomTheme.white,
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                            fontFamily: CustomTheme.fontFamily),
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
                Expanded(
                  child: Container(
                    color: CustomTheme.primarycolor,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                  'Amount of points you would like to transfer:',
                                  style: TextStyle(
                                      fontFamily: CustomTheme.fontFamily),
                                ),
                                //images
                              ],
                            ),
                            SizedBox(
                              height: Height / 50,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: CustomTheme.white,
                              ),
                              child: Text(
                                widget.point.toString(),
                                style: CustomTheme.body1.copyWith(fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.centerLeft,
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: CustomTheme.white,
                                ),
                                child: Text(
                                  "${widget.cod}",
                                  style:
                                      CustomTheme.body1.copyWith(fontSize: 16),
                                )),
                            SizedBox(
                              height: Height / 6,
                            ),
                            Text(
                              'Your balance points after payment will be:',
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      height: Height / 16,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Colors.transparent,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${totalPoint ?? ""}",
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
                              height: Height / 40,
                            ),
                            Text(
                              'Please confirm your redeem and wait for the\n verification process before we proceed for your transaction.',
                              style:
                                  TextStyle(fontFamily: CustomTheme.fontFamily),
                            ),
                            SizedBox(
                              height: Height / 9,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: TextButton(
                                style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.yellow),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.0),
                                    ))),
                                onPressed: () async {
                                  setState(() {
                                    isLoader = true;
                                  });
                                  await transferIpoint();

                                  setState(() {
                                    isLoader = false;
                                  });
                                },
                                child:
                                    Text("Confirm", style: CustomTheme.body3),
                              ),
                            ),
                          ],
                        ),
                      ),
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
