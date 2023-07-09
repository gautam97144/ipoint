import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/agent_redeem_screen.dart';
import 'package:ipoint/Screen/gained.dart';
import 'package:ipoint/Screen/pay_screen.dart';
import 'package:ipoint/Screen/qr_scanner.dart';
import 'package:ipoint/Screen/redeem_point.dart';
import 'package:ipoint/Screen/terms_and_condition.dart';
import 'package:ipoint/Screen/transaction.dart';
import 'package:ipoint/Screen/transfer_screen.dart';
import 'package:ipoint/Screen/unique_code_screen.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/user_data_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu_page.dart';
import 'no_internet_screen.dart';

class Redeem extends StatefulWidget {
  const Redeem({Key? key}) : super(key: key);

  @override
  _RedeemState createState() => _RedeemState();
}

class _RedeemState extends State<Redeem> {
  final qrkey = GlobalKey(debugLabel: 'QR');

  QRViewController? qrViewController;
  String? qrCode;
  int isselected = 0;
  File? image;
  //var formatter = NumberFormat('#,##,000');
  UserModel? userModel;
  UserData? userData;

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
    fetchUserdata();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    qrViewController?.dispose();
  }

  Future fetchUserdata() async {
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
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Stack(children: [
      SafeArea(
        child: Scaffold(
          backgroundColor: CustomTheme.white,
          body: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: CustomTheme.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Height / 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Welcome',
                                      style: CustomTheme.body3.copyWith(
                                          fontWeight: FontWeight.normal)),
                                  userModel?.data?.name == null
                                      ? Container(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ))
                                      : Text('${userModel?.data?.name}',
                                          maxLines: 2,
                                          style: CustomTheme.body3.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            CustomProfilePicture(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MenuPage()));
                                },
                                url: userModel?.data?.profile)
                          ],
                        ),
                        SizedBox(
                          height: Height / 50,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: CustomTheme.primarycolor,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                //images
                              ],
                            ),
                            SizedBox(
                              height: Height / 70,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IntrinsicWidth(
                                  child: Wrap(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: Colors.transparent,
                                        ),
                                        child: userData?.data?.ipointWallet ==
                                                null
                                            ? Text("")
                                            : Wrap(
                                                children: [
                                                  Text(
                                                    "${userData?.data?.ipointWallet}",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontFamily: CustomTheme
                                                            .fontFamily,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15),
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
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Referral Code:${userModel?.data?.refCode}",
                                        style: CustomTheme.body1,
                                      ),
                                      SizedBox(width: 3),
                                      GestureDetector(
                                          onLongPress: () {
                                            Clipboard.setData(ClipboardData(
                                                    text: (userModel
                                                            ?.data?.refCode ??
                                                        "")))
                                                .then((_) =>
                                                    Fluttertoast.showToast(
                                                        msg: "code copied!"));
                                          },
                                          child: Icon(Icons.copy))
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 12),
                              width: double.infinity,
                              height: Height / 10,
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QrScreen()));
                                        },
                                        child: Text(
                                          "#1P",
                                          style: CustomTheme.body1
                                              .copyWith(fontSize: 24),
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text(
                                        "Qr Code",
                                        style: CustomTheme.body1,
                                      )
                                    ]),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PayScreen()));
                                      },
                                      child: Column(children: [
                                        Image.asset(
                                          Images.payIcon,
                                          scale: 4,
                                        ),
                                        Expanded(child: SizedBox()),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text(
                                            "Pay",
                                            style: CustomTheme.body1,
                                          ),
                                        )
                                      ]),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TransferScreen()));
                                      },
                                      child: Column(children: [
                                        Image.asset(
                                          Images.transferIcon,
                                          scale: 4,
                                        ),
                                        Expanded(child: SizedBox()),
                                        Text(
                                          "Transfer",
                                          style: CustomTheme.body1,
                                        )
                                      ]),
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              height: Height / 30,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isselected = 0;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Redeem_point()));
                                    });
                                  },
                                  child: Container(
                                    height: Height / 6,
                                    width: Width / 3.5,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade400,
                                          blurRadius: 13,
                                          spreadRadius: 1.0,
                                          offset: Offset(1.0, 1.0),
                                        ),
                                      ],
                                      color: isselected == 0
                                          ? CustomTheme.yellow
                                          : CustomTheme.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(children: [
                                      SizedBox(height: Height / 30),
                                      Image.asset(Images.redeemImg, scale: 3),
                                      SizedBox(height: Height / 70),
                                      Text("Redeem", style: CustomTheme.body1),
                                    ]),
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isselected = 1;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Transaction()));
                                    });
                                  },
                                  child: Container(
                                    height: Height / 6,
                                    width: Width / 3.5,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade400,
                                          blurRadius: 13,
                                          spreadRadius: 1.0,
                                          offset: Offset(1.0, 1.0),
                                        ),
                                      ],
                                      color: isselected == 1
                                          ? CustomTheme.yellow
                                          : CustomTheme.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(children: [
                                      SizedBox(height: Height / 24),
                                      Image.asset(Images.transactionImg,
                                          scale: 3.5),
                                      SizedBox(height: Height / 35),
                                      Text("Transaction(s)",
                                          style: CustomTheme.body1),
                                    ]),
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isselected = 2;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Gained()));
                                    });
                                  },
                                  child: Container(
                                    height: Height / 6,
                                    width: Width / 3.5,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade400,
                                          blurRadius: 13,
                                          spreadRadius: 0.0,
                                          offset: Offset(1.0, 1.0),
                                        ),
                                      ],
                                      color: isselected == 2
                                          ? CustomTheme.yellow
                                          : CustomTheme.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(children: [
                                      SizedBox(height: Height / 30),
                                      Image.asset(Images.gainedImg, scale: 3),
                                      SizedBox(height: Height / 35),
                                      Text("Gained", style: CustomTheme.body1),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Height / 14,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 13,
                                    spreadRadius: 1.0,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(30),
                                color: CustomTheme.white,
                              ),
                              child: ListTile(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             TermsAndCondition()));
                                },
                                leading: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: CustomTheme.primarycolor,
                                  ),
                                  child: Image.asset(
                                    'assets/images/transaction2.png',
                                    scale: 3,
                                    // fit: BoxFit.contain,
                                  ),
                                ),
                                title: Text(
                                  'Terms and Conditions',
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontFamily: CustomTheme.fontFamily),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Height / 35,
                            ),
                            Container(
                              //  height: 60,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 13,
                                    spreadRadius: 1.0,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(30),
                                color: CustomTheme.white,
                              ),
                              child: ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: CustomTheme.primarycolor,
                                  ),
                                  child: Image.asset(
                                    'assets/images/transaction2.png',
                                    scale: 3,
                                    // fit: BoxFit.contain,
                                  ),
                                ),
                                title: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontFamily: CustomTheme.fontFamily),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
      Provider.of<InternetConnectivityCheck>(context, listen: true).isNoInternet
          ? NoInterNetScreen()
          : SizedBox.shrink(),
    ]);
  }

  Future<void> scanQr() async {
    final qrCode = await FlutterBarcodeScanner.scanBarcode(
        "0xff00F0FF", "cancel", true, ScanMode.QR);

    if (!mounted) return;
    setState(() {
      this.qrCode = qrCode;
    });
  }
}
