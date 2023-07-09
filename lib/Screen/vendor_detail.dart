import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/model/user_data_model.dart';
import 'package:numeral/numeral.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Screen/copy_link_screen.dart';
import 'package:ipoint/Screen/selected_date_screen.dart';
import 'package:ipoint/Screen/services_page.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/service_like.dart';
import 'package:ipoint/model/service_rating_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/model/vendor_like_model.dart';
import 'package:ipoint/model/vendor_model.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import 'dart:io';

import 'home_screen.dart';
import 'menu_page.dart';
import 'no_internet_screen.dart';

class WongCheLaiCarCareScreen extends StatefulWidget {
  String? serviceid;
  // String? showroomservice;
  WongCheLaiCarCareScreen({Key? key, this.serviceid, index}) : super(key: key);

  @override
  _WongCheLaiCarCareScreenState createState() =>
      _WongCheLaiCarCareScreenState();
}

class _WongCheLaiCarCareScreenState extends State<WongCheLaiCarCareScreen> {
  var _selectedIndex;
  VendorDetailModel? vendorDetailModel;
  bool value = false;
  VendorLike? vendorLike;
  ServiceRatingModel? serviceRatingModel;
  ServiceLikeModel? serviceLikeModel;
  var formatter = NumberFormat('#,##,000');
  int? digit;
  UserData? userData;
  int intialindex = 0;
  bool israting = true;
  bool isSelected = false;
  bool is_loading = false;
  bool is_calling = false;
  String? pointInvice;
  bool isVisible = false;

  String? proImage;
  File? image;
  UserModel? userModel;

  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    setState(() {});
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());
    setState(() {});
    userModel = UserModel.fromJson(jsondecode);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getModel();
    getvendor();
    alluserData();
  }

  getvendor() {
    getVendorDetails();
  }

  alluserData() {
    fetchUserData();
  }

  Future likeDisLike(String id) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData = FormData.fromMap({"service_id": id});

      Response response = await ApiClient().dio.post(Constant.addServiceLike,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          serviceLikeModel = ServiceLikeModel.fromJson(response.data);
        });
      }

      if (response.statusCode == 200) {
        print(response.data);

        if (serviceLikeModel?.success == 1) {
          //Fluttertoast.showToast(msg: "${serviceLikeModel?.message}");
        } else {
          //Fluttertoast.showToast(msg: "${serviceLikeModel?.message}");
        }
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future<VendorDetailModel?> getVendorDetails() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData = FormData.fromMap({"service_id": widget.serviceid});

      Response response = await ApiClient().dio.post(Constant.vendorDetail,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          vendorDetailModel = VendorDetailModel.fromJson(response.data);
        });
      }

      String data = jsonEncode(vendorDetailModel?.toJson());
      setmodel(data);

      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future serviceRating() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData = FormData.fromMap(
          {"vendor_id": widget.serviceid, "rate": intialindex});

      Response response = await ApiClient().dio.post(Constant.serviceRating,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      setState(() {
        serviceRatingModel = ServiceRatingModel.fromJson(response.data);
      });

      if (response.statusCode == 200) {
        print(response.data);
        await getVendorDetails();
        if (response.statusCode == 1) {
          Fluttertoast.showToast(msg: "${serviceRatingModel?.message}");
        } else {
          Fluttertoast.showToast(msg: "${serviceRatingModel?.message}");
        }
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  setmodel(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("vendormodel", value);
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Stack(children: [
      SafeArea(
        child: Scaffold(
          body: vendorDetailModel == null
              ? Container(
                  child: Center(
                      child: CircularProgressIndicator(
                  color: CustomTheme.primarycolor,
                )))
              : SafeArea(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          SizedBox(
                            height: Height / 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.,
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
                                        : Text("${userModel?.data?.name}",
                                            maxLines: 2,
                                            style: CustomTheme.body3.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),

                              ////ipoint wallet balance
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(minHeight: 50),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                width: Width / 3,
                                decoration: BoxDecoration(
                                  color: CustomTheme.primarycolor,
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: IntrinsicWidth(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                              Numeral(double.parse(
                                                      "${userModel?.data?.ipointWallet ?? "0"}"))
                                                  .value(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: CustomTheme.body3.copyWith(
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 12),
                                      child: Text(
                                        " pts",
                                        style: CustomTheme.body1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),

                              CustomProfilePicture(
                                  // onTap: (){
                                  //   Navigator.push(context,MaterialPageRoute(builder: (context)=>MenuPage()));
                                  // },
                                  url: userModel?.data?.profile)
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              vendorDetailModel?.data?.vendorName == null
                                  ? Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: CustomTheme.primarycolor,
                                      ),
                                    )
                                  : Expanded(
                                      child: Text(
                                        "${vendorDetailModel?.data?.vendorName}",
                                        style: CustomTheme.body3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                              SizedBox(width: 30),
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 45,
                                      height: Height / 18,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              scale: 3,
                                              image: CachedNetworkImageProvider(
                                                  "${vendorDetailModel?.data?.catImage}")),
                                          color: CustomTheme.primarycolor,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              blurRadius: 2.9,
                                              spreadRadius: 1.0,
                                              offset: Offset(4.0, 4.0),
                                            ),
                                          ]),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: Height / 22,
                                      width: Width / 11,
                                      decoration: BoxDecoration(
                                          color: CustomTheme.grey,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: GestureDetector(
                                        onTap: () {
                                          likeDisLike("${widget.serviceid}");
                                          setState(() {
                                            if (vendorDetailModel?.data?.like ==
                                                0) {
                                              vendorDetailModel?.data?.like = 1;
                                            } else {
                                              vendorDetailModel?.data?.like = 0;
                                            }
                                          });
                                        },
                                        child: Icon(Icons.favorite,
                                            size: 24,
                                            color:
                                                vendorDetailModel?.data?.like ==
                                                        1
                                                    ? Colors.red
                                                    : Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                                text: '10km',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline),
                                children: [
                                  TextSpan(
                                    text: 'away',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline),
                                  ),
                                ]),
                          ),
                          SizedBox(height: Height / 30),
                          CarouselSlider(
                            items: [
                              for (int i = 0;
                                  i <
                                      (vendorDetailModel != null
                                          ? vendorDetailModel!
                                              .data!.banners!.length
                                          : 0);
                                  i++)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${vendorDetailModel?.data?.banners?[i].image}',
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: Width / 1,
                                      color: CustomTheme.grey,
                                      child: Center(
                                        child: Image.asset(
                                          Images.iPointsIcon,
                                          color: CustomTheme.darkGrey,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(
                                      width: Width / 1,
                                      color: CustomTheme.grey,
                                      child: Center(
                                        child: Image.asset(
                                          Images.iPointsIcon,
                                          color: CustomTheme.darkGrey,
                                        ),
                                      ),
                                    ),
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        width: Width / 1,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: imageProvider)),
                                      );
                                    },
                                  ),
                                ),
                            ],
                            options: CarouselOptions(
                              onPageChanged: (index, _) {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              autoPlay: true,
                              viewportFraction: 1,
                              aspectRatio: 2.7,
                              enlargeCenterPage: true,
                              reverse: false,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                          SizedBox(height: Height / 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(
                                vendorDetailModel?.data?.banners?.length ?? 0,
                                (index) => Indicator(
                                    isActive:
                                        _selectedIndex == index ? true : false),
                              )
                            ],
                          ),
                          SizedBox(height: Height / 30),
                          Text("Description", style: CustomTheme.body2),
                          SizedBox(height: Height / 100),
                          vendorDetailModel?.data?.description == null
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: CustomTheme.primarycolor,
                                  ),
                                )
                              : Container(
                                  child: Text(
                                    "${vendorDetailModel?.data?.description}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: CustomTheme.fontFamily),
                                  ),
                                ),
                          SizedBox(height: 24),
                          Text("The Services", style: CustomTheme.body2),
                          SizedBox(height: 12),
                          Wrap(
                            runSpacing: 13,
                            spacing: 10,
                            children: [
                              ...List.generate(
                                  vendorDetailModel?.data != null
                                      ? vendorDetailModel!
                                          .data!.services!.length
                                      : 0, (index) {
                                return IntrinsicWidth(
                                  child: Wrap(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 5),
                                        constraints:
                                            BoxConstraints(minHeight: 40),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color:
                                                CustomTheme.primarylightcolor),
                                        child: Wrap(
                                          children: [
                                            Text(
                                              "${vendorDetailModel?.data?.services?[index].serviceName}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: CustomTheme.body7
                                                  .copyWith(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                          SizedBox(height: Height / 30),
                          // Visibility(
                          //   visible: value,
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.end,
                          //     mainAxisAlignment: MainAxisAlignment.end,
                          //     children: [
                          //       Container(
                          //         height: Height / 9.5,
                          //         width: Width / 1.7,
                          //         margin: EdgeInsets.only(right: 30),
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(16),
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.grey.shade300,
                          //               blurRadius: 2.5,
                          //               spreadRadius: 0.0,
                          //               offset: Offset(2.0, 4.0),
                          //             ),
                          //             BoxShadow(
                          //                 color: Colors.grey.shade200,
                          //                 blurRadius: 5.0,
                          //                 spreadRadius: 2.0,
                          //                 offset: Offset(2.0, 5.0))
                          //           ],
                          //           color: CustomTheme.primarycolor,
                          //         ),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.center,
                          //           children: [
                          //             GestureDetector(
                          //                 onTap: () {
                          //                   Navigator.of(context).push(
                          //                       PageRouteBuilder(
                          //                           opaque: false,
                          //                           fullscreenDialog: true,
                          //                           pageBuilder:
                          //                               (BuildContext context,
                          //                                       _, __) =>
                          //                                   CopyLinkScreen()));
                          //                 },
                          //                 child: Image.asset(
                          //                   Images.personImag,
                          //                   scale: 2,
                          //                 )),
                          //             Image.asset(
                          //               Images.whatsappImg,
                          //               scale: 2,
                          //             ),
                          //             Image.asset(
                          //               Images.facebookImg,
                          //               scale: 2,
                          //             ),
                          //             Image.asset(
                          //               Images.linkedinImg,
                          //               scale: 2,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                height: Height / 15,
                                width: Width / 1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: CustomTheme.grey),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          if (vendorDetailModel?.data?.rate ==
                                                  "" ||
                                              vendorDetailModel?.data?.rate ==
                                                  null) {
                                            rating(context);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Rating already given");
                                          }
                                        },
                                        child: vendorDetailModel?.data?.rate !=
                                                ""
                                            ? Container(
                                                //color: Colors.green,
                                                child: Row(
                                                  children: [
                                                    ...List.generate(
                                                        vendorDetailModel!.data!
                                                                    .rateCount! >=
                                                                1
                                                            ? 1
                                                            : 0,
                                                        // int.parse(
                                                        //     vendorDetailModel
                                                        //             ?.data
                                                        //             ?.rate ??
                                                        //         ''),
                                                        (index) =>
                                                            Row(children: [
                                                              Image.asset(
                                                                Images.stick,
                                                                color: Colors
                                                                    .black,
                                                                scale: 4,
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              )
                                                            ])),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      "(" +
                                                          Numeral(int.parse(
                                                                  vendorDetailModel
                                                                          ?.data
                                                                          ?.rateCount
                                                                          .toString() ??
                                                                      ''))
                                                              .value() +
                                                          ")",
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Text(
                                                "Rating",
                                                style: TextStyle(
                                                    fontFamily:
                                                        CustomTheme.fontFamily,
                                                    fontSize: 14),
                                              )),
                                    VerticalDivider(
                                      color: CustomTheme.black,
                                    ),
                                    Text(
                                        Numeral(int.parse(vendorDetailModel
                                                    ?.data?.visitsCount
                                                    .toString() ??
                                                ""))
                                            .value(),
                                        style: CustomTheme.body3),
                                    Text("visits",
                                        style: CustomTheme.body3.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal)),
                                    VerticalDivider(
                                      color: CustomTheme.black,
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          await Share.share(
                                              "Referral code:${userModel?.data?.refCode}");
                                        },
                                        child: Icon(Icons.share)),
                                    // Icon(Icons.mode_comment),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: Width / 1.8,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: CustomTheme.yellow),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: RichText(
                                                text: TextSpan(
                                                  text: "price range: ",
                                                  style: CustomTheme.body2,
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            "${vendorDetailModel?.data?.priceRange}",
                                                        style:
                                                            CustomTheme.body3),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    //Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            PageRouteBuilder(
                                                opaque: false,
                                                fullscreenDialog: true,
                                                pageBuilder: (BuildContext
                                                            context,
                                                        _,
                                                        __) =>
                                                    SelectedDateScreen(
                                                        vendormodel:
                                                            vendorDetailModel
                                                                ?.data,
                                                        serviceid:
                                                            vendorDetailModel
                                                                ?.data
                                                                ?.services,
                                                        venderid:
                                                            vendorDetailModel
                                                                ?.data
                                                                ?.vendorId)));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        height: Height / 14,
                                        width: Width / 3,
                                        decoration: BoxDecoration(
                                            color: CustomTheme.primarycolor,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Book Now",
                                              style: CustomTheme.body5,
                                            ),
                                            // Spacer(),
                                            Image.asset(
                                              Images.calenderIcon,
                                              scale: 3,
                                            ),
                                          ],
                                        ),
                                      ),
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
        ),
      ),
      Provider.of<InternetConnectivityCheck>(context, listen: true).isNoInternet
          ? NoInterNetScreen()
          : SizedBox.shrink(),
      is_loading ? LoaderLayoutWidget() : SizedBox.shrink()
    ]);
  }

  rating(BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                width: 150,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Give Your Rating",
                      style: TextStyle(fontFamily: CustomTheme.fontFamily),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...List.generate(
                            5,
                            (index) => Row(children: [
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          intialindex = index + 1;
                                        });
                                      },
                                      child: index < intialindex
                                          ? Image.asset(
                                              Images.stick,
                                              color: CustomTheme.yellow,
                                              scale: 1.2,
                                            )
                                          : Image.asset(
                                              Images.stick,
                                              color: CustomTheme.grey,
                                              scale: 1.2,
                                            )),
                                  SizedBox(
                                    width: 18,
                                  )
                                ])

                            // IconButton(
                            //   icon: index < intialindex
                            //       ? Icon(
                            //           Icons.star,
                            //           size: 27,
                            //           color: CustomTheme.primarycolor,
                            //         )
                            //       : Icon(
                            //           Icons.star_border,
                            //           size: 27,
                            //           color: CustomTheme.primarycolor,
                            //         ),
                            //   onPressed: () {
                            //     setState(() {
                            //       intialindex = index + 1;
                            //     });
                            //   },
                            // )
                            )
                      ],
                    ),
                    SizedBox(
                        width: 100,
                        child: TextButton(
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                    CustomTheme.black),
                                backgroundColor: MaterialStateProperty.all(
                                    CustomTheme.primarycolor),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            onPressed: () async {
                              setState(() {
                                isVisible = false;
                              });
                              await serviceRating();
                              setState(() {
                                isVisible = true;
                              });

                              //  isVisible = true;
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Submit",
                              style:
                                  TextStyle(fontFamily: CustomTheme.fontFamily),
                            ))),
                  ],
                ));
          });
        });
  }
}
