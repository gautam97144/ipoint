import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

import 'agent_detail.dart';
import 'menu_page.dart';
import 'no_internet_screen.dart';

class AgentList extends StatefulWidget {
  const AgentList({Key? key}) : super(key: key);

  @override
  _AgentListState createState() => _AgentListState();
}

class _AgentListState extends State<AgentList> {
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
                        'Agents',
                        style: CustomTheme.body4,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: GridView.builder(
                            itemCount: 7,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 160,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                                AssetImage(Images.agentProfile),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Robert wong lee",
                                              style: CustomTheme.body1
                                                  .copyWith(fontSize: 14),
                                            ),
                                          )
                                        ]),
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
                                    Wrap(children: [
                                      Row(children: [
                                        Text(
                                          "Sales Received : ",
                                          style: CustomTheme.body1.copyWith(
                                              color: Colors.grey,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                            child: Text(
                                          "RM 25000",
                                          style: CustomTheme.body1.copyWith(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ))
                                      ]),
                                    ]),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AgentDetail()));
                                      },
                                      child: Container(
                                        height: 30,
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: CustomTheme.yellow,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          "More Details",
                                          style: CustomTheme.body1,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    )),
                              );
                            }),
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
