import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/bottom_navigation.dart';
import 'package:ipoint/Screen/menu_page.dart';
import 'package:ipoint/Screen/screen_loader.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/categories_list_model.dart';
import 'package:ipoint/model/profile_picture_model.dart';
import 'package:ipoint/model/service_like.dart';
import 'package:ipoint/model/service_model.dart';
import 'package:ipoint/model/user_data_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/model/vendor_model.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';

import 'all_service.dart';
import 'no_internet_screen.dart';

class NewServiceScreen extends StatefulWidget {
  const NewServiceScreen({Key? key}) : super(key: key);

  @override
  _NewServiceScreenState createState() => _NewServiceScreenState();
}

class _NewServiceScreenState extends State<NewServiceScreen> {
  int? index;
  String token = '';
  ServiceModel? serviceModel;
  UserModel? userModel;
  int? service_length;
  bool is_loading = false;
  String? proImage;
  File? image;
  ServiceLikeModel? serviceLikeModel;
  bool isSelected = false;
  var formatter = NumberFormat('#,##,000');
  bool isloader = false;
  CategoryList? categoryList;

  TextEditingController searchcontroller = TextEditingController();
  VendorDetailModel? vendorDetailModel;
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
    getServices();
    fetchUserdata(); //  likeDisLike(serviceModel.data.servicedata.length);
  }

  Future getServices() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formdata = FormData.fromMap({"search": searchcontroller.text});

      if (searchcontroller.text != "") {
        Response response = await ApiClient().dio.post(Constant.categoryList,
            options: Options(headers: {"Authorization": "Bearer $token"}),
            data: formdata);

        if (mounted) {
          setState(() {
            categoryList = CategoryList.fromJson(response.data);
          });
        }

        if (response.statusCode == 200) {
          print(response.data);
          //  return serviceModel;
        }
      } else {
        Response response = await ApiClient().dio.post(Constant.categoryList,
            options: Options(headers: {"Authorization": "Bearer $token"}),
            data: formdata);

        if (mounted) {
          setState(() {
            categoryList = CategoryList.fromJson(response.data);
          });
        }

        if (response.statusCode == 200) {
          print(response.data);
          //  return serviceModel;
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  Future likeDisLike(String id) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData = FormData.fromMap({"service_id": id});

      Response response = await ApiClient().dio.post(Constant.addServiceLike,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      serviceLikeModel = ServiceLikeModel.fromJson(response.data);

      if (response.statusCode == 200) {
        print(response.data);

        if (serviceLikeModel?.success == 1) {
          Fluttertoast.showToast(msg: "${serviceLikeModel?.message}");
        } else {
          Fluttertoast.showToast(msg: "${serviceLikeModel?.message}");
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
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
      print(e.message);
    }
  }

  Future searchservice() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData =
          FormData.fromMap({"search_service": searchcontroller.text});

      Response response = await ApiClient().dio.post(Constant.getService,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          data: formData);

      if (mounted) {
        setState(() {
          serviceModel = ServiceModel.fromJson(response.data);
        });
      }

      if (response.statusCode == 200) {
        print(response.data);
        return serviceModel;
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          SafeArea(
            child: Scaffold(
              //resizeToAvoidBottomInset: false,
              body: categoryList?.data == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: CustomTheme.primarycolor,
                      ),
                    )
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                            // overflow: TextOverflow.ellipsis,
                                            style: CustomTheme.body3.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),

                              // Spacer(
                              //   ),
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(minHeight: 50),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                //height: Height / 17,
                                width: Width / 3,
                                decoration: BoxDecoration(
                                  color: CustomTheme.primarycolor,
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: IntrinsicWidth(
                                        child: Container(
                                          alignment: Alignment.center,
                                          // color: Colors.green,
                                          child: Text(
                                              Numeral(double.parse(userModel!
                                                      .data!.ipointWallet
                                                      .toString()
                                                      .replaceAll(",", "")))
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
                                      // color: Colors.green,
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
                              //Spacer(),
                              CustomProfilePicture(
                                  // onTap: (){
                                  //   Navigator.push(context,MaterialPageRoute(builder: (context)=>MenuPage()));
                                  // },
                                  url: userModel?.data?.profile)
                            ],
                          ),
                          SizedBox(
                            height: Height / 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.grey.shade200,
                                  ),
                                  //height: 60,
                                  // width: Width / 1.6,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 20, top: 0),
                                    child: TextField(
                                      onChanged: (value) async {
                                        if (value == "") {
                                          await getServices();
                                        }
                                      },
                                      controller: searchcontroller,
                                      cursorColor: CustomTheme.primarycolor,
                                      decoration: InputDecoration(
                                        hintText: 'Search in showroom',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Width / 13,
                              ),
                              //  Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  if (searchcontroller.text != "") {
                                    setState(() {
                                      isloader = true;
                                    });
                                    FocusScope.of(context).unfocus();
                                    await getServices();
                                    setState(() {
                                      isloader = false;
                                    });
                                  }
                                },
                                child: Container(
                                  // height: 60,
                                  // width: 55,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: CustomTheme.yellow,
                                  ),
                                  child: Image.asset(
                                    Images.searchIcon,
                                    scale: 3,
                                  ),
                                ),
                              ),
                              //Spacer(),
                            ],
                          ),
                          SizedBox(height: Height / 30),
                          categoryList?.data?.length == 0 ||
                                  categoryList?.data == []
                              ? Center(
                                  child: Text(
                                    "No any Data",
                                    style: CustomTheme.body1,
                                  ),
                                )
                              : Expanded(
                                  child: isloader == false
                                      ? Visibility(
                                          visible: true,
                                          child: GridView.builder(
                                              itemCount: categoryList?.data !=
                                                      null
                                                  ? categoryList?.data?.length
                                                  : 0,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisSpacing: 2,
                                                      crossAxisCount: 4,
                                                      mainAxisSpacing: 10),
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                blurRadius: 0,
                                                                spreadRadius:
                                                                    1.0,
                                                                offset: Offset(
                                                                    4.0, 4.0),
                                                              ),
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade200,
                                                                  blurRadius:
                                                                      10,
                                                                  spreadRadius:
                                                                      5.0,
                                                                  offset:
                                                                      Offset(
                                                                          3.0,
                                                                          6.0))
                                                            ]),
                                                        child: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => AllService(
                                                                          categoryId: categoryList
                                                                              ?.data?[index]
                                                                              .categoryId)));
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child:
                                                                  CachedNetworkImage(
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                  Images
                                                                      .iPointsIcon,
                                                                  color:
                                                                      CustomTheme
                                                                          .grey,
                                                                ),
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Image.asset(
                                                                  Images
                                                                      .iPointsIcon,
                                                                  color:
                                                                      CustomTheme
                                                                          .grey,
                                                                ),
                                                                width: 30,
                                                                height: 30,
                                                                imageUrl:
                                                                    "${categoryList?.data?[index].image}",
                                                              ),
                                                            ))),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${categoryList?.data?[index].categoryName}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: CustomTheme.body3
                                                            .copyWith(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                        )
                                      : Visibility(
                                          visible: isloader,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: CustomTheme.primarycolor,
                                            ),
                                          )))
                        ],
                      ),
                    ),
            ),
          ),
          Provider.of<InternetConnectivityCheck>(context, listen: true)
                  .isNoInternet
              ? NoInterNetScreen()
              : SizedBox.shrink(),
          is_loading ? ScreenLoader() : SizedBox.shrink()
        ],
      ),
    );
  }
}

// class MenuItems {
//   String? name;
//   String? img;
//   MenuItems({required this.img, required this.name});
// }
class MenuItems {
  String? name;
  String? img;
  MenuItems({required this.img, required this.name});
}
