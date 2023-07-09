import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/gained_model.dart';
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
import 'dart:io';

class Gained extends StatefulWidget {
  const Gained({Key? key}) : super(key: key);

  @override
  _GainedState createState() => _GainedState();
}

class _GainedState extends State<Gained> {
  UserModel? userModel;
  var formatter = NumberFormat('#,##,000');
  UserData? userData;
  GainedModel? gainedModel;
  var newDate;
  File? image;
  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    setState(() {});
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());
    userModel = UserModel.fromJson(jsondecode);
  }

  getFormatedDate(date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('d MMM y');
    newDate = outputFormat.format(inputDate);
    return newDate;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getModel();
    alluserdata();
    gainPointList();
  }

  void alluserdata() {
    fetchUserData();
  }

  Future gainPointList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    try {
      print("hello");
      Response response = await ApiClient().dio.post(Constant.gainedPoint,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          gainedModel = GainedModel.fromJson(response.data);
        });
      }

      print(gainedModel);

      if (response.statusCode == 200) {
        print("gautam gohil" + response.data.toString() + "gautam gohil");
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
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            backgroundColor: CustomTheme.primarycolor,
            body: Column(
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
                                              fontFamily:
                                                  CustomTheme.fontFamily),
                                        ),
                                ],
                              ),
                            ),
                            CustomProfilePicture(
                                // onTap: (){
                                //   Navigator.push(context,MaterialPageRoute(builder: (context)=>MenuPage()));
                                // },
                                url: userModel?.data?.profile)
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
                            Text(
                              'Available',
                              style: CustomTheme.body1,
                            ),
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
                                            "${userData?.data?.ipointWallet}",
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
                      ]),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height / 50,
                        ),
                        Text(
                          'Gained',
                          style: CustomTheme.body4,
                        ),
                        SizedBox(
                          height: height / 50,
                        ),
                        gainedModel?.data == null
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              )
                            : gainedModel?.data?.length == 0
                                ? Center(
                                    child: Text(
                                      "No any Record",
                                      style: CustomTheme.body5,
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: gainedModel?.data != null
                                        ? gainedModel?.data?.length
                                        : 0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      getFormatedDate(
                                          gainedModel?.data?[index].createdAt);

                                      return Column(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(right: 7),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: CustomTheme.white,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "${gainedModel?.data?[index].description ?? ""}",
                                                        style:
                                                            CustomTheme.body5,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "$newDate",
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                    SizedBox(width: 30),
                                                    Text(
                                                      'Referral',
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                    SizedBox(width: 30),
                                                    Expanded(
                                                      child: Text(
                                                        "${gainedModel?.data?[index].points ?? ""}",
                                                        style:
                                                            CustomTheme.body3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          SizedBox(
                                            height: height / 80,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                      ]),
                  // ],
                  //),
                ),
              ],
            ),
          ),
        ),
        Provider.of<InternetConnectivityCheck>(context, listen: true)
                .isNoInternet
            ? NoInterNetScreen()
            : SizedBox.shrink(),
      ],
    );
  }
}
