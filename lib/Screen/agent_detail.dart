import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/user_data_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'commission.dart';
import 'decommission.dart';
import 'menu_page.dart';
import 'no_internet_screen.dart';

class AgentDetail extends StatefulWidget {
  const AgentDetail({Key? key}) : super(key: key);

  @override
  _AgentDetailState createState() => _AgentDetailState();
}

class _AgentDetailState extends State<AgentDetail> {
  UserModel? userModel;
  UserData? userData;
  File? image;
  var formatter = NumberFormat('#,##,000');

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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stack(children: [
      SafeArea(
        child: Scaffold(
          backgroundColor: CustomTheme.primarycolor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: CustomTheme.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                      SizedBox(
                        height: height / 50,
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
                                        borderRadius: BorderRadius.circular(12),
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
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
                        //images
                      ],
                    ),
                    SizedBox(
                      height: height / 130,
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
                                            fontFamily: CustomTheme.fontFamily,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
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
                    // userModel?.data?.ipointWallet == null
                    //     ? Text("")
                    //     : Text(
                    //         '${userModel?.data?.ipointWallet}',
                    //         style: TextStyle(
                    //             fontSize: 35,
                    //             fontWeight: FontWeight.w800,
                    //             fontFamily: CustomTheme.fontFamily),
                    //       ),
                    //images
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey.shade200,
                      ),
                      width: 230,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: CustomTheme.yellow,
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: Image.asset(
                            Images.searchIcon,
                            scale: 3,
                          ),
                        )),
                    Spacer(),
                    Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: CustomTheme.grey,
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: Image.asset(
                            Images.ractangleIcon,
                            scale: 3,
                          ),
                        ))
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        "Agents > Robert Wong Lee",
                        style: CustomTheme.body4,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 7),
                        width: double.infinity,
                        height: height / 6,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                        decoration: BoxDecoration(
                            color: CustomTheme.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundImage:
                                    AssetImage(Images.agentProfile),
                              ),
                              Container(
                                //color: Colors.red,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: width / 2.8,
                                      // color: Colors.red,
                                      child: Text(
                                        "Robert Wong Lee uuuu",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomTheme.body1
                                            .copyWith(fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Agent since : ",
                                          style: CustomTheme.body1.copyWith(
                                              color: Colors.grey, fontSize: 10),
                                        ),
                                        Text(
                                          "20 Feb 2021",
                                          style: CustomTheme.body1.copyWith(
                                              color: Colors.grey, fontSize: 13),
                                        )
                                      ],
                                    ),
                                    Row(children: [
                                      Text(
                                        "Sales Received : ",
                                        style: CustomTheme.body1.copyWith(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "RM 25000",
                                        style: CustomTheme.body1.copyWith(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: CustomTheme.yellow,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: height / 18,
                                      width: width / 5,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "30",
                                                style: CustomTheme.body1,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                        opaque: false,
                                                        fullscreenDialog: true,
                                                        pageBuilder:
                                                            (BuildContext
                                                                        context,
                                                                    _,
                                                                    __) =>
                                                                Commission()));
                                              },
                                              child: Image.asset(
                                                Images.editIcon,
                                                scale: 3,
                                              ),
                                            )
                                          ]),

                                      // width: double.infinity,
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  CustomTheme.darkGrey)),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                                opaque: false,
                                                fullscreenDialog: true,
                                                pageBuilder:
                                                    (BuildContext context, _,
                                                            __) =>
                                                        Decommission()));
                                      },
                                      child: Text(
                                        "Decommission",
                                        style: CustomTheme.body1
                                            .copyWith(color: CustomTheme.white),
                                      ),
                                    )
                                  ])
                            ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                            itemCount: 8,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: CustomTheme.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 15),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "wong che lai car ce ",
                                                style: CustomTheme.body5,
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              '10 Feb 2021',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            SizedBox(width: 60),
                                            Text(
                                              formatter.format(550).toString(),
                                              style: CustomTheme.body3,
                                            ),
                                          ],
                                        ),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Provider.of<InternetConnectivityCheck>(context, listen: true).isNoInternet
          ? NoInterNetScreen()
          : SizedBox.shrink(),
    ]);
  }
}
