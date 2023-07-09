import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/add_bank_card_page.dart';
import 'package:ipoint/Screen/booking_page.dart';
import 'package:ipoint/Screen/bottom_navigation.dart';
import 'package:ipoint/Screen/cashback_page.dart';
import 'package:ipoint/Screen/helpcenter_screen.dart';
import 'package:ipoint/Screen/myaccount_screen.dart';
import 'package:ipoint/Screen/payment_history_page.dart';
import 'package:ipoint/Screen/redeem.dart';
import 'package:ipoint/Screen/reffral.dart';
import 'package:ipoint/Screen/security.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/count_model.dart';
import 'package:ipoint/model/user_data_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'favourite_screen.dart';
import 'no_internet_screen.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  UserModel? userModel;
  int? index;
  Count? count;
  File? image;
  UserData? userData;
  var formatter = NumberFormat('#,##,000');

  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    //setState(() {});
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());
    setState(() {
      userModel = UserModel.fromJson(jsondecode);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getModel();
    notification();
    allfetchUserData();
  }

  notification() {
    CountNotification();
  }

  void allfetchUserData() {
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

  Future CountNotification() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      Response response = await ApiClient().dio.post(Constant.notificationCount,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          count = Count.fromJson(response.data);
        });
      }

      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var height = MediaQuery.of(context).size.height;

    var Width = MediaQuery.of(context).size.width;
    return Stack(children: [
      Scaffold(
          body: SafeArea(
        child: RefreshIndicator(
          color: CustomTheme.primarycolor,
          onRefresh: () async {
            await fetchUserData();
          },
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                              Text('Welcome',
                                  style: CustomTheme.body3
                                      .copyWith(fontWeight: FontWeight.normal)),
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
                    SizedBox(height: Height / 35),
                    Wrap(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: CustomTheme.primarycolor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 2.9,
                                  spreadRadius: 2.0,
                                  offset: Offset(4.0, 4.0),
                                ),
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 5.0,
                                    spreadRadius: 8.0,
                                    offset: Offset(6.0, 6.0))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Available',
                                            style: CustomTheme.body3
                                                .copyWith(fontSize: 15)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          Images.iponitImage,
                                          scale: 3,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Height / 70),
                                    IntrinsicWidth(
                                      child: Wrap(
                                        children: [
                                          Container(
                                            width: 190,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              // color: Colors.green,
                                            ),
                                            child: userData
                                                        ?.data?.ipointWallet ==
                                                    null
                                                ? Text("")
                                                : Wrap(
                                                    children: [
                                                      Text(
                                                        "${userData?.data?.ipointWallet}",
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow.clip,
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            fontFamily:
                                                                CustomTheme
                                                                    .fontFamily,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 15),
                                                        child: Text(
                                                          'pts',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  height: Height / 20,
                                  width: Width / 3.3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: CustomTheme.yellow),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BottomNavigation(
                                                    indexOne: index = 1,
                                                  )));
                                    },
                                    child: Text(
                                      "Redeem",
                                      style: CustomTheme.body2,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Height / 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 7)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomNavigation(
                                        index: index = 3,
                                      ))).then((value) async {
                            await CountNotification();
                          });
                        },
                        child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Bookings",
                                  style: CustomTheme.body3
                                      .copyWith(fontWeight: FontWeight.normal),
                                ),
                                count?.data?.appointmentCount == 0
                                    ? Visibility(
                                        visible: false,
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.red,
                                          child: Text(
                                            Numeral(int.parse(
                                                    "${count?.data?.appointmentCount}"))
                                                .value(),
                                            style: TextStyle(
                                                fontFamily:
                                                    CustomTheme.fontFamily,
                                                color: CustomTheme.white),
                                          ),
                                        ),
                                      )
                                    : Visibility(
                                        visible: true,
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.red,
                                          child: Text(
                                            "${count?.data?.appointmentCount ?? ""}",
                                            style: TextStyle(
                                                fontFamily:
                                                    CustomTheme.fontFamily,
                                                color: CustomTheme.white),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios_sharp),
                            ),
                            leading: Container(
                              height: Height / 22,
                              width: Width / 10,
                              decoration: BoxDecoration(
                                color: CustomTheme.primarycolor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Image.asset(
                                Images.calenderIcon,
                                scale: 3.5,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: Height / 35,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 7)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddBankCardPage()));
                        },
                        child: ListTile(
                          title: Text(
                            "Payment Method",
                            style: CustomTheme.body3
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios_sharp),
                          ),
                          leading: Container(
                            height: Height / 22,
                            width: Width / 10,
                            decoration: BoxDecoration(
                              color: CustomTheme.primarycolor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Image.asset(
                              Images.paymentMethodIcon,
                              scale: 3.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Height / 35,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 7)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentHistoryPage()));
                        },
                        child: ListTile(
                            title: Text(
                              "Payment History",
                              style: CustomTheme.body3
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios_sharp),
                            ),
                            leading: Container(
                              height: Height / 22,
                              width: Width / 10,
                              decoration: BoxDecoration(
                                color: CustomTheme.primarycolor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Image.asset(
                                Images.paymentHistoryIcon,
                                scale: 3.5,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: Height / 35,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 7)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CashBackPage()));
                        },
                        child: ListTile(
                            title: Text(
                              "Cashback",
                              style: CustomTheme.body3
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios_sharp),
                            ),
                            leading: Container(
                              height: Height / 22,
                              width: Width / 10,
                              decoration: BoxDecoration(
                                color: CustomTheme.primarycolor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Image.asset(
                                Images.cashBackIcon,
                                scale: 3.5,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: Height / 35,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 7)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Favourite()))
                              .then((value) async {
                            await CountNotification();
                          });
                        },
                        child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Favourite",
                                  style: CustomTheme.body3
                                      .copyWith(fontWeight: FontWeight.normal),
                                ),
                                count?.data?.favoriteCount == 0
                                    ? Visibility(
                                        visible: false,
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.red,
                                          child: Text(
                                            "${count?.data?.appointmentCount}",
                                            style: TextStyle(
                                                fontFamily:
                                                    CustomTheme.fontFamily,
                                                color: CustomTheme.white),
                                          ),
                                        ),
                                      )
                                    : Visibility(
                                        visible: true,
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.red,
                                          child: Text(
                                            "${count?.data?.favoriteCount ?? ""}",
                                            style: TextStyle(
                                                fontFamily:
                                                    CustomTheme.fontFamily,
                                                color: CustomTheme.white),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios_sharp),
                            ),
                            leading: Container(
                              height: Height / 22,
                              width: Width / 10,
                              decoration: BoxDecoration(
                                color: CustomTheme.primarycolor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Image.asset(
                                Images.favouriteIcon,
                                scale: 3.5,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: Height / 35,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 7)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Reffral()));
                        },
                        child: ListTile(
                            title: Text(
                              "Referral",
                              style: CustomTheme.body3
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios_sharp),
                            ),
                            leading: Container(
                              height: Height / 22,
                              width: Width / 10,
                              decoration: BoxDecoration(
                                color: CustomTheme.primarycolor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Image.asset(
                                Images.referralIcon,
                                scale: 3.5,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: Height / 35,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 7)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Security()));
                        },
                        child: ListTile(
                            title: Text(
                              "Security",
                              style: CustomTheme.body3
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios_sharp),
                            ),
                            leading: Container(
                              height: Height / 22,
                              width: Width / 10,
                              decoration: BoxDecoration(
                                color: CustomTheme.primarycolor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Image.asset(
                                Images.securityIcon,
                                scale: 3.5,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: Height / 35,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 7)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyAccount()));
                        },
                        child: ListTile(
                            title: Text(
                              "My Account",
                              style: CustomTheme.body3
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios_sharp),
                            ),
                            leading: Container(
                              height: Height / 22,
                              width: Width / 10,
                              decoration: BoxDecoration(
                                color: CustomTheme.primarycolor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Image.asset(
                                Images.myAccountIcon,
                                scale: 3.5,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: Height / 35,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 7)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HelpCenter()));
                        },
                        child: ListTile(
                            title: Text(
                              "Help Centre",
                              style: CustomTheme.body3
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios_sharp),
                            ),
                            leading: Container(
                              height: Height / 22,
                              width: Width / 10,
                              decoration: BoxDecoration(
                                color: CustomTheme.primarycolor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Image.asset(
                                Images.helpCentreIcon,
                                scale: 3.5,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      )),
      Provider.of<InternetConnectivityCheck>(context, listen: true).isNoInternet
          ? NoInterNetScreen()
          : SizedBox.shrink(),
    ]);
  }
}
