import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/gained.dart';
import 'package:ipoint/Screen/redeem_point.dart';
import 'package:ipoint/Screen/transaction.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/user_data_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'agent_list.dart';
import 'menu_page.dart';
import 'no_internet_screen.dart';

class AgentReedem extends StatefulWidget {
  const AgentReedem({Key? key}) : super(key: key);

  @override
  _AgentReedemState createState() => _AgentReedemState();
}

class _AgentReedemState extends State<AgentReedem> {
  int isselected = 0;
  File? image;
  var formatter = NumberFormat('#,##,000');
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
    alluserData();
  }

  void alluserData() {
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
    return Stack(children: [
      SafeArea(
        child: Scaffold(
          backgroundColor: CustomTheme.primarycolor,
          body: SingleChildScrollView(
            child: Column(
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
                              // color: CustomTheme.red,
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
                            // Container(
                            //   // color: CustomTheme.red,
                            //   margin: EdgeInsets.only(right: 30),
                            //   child: Image.asset(
                            //     Images.splashIpoint,
                            //     scale: 4,
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => MenuPage()));
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  image != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: CircleAvatar(
                                            radius: 35,
                                            backgroundImage: Image.file(
                                              image!,
                                              fit: BoxFit.fill,
                                            ).image,
                                          ),
                                        )
                                      : userModel?.data?.profile != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: CircleAvatar(
                                                radius: 35,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        userModel!
                                                            .data!.profile!),
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: CircleAvatar(
                                                child: Icon(
                                                    Icons.account_circle_sharp),
                                                radius: 35,
                                              ),
                                            ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Height / 50,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
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
                                          formatter
                                              .format(
                                                  userData?.data?.ipointWallet)
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily:
                                                  CustomTheme.fontFamily,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            'pts',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                          ],
                        ),
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
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => Redeem_point()));
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
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => Transaction()));
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
                                Image.asset(Images.transactionImg, scale: 3.5),
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
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => Gained()
                                //
                                //     )
                                // );
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
                      SizedBox(height: Height / 30),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isselected = 3;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AgentList()));
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
                                color: isselected == 3
                                    ? CustomTheme.yellow
                                    : CustomTheme.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(children: [
                                SizedBox(height: Height / 30),
                                Image.asset(Images.agenticon, scale: 3),
                                SizedBox(height: Height / 70),
                                Text("Agent", style: CustomTheme.body1),
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
                )
              ],
            ),
          ),
        ),
      ),
      Provider.of<InternetConnectivityCheck>(context, listen: true).isNoInternet
          ? NoInterNetScreen()
          : SizedBox.shrink(),
    ]);
  }
}
