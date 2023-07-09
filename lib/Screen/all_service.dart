import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/menu_page.dart';
import 'package:ipoint/Screen/screen_loader.dart';
import 'package:ipoint/Screen/service_provider.dart';
import 'package:ipoint/Screen/vendor_detail.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/categories_list_model.dart';
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

import 'no_internet_screen.dart';

class AllService extends StatefulWidget {
  String? categoryId;
  int? status;
  List<ServiceData>? serviceData;

  String? categoryName;
  String? categoryImage;
  AllService(
      {Key? key,
      this.categoryId,
      this.serviceData,
      this.status,
      this.categoryName,
      this.categoryImage})
      : super(key: key);

  @override
  _AllServiceState createState() => _AllServiceState();
}

class _AllServiceState extends State<AllService> {
  String token = '';
  int? initialIndex = 0;
  AllCategory? dropdownvalue;
  List<AllCategory> allcategory = <AllCategory>[];
  bool isLoading = false;
  double radius = 0;

  bool? isCategorySelect;

  ServiceModel? serviceModel;
  UserModel? userModel;
  int? service_length;
  bool is_loading = false;
  String? proImage;
  File? image;
  int? indexData;
  ServiceLikeModel? serviceLikeModel;
  bool isSelected = false;

  double? lat;
  double? long;

  var formatter = NumberFormat('#,##,000');
  bool isloader = false;
  ValueNotifier<ServiceModel> notifylike =
      ValueNotifier<ServiceModel>(ServiceModel());

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
    getLocation();
    getModel();
    if (widget.status != 1) {
      getServices();
    }
    fetchUserData();
    //  likeDisLike(serviceModel.data.servicedata.length);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('in service enabled start');
      Geolocator.openLocationSettings().then((value) {
        print('open location setting : $value');
      });
      await Geolocator.requestPermission().then((value) {
        print('request permission : $value');
      });
      Fluttertoast.showToast(msg: 'Location Service are disabled');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location Service are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Fluttertoast.showToast(msg: 'Location Service are permanently denied');

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.whileInUse) {
      return await Geolocator.getCurrentPosition();
    }

    return await Geolocator.getCurrentPosition();
  }

  getLocation() {
    LatLng _latlng = LatLng(0, 0);

    _determinePosition().then((value) {
      print("${value.latitude} + hello");
      print('latlng on get location : $value');
      _latlng = LatLng(lat = value.latitude, long = value.longitude);

      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });
      // _getAddressFromLatLng(LatLng(value.latitude, value.longitude));
      // setState(() {
      //   newGoogleMapController!
      //       .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      // });
    });
    //       .whenComplete(() {
    //     print('lat long : $_latlng');
    //     Marker marker = Marker(
    //       markerId: MarkerId("test"),
    //       position: _latlng,
    //       icon: BitmapDescriptor.defaultMarkerWithHue(
    //         BitmapDescriptor.hueRed,
    //       ),
    //     );
    //
    //     _marker.add(marker);
    //     setState(() {});
    //   });
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
          //Fluttertoast.showToast(msg: "${serviceLikeModel?.message}");
        } else {
          //  Fluttertoast.showToast(msg: "${serviceLikeModel?.message}");
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  Future<ServiceModel?> getServices() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      if (searchcontroller.text != "") {
        FormData formData = FormData.fromMap({
          "search_service": searchcontroller.text,
          "category_id": widget.categoryId,
          // "rate": initialIndex == 0 ? "" : initialIndex,
          // "radius": radius == 0 ? "" : radius.toInt(),
          // "lat": lat,
          // "long": long,
        });

        Response response = await ApiClient().dio.post(Constant.getService,
            options: Options(headers: {"Authorization": "Bearer $token"}),
            data: formData);

        if (mounted) {
          setState(() {
            serviceModel = ServiceModel.fromJson(response.data);
            widget.serviceData = serviceModel?.data;
          });
        }
        notifylike.value = serviceModel!;

        if (response.statusCode == 200) {
          print(response.data);
          return serviceModel;
        }
      } else {
        FormData formData = FormData.fromMap({
          "rate": initialIndex == 0 ? "" : initialIndex,
          "radius": radius == 0 ? "" : radius.toInt(),
          "lat": lat,
          "long": long,
          "category_id": widget.categoryId
        });

        Response response = await ApiClient().dio.post(
              Constant.getService,
              data: formData,
              options: Options(headers: {"Authorization": "Bearer $token"}),
            );
        if (mounted) {
          setState(() {
            serviceModel = ServiceModel.fromJson(response.data);
            //
            // widget.serviceData = serviceModel?.data;
            widget.serviceData = serviceModel?.data;
          });
        }

        notifylike.value = serviceModel!;

        if (response.statusCode == 200) {
          print(response.data);

          return serviceModel;
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
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
        print("gautam gohil" + response.data.toString());
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  Future searchservice() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData = FormData.fromMap({
        "search_service": searchcontroller.text,
        "category_id": widget.categoryId,
      });

      Response response = await ApiClient().dio.post(Constant.getService,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          data: formData);

      if (mounted) {
        setState(() {
          serviceModel = ServiceModel.fromJson(response.data);
          widget.serviceData = serviceModel?.data;
          // if (widget.status == 1) {
          //   widget.serviceData = serviceModel?.data;
          // } else {
          //   serviceModel = ServiceModel.fromJson(response.data);
          // }
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
                resizeToAvoidBottomInset: false,
                body: widget.status != 1
                    ? serviceModel?.data == null
                        ? Center(
                            child: CircularProgressIndicator(
                              color: CustomTheme.primarycolor,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  //crossAxisAlignment: CrossAxisAlignment.,
                                  children: [
                                    Container(
                                      width: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Welcome',
                                              style: CustomTheme.body3.copyWith(
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          userModel?.data?.name == null
                                              ? Container(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.black,
                                                  ))
                                              : Text("${userModel?.data?.name}",
                                                  // "${Provider.of<UsernameProvider>(context, listen: false).userModel?.data?.name}",

                                                  maxLines: 2,
                                                  style: CustomTheme.body3
                                                      .copyWith(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    //Spacer(),
                                    Container(
                                      alignment: Alignment.center,
                                      constraints:
                                          BoxConstraints(minHeight: 50),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      //height: Height / 17,
                                      width: Width / 3,
                                      decoration: BoxDecoration(
                                        color: CustomTheme.primarycolor,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: IntrinsicWidth(
                                              child: Container(
                                                alignment: Alignment.center,
                                                // color: Colors.green,
                                                child: Text(
                                                    Numeral(double.parse(
                                                            "${userModel?.data?.ipointWallet ?? "0"}"))
                                                        .value(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: CustomTheme.body3
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
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
                                      width: 10,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: Height / 13,
                                      width: Width / 7,
                                      // color: Colors.lightBlueAccent,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            scale: 2,
                                            image: CachedNetworkImageProvider(
                                                "${serviceModel?.category?.catImage}"),
                                          ),
                                          color: Colors.white,
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 12),
                                      child: Text(
                                          "You are in " +
                                              "${serviceModel?.category?.categoryName}" +
                                              "!",
                                          style: CustomTheme.body1),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Height / 40,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.grey.shade200,
                                      ),
                                      //height: 60,
                                      width: Width / 1.6,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 0),
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
                                    Spacer(),
                                    Container(
                                        // height: 60,
                                        // width: 55,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: CustomTheme.yellow,
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            setState(() {
                                              isloader = true;
                                              FocusScope.of(context).unfocus();
                                            });
                                            await searchservice();
                                            setState(() {
                                              isloader = false;
                                            });
                                          },
                                          child: Image.asset(
                                            Images.searchIcon,
                                            scale: 3,
                                          ),
                                        )),
                                    Spacer(),
                                    Container(
                                        // height: 60,
                                        // width: 55,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: CustomTheme.grey,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    insetPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15),
                                                    child: StatefulBuilder(
                                                      builder:
                                                          (BuildContext context,
                                                              setState) {
                                                        return Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 5),
                                                          //height: 85,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        "Rating",
                                                                        style: CustomTheme
                                                                            .body1,
                                                                      ),
                                                                      StatefulBuilder(
                                                                        builder: (BuildContext
                                                                                context,
                                                                            void Function(void Function())
                                                                                setState) {
                                                                          return Container(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                ...List.generate(5, (index) {
                                                                                  return GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          initialIndex = index + 1;
                                                                                        });
                                                                                      },
                                                                                      child: index < initialIndex!
                                                                                          ? Icon(
                                                                                              Icons.star,
                                                                                              color: CustomTheme.primarycolor,
                                                                                            )
                                                                                          : Icon(
                                                                                              Icons.star_border,
                                                                                              color: CustomTheme.primarycolor,
                                                                                            ));
                                                                                }),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Text(
                                                                        "Radius to cover",
                                                                        style: CustomTheme
                                                                            .body1,
                                                                      ),
                                                                      Text("0"
                                                                          // value
                                                                          // .toString()
                                                                          // .split(
                                                                          //     ".")[0]
                                                                          ),
                                                                      Slider(
                                                                        activeColor:
                                                                            CustomTheme.black,
                                                                        inactiveColor:
                                                                            CustomTheme.black,
                                                                        thumbColor:
                                                                            CustomTheme.primarycolor,
                                                                        min: 0,
                                                                        max: 20,
                                                                        value: radius
                                                                            .toDouble(),
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            radius =
                                                                                value;
                                                                            print(radius);
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(radius
                                                                          .toString()
                                                                          .split(
                                                                              ".")[0]),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            // setState(() {
                                                                            //   isloader = true;
                                                                            // });

                                                                            Navigator.pop(context);
                                                                            await getServices().then((value) {
                                                                              initialIndex = 0;
                                                                              radius = 0;
                                                                            });
                                                                            // setState(() {
                                                                            //   isloader = false;
                                                                            // });
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "Go",
                                                                            style:
                                                                                CustomTheme.body1,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Image.asset(
                                            Images.ractangleIcon,
                                            scale: 3,
                                          ),
                                        ))
                                  ],
                                ),
                                SizedBox(height: Height / 30),
                                serviceModel?.data?.length == 0
                                    ? Center(
                                        heightFactor: 8,
                                        child: Text(
                                          "No service",
                                          style: TextStyle(
                                              fontFamily:
                                                  CustomTheme.fontFamily),
                                        ))
                                    : Expanded(
                                        // flex: 3,
                                        child: Scrollbar(
                                          child: isloader == false
                                              ? Visibility(
                                                  visible: true,
                                                  child: GridView.builder(
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    itemCount:
                                                        serviceModel != null
                                                            ? serviceModel
                                                                ?.data?.length
                                                            : 0,
                                                    shrinkWrap: true,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            mainAxisSpacing: 10,
                                                            crossAxisSpacing: 2,
                                                            crossAxisCount: 3),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        WongCheLaiCarCareScreen(
                                                                            //   index:,
                                                                            serviceid:
                                                                                serviceModel!.data![index].serviceId))).then(
                                                                (value) async {
                                                              await getServices();
                                                            });
                                                          },
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                "${serviceModel?.data?[index].image ?? ""}",
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    CustomTheme
                                                                        .grey,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18),
                                                              ),
                                                              child: Center(
                                                                child:
                                                                    Image.asset(
                                                                  Images
                                                                      .iPointsIcon,
                                                                  color: CustomTheme
                                                                      .darkGrey,
                                                                ),
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    CustomTheme
                                                                        .grey,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18),
                                                              ),
                                                              child: Center(
                                                                child:
                                                                    Image.asset(
                                                                  Images
                                                                      .iPointsIcon,
                                                                  color: CustomTheme
                                                                      .darkGrey,
                                                                ),
                                                              ),
                                                            ),
                                                            imageBuilder: (context,
                                                                imageProvider) {
                                                              return Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18),
                                                                  image: DecorationImage(
                                                                      fit: BoxFit.fill,
                                                                      image: CachedNetworkImageProvider(
                                                                        "${serviceModel?.data?[index].image}",
                                                                      )),
                                                                ),
                                                                child: Stack(
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image:
                                                                                AssetImage(Images.shadow),
                                                                            fit: BoxFit.fill),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8,
                                                                          vertical:
                                                                              5),
                                                                      child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            Container(
                                                                                padding: EdgeInsets.all(3),
                                                                                decoration: BoxDecoration(color: CustomTheme.white, borderRadius: BorderRadius.circular(10)),
                                                                                child:

                                                                                    // ValueListenableBuilder(
                                                                                    //   valueListenable:
                                                                                    //       notifylike,
                                                                                    //   builder: (BuildContext context,
                                                                                    //       value,
                                                                                    //       Widget? child) {
                                                                                    //     // notifylike = serviceModel as ValueNotifier<ServiceModel>;
                                                                                    //     return GestureDetector(
                                                                                    //         onTap: () async {
                                                                                    //           await likeDisLike(notifylike.value.data?[index].serviceId ?? "");
                                                                                    //
                                                                                    //           print(notifylike.value.data?[index].like);
                                                                                    //           if (notifylike.value.data?[index].like == 0) {
                                                                                    //             notifylike.value.data?[index].like = 1;
                                                                                    //           } else {
                                                                                    //             notifylike.value.data?[index].like = 0;
                                                                                    //           }
                                                                                    //           print(notifylike.value.data?[index].like);
                                                                                    //         },
                                                                                    //         child: Icon(Icons.favorite, size: 18, color: notifylike.value.data?[index].like == 1 ? Colors.red : Colors.black));
                                                                                    //   },
                                                                                    // )
                                                                                    GestureDetector(
                                                                                  onTap: () {
                                                                                    likeDisLike(serviceModel?.data?[index].serviceId ?? "");

                                                                                    // if (serviceModel?.data?[index].like == 0) {
                                                                                    //   serviceModel?.data?[index].like = 1;
                                                                                    // } else {
                                                                                    //   serviceModel?.data?[index].like = 0;
                                                                                    // }
                                                                                    setState(() {
                                                                                      if (serviceModel?.data?[index].like == 0) {
                                                                                        serviceModel?.data?[index].like = 1;
                                                                                      } else {
                                                                                        serviceModel?.data?[index].like = 0;
                                                                                      }
                                                                                    });
                                                                                  },
                                                                                  child: Icon(Icons.favorite, size: 18, color: serviceModel?.data?[index].like == 1 ? Colors.red : Colors.black),

                                                                                  //       child: Consumer<ServiceProvider>(
                                                                                  // builder: (BuildContext context, value, Widget? child) {
                                                                                  //   print(value);
                                                                                  //   print(value.serviceModel.data![index].like.toString() + "oooo");
                                                                                  //   return Icon(Icons.favorite, size: 18, color: value.serviceModel.data?[index].like == 1 ? Colors.red : Colors.black);
                                                                                  // },

                                                                                  // Consumer<ServiceProvider>(
                                                                                  //                       builder: (BuildContext context, value, Widget? child) {
                                                                                  //                         print(serviceModel?.data![index].like.toString());
                                                                                  //                         return                                                                                    },
                                                                                  //                     ),
                                                                                ))
                                                                          ]),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              '${serviceModel?.data?[index].serviceName}',
                                                                              style: CustomTheme.body1.copyWith(color: CustomTheme.white),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            constraints:
                                                                                BoxConstraints(minWidth: 30),
                                                                            // color: Colors.green,
                                                                            width:
                                                                                100,
                                                                          ),
                                                                          Text(
                                                                            "10km",
                                                                            style:
                                                                                CustomTheme.body1.copyWith(color: CustomTheme.white),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              ...List.generate(
                                                                                  serviceModel?.data?[index].rate == "" ? 0 : 1,
                                                                                  // serviceModel!.data![index].rateCount! >= 1 ? 1 : 0,

                                                                                  //int.parse(serviceModel?.data?[index].rate == "" ? "0" : serviceModel?.data?[index].rate ?? ''),
                                                                                  (index) => Row(children: [
                                                                                        Image.asset(
                                                                                          Images.stick,
                                                                                          color: CustomTheme.yellow,
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
                                                                                "${serviceModel?.data?[index].rate}",
                                                                                style: TextStyle(color: CustomTheme.yellow),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 4,
                                                                              ),
                                                                              serviceModel?.data?[index].rateCount == 0 || serviceModel?.data?[index].rate == ""
                                                                                  ? Text("")
                                                                                  : Text(
                                                                                      "(" + Numeral(int.parse(serviceModel?.data?[index].rateCount.toString() ?? "")).value() + ")",
                                                                                      style: TextStyle(color: CustomTheme.yellow),
                                                                                    ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ));
                                                    },
                                                  ),
                                                )
                                              : Visibility(
                                                  visible: isloader,
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    color: CustomTheme
                                                        .primarycolor,
                                                  )),
                                                ),
                                        ),
                                      ),
                              ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            child: userData
                                                        ?.data?.ipointWallet ==
                                                    null
                                                ? Text("")
                                                : Text(
                                                    "${userData?.data?.ipointWallet}",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: CustomTheme.body3
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: Height / 13,
                                  width: Width / 7,
                                  // color: Colors.lightBlueAccent,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        scale: 2,
                                        image: CachedNetworkImageProvider(""
                                            "${widget.categoryImage ?? ""}"),
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 2.9,
                                          spreadRadius: 1.0,
                                          offset: Offset(4.0, 4.0),
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 12),
                                  child: Text(
                                      "You are in " +
                                          "${widget.categoryName}" +
                                          "!",
                                      style: CustomTheme.body1),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Height / 40,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.grey.shade200,
                                  ),
                                  //height: 60,
                                  width: Width / 1.6,
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
                                Spacer(),
                                Container(
                                    // height: 60,
                                    // width: 55,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: CustomTheme.yellow,
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        setState(() {
                                          isloader = true;
                                          FocusScope.of(context).unfocus();
                                        });
                                        await searchservice();
                                        setState(() {
                                          isloader = false;
                                        });
                                      },
                                      child: Image.asset(
                                        Images.searchIcon,
                                        scale: 3,
                                      ),
                                    )),
                                Spacer(),
                                Container(
                                    // height: 60,
                                    // width: 55,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: CustomTheme.grey,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                insetPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: StatefulBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                          setState) {
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 5),
                                                      //height: 85,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Rating",
                                                                    style: CustomTheme
                                                                        .body1,
                                                                  ),
                                                                  StatefulBuilder(
                                                                    builder: (BuildContext
                                                                            context,
                                                                        void Function(void Function())
                                                                            setState) {
                                                                      return Container(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            ...List.generate(5,
                                                                                (index) {
                                                                              return GestureDetector(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      initialIndex = index + 1;
                                                                                    });
                                                                                  },
                                                                                  child: index < initialIndex!
                                                                                      ? Icon(
                                                                                          Icons.star,
                                                                                          color: CustomTheme.primarycolor,
                                                                                        )
                                                                                      : Icon(
                                                                                          Icons.star_border,
                                                                                          color: CustomTheme.primarycolor,
                                                                                        ));
                                                                            }),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    "Radius to cover",
                                                                    style: CustomTheme
                                                                        .body1,
                                                                  ),
                                                                  Text("0"
                                                                      // value
                                                                      // .toString()
                                                                      // .split(
                                                                      //     ".")[0]
                                                                      ),
                                                                  Slider(
                                                                    activeColor:
                                                                        CustomTheme
                                                                            .black,
                                                                    inactiveColor:
                                                                        CustomTheme
                                                                            .black,
                                                                    thumbColor:
                                                                        CustomTheme
                                                                            .primarycolor,
                                                                    min: 0,
                                                                    max: 20,
                                                                    value: radius
                                                                        .toDouble(),
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        radius =
                                                                            value;
                                                                        print(
                                                                            radius);
                                                                      });
                                                                    },
                                                                  ),
                                                                  Text(radius
                                                                      .toString()
                                                                      .split(
                                                                          ".")[0]),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        // setState(
                                                                        //     () {
                                                                        //   isloader =
                                                                        //       true;
                                                                        // });
                                                                        Navigator.pop(
                                                                            context);

                                                                        await getServices();

                                                                        // setState(
                                                                        //     () {
                                                                        //   isloader =
                                                                        //       false;
                                                                        // });
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "Go",
                                                                        style: CustomTheme
                                                                            .body1,
                                                                      ))
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            });
                                      },
                                      child: Image.asset(
                                        Images.ractangleIcon,
                                        scale: 3,
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(height: Height / 30),
                            widget.serviceData?.length == 0
                                ? Center(
                                    heightFactor: 8,
                                    child: Text(
                                      "No service",
                                      style: TextStyle(
                                          fontFamily: CustomTheme.fontFamily),
                                    ))
                                : Expanded(
                                    // flex: 3,
                                    child: Scrollbar(
                                      child: isloader == false
                                          ? Visibility(
                                              visible: true,
                                              child: GridView.builder(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemCount: widget.serviceData !=
                                                        null
                                                    ? widget.serviceData?.length
                                                    : 0,
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        mainAxisSpacing: 10,
                                                        crossAxisSpacing: 2,
                                                        crossAxisCount: 3),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    WongCheLaiCarCareScreen(
                                                                        //   index:,
                                                                        serviceid: widget
                                                                            .serviceData![
                                                                                index]
                                                                            .serviceId))).then(
                                                            (value) async {
                                                          await getServices();
                                                        });
                                                      },
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "${widget.serviceData?[index].image ?? ""}",
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: CustomTheme
                                                                .grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18),
                                                          ),
                                                          child: Center(
                                                            child: Image.asset(
                                                              Images
                                                                  .iPointsIcon,
                                                              color: CustomTheme
                                                                  .darkGrey,
                                                            ),
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: CustomTheme
                                                                .grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18),
                                                          ),
                                                          child: Center(
                                                            child: Image.asset(
                                                              Images
                                                                  .iPointsIcon,
                                                              color: CustomTheme
                                                                  .darkGrey,
                                                            ),
                                                          ),
                                                        ),
                                                        imageBuilder: (context,
                                                            imageProvider) {
                                                          return Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18),
                                                              image:
                                                                  DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image:
                                                                          CachedNetworkImageProvider(
                                                                        "${widget.serviceData?[index].image}",
                                                                      )),
                                                            ),
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage(Images
                                                                            .shadow),
                                                                        fit: BoxFit
                                                                            .fill),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              8,
                                                                          vertical:
                                                                              5),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.all(3),
                                                                          decoration: BoxDecoration(
                                                                              color: CustomTheme.white,
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          child:

                                                                              // ValueListenableBuilder(
                                                                              //   valueListenable:
                                                                              //       notifylike,
                                                                              //   builder: (BuildContext context,
                                                                              //       value,
                                                                              //       Widget? child) {
                                                                              //     // notifylike = serviceModel as ValueNotifier<ServiceModel>;
                                                                              //     return GestureDetector(
                                                                              //         onTap: () async {
                                                                              //           await likeDisLike(notifylike.value.data?[index].serviceId ?? "");
                                                                              //
                                                                              //           print(notifylike.value.data?[index].like);
                                                                              //           if (notifylike.value.data?[index].like == 0) {
                                                                              //             notifylike.value.data?[index].like = 1;
                                                                              //           } else {
                                                                              //             notifylike.value.data?[index].like = 0;
                                                                              //           }
                                                                              //           print(notifylike.value.data?[index].like);
                                                                              //         },
                                                                              //         child: Icon(Icons.favorite, size: 18, color: notifylike.value.data?[index].like == 1 ? Colors.red : Colors.black));
                                                                              //   },
                                                                              // )
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              likeDisLike(widget.serviceData?[index].serviceId ?? "");
                                                                              setState(() {
                                                                                if (widget.serviceData?[index].like == 0) {
                                                                                  widget.serviceData?[index].like = 1;
                                                                                } else {
                                                                                  widget.serviceData?[index].like = 0;
                                                                                }
                                                                              });
                                                                            },
                                                                            child: Icon(Icons.favorite,
                                                                                size: 18,
                                                                                color: widget.serviceData?[index].like == 1 ? Colors.red : Colors.black),
                                                                          ),
                                                                        )
                                                                      ]),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              8),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          '${widget.serviceData?[index].serviceName}',
                                                                          style: CustomTheme
                                                                              .body1
                                                                              .copyWith(color: CustomTheme.white),
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                        constraints:
                                                                            BoxConstraints(minWidth: 30),
                                                                        // color: Colors.green,
                                                                        width:
                                                                            100,
                                                                      ),
                                                                      // Text(
                                                                      //   "10km",
                                                                      //   style: CustomTheme
                                                                      //       .body1
                                                                      //       .copyWith(color: CustomTheme.white),
                                                                      // ),
                                                                      Row(
                                                                        children: [
                                                                          ...List.generate(
                                                                              widget.serviceData![index].rateCount! >= 1 ? 1 : 0,

                                                                              //int.parse(serviceModel?.data?[index].rate == "" ? "0" : serviceModel?.data?[index].rate ?? ''),
                                                                              (index) => Row(children: [
                                                                                    Image.asset(
                                                                                      Images.stick,
                                                                                      color: CustomTheme.yellow,
                                                                                      scale: 4,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 4,
                                                                                    )
                                                                                  ])),
                                                                          SizedBox(
                                                                            width:
                                                                                4,
                                                                          ),
                                                                          widget.serviceData?[index].rateCount == 0 || widget.serviceData?[index].rate == ""
                                                                              ? Text("")
                                                                              : Text(
                                                                                  "(" + Numeral(int.parse(widget.serviceData?[index].rateCount.toString() ?? "")).value() + ")",
                                                                                  style: TextStyle(color: CustomTheme.yellow),
                                                                                ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ));
                                                },
                                              ),
                                            )
                                          : Visibility(
                                              visible: isloader,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                color: CustomTheme.primarycolor,
                                              )),
                                            ),
                                    ),
                                  ),
                          ],
                        ),
                      )),
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
