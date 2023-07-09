import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipoint/Screen/bottom_navigation.dart';
import 'package:ipoint/Screen/menu_page.dart';
import 'package:ipoint/Screen/new_screen.dart';
import 'package:ipoint/Screen/service_of_the_month.dart';
import 'package:ipoint/Screen/vendor_detail.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/categories_list_model.dart';
import 'package:ipoint/model/home_page_model.dart';
import 'package:ipoint/model/homepage_banner_model.dart';
import 'package:ipoint/model/search_model.dart';
import 'package:ipoint/model/service_model.dart';
import 'package:ipoint/model/user_data_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'all_service.dart';
import 'no_internet_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  TextEditingController searchController = TextEditingController();

  double radius = 0;
  var _selectedIndex;
  HomePageBannerModel? homePageBannerModel;
  HomePage? homePage;
  ServiceModel? serviceModel;
  ValueNotifier isLoading = ValueNotifier<bool>(false);

  // var formatter = NumberFormat('#,##,000');
  // String wallet = formatter as String;
  bool? newbool = false;
  File? image;
  UserModel? userModel;
  UserData? userData;
  int? index;
  int? indexOne;
  CategoryList? categoryList;
  int? initialIndex = 0;
  double? lat;
  double? long;
  AllCategory? dropdownvalue;
  List data = [];
  List<AllCategory> allcategory = <AllCategory>[];
  bool? isCategorySelect;
  Search? search;

  // bool isLoading = false;

  List<MenuItems> _menuItem = [
    MenuItems(img: Images.showroomIcon, name: " Showroom"),
    MenuItems(img: Images.cafeIcon, name: "Cafe"),
    MenuItems(img: Images.LogisticIcon, name: "Logistic"),
    MenuItems(img: Images.performanceIcon, name: "Performance"),
    // MenuItems(img: "", name: "Car Service"),
  ];
  var item = ["sun", "mon", "tue"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getModel();
    bannerImage();
    //servicelist();
    allUserData();
    fetchCategoryList();
    getLocation();
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

  Future getServices(String categoryId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    try {
      if (searchController.text != "") {
        FormData data =
            FormData.fromMap({"search_service": searchController.text});

        Response response = await ApiClient().dio.post(
              Constant.getService,
              data: data,
              options: Options(headers: {"Authorization": "Bearer $token"}),
            );
        if (mounted) {
          setState(() {
            serviceModel = ServiceModel.fromJson(response.data);
          });
        }

        if (response.statusCode == 200) {
          print(response.data);

          if (serviceModel?.success == 1) {
            print(serviceModel?.data);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AllService(
                        categoryId: dropdownvalue?.categoryId,
                        serviceData: serviceModel?.data,
                        status: 1,
                        categoryName: serviceModel?.category?.categoryName,
                        categoryImage: serviceModel?.category?.catImage)));
            //     .then((value) {
            //   setState(() {
            //     initialIndex = 0;
            //     radius = 0;
            //     Navigator.pop(context);
            //   });
            // });
          }
        }
      } else {
        print(lat.toString() + "pppp");
        print(long.toString() + "kkkkk");
        FormData formData = FormData.fromMap({
          "category_id": categoryId,
          "rate": initialIndex == 0 ? "" : initialIndex,
          "radius": radius == 0 ? "" : radius.toInt(),
          "lat": lat,
          "long": long
        });

        Response response = await ApiClient().dio.post(
              Constant.getService,
              data: formData,
              options: Options(headers: {"Authorization": "Bearer $token"}),
            );
        if (mounted) {
          setState(() {
            serviceModel = ServiceModel.fromJson(response.data);
          });
        }

        if (response.statusCode == 200) {
          print(response.data);

          if (serviceModel?.success == 1) {
            print(serviceModel?.data);

            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllService(
                            categoryId: dropdownvalue?.categoryId,
                            serviceData: serviceModel?.data,
                            status: 1,
                            categoryName: serviceModel?.category?.categoryName,
                            categoryImage: serviceModel?.category?.catImage)))
                .then((value) {
              setState(() {
                initialIndex = 0;
                radius = 0;
                // Navigator.pop(context);
              });
            });
          }
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
    }
  }

  getLocation() {
    LatLng _latlng = LatLng(0, 0);

    _determinePosition().then((value) async {
      print("${value.latitude} + hello");
      print('latlng on get location : $value');
      _latlng = LatLng(lat = value.latitude, long = value.longitude);

      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });
      await servicelist();
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

  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());
    setState(() {
      userModel = UserModel.fromJson(jsondecode);
    });
  }

  void allUserData() {
    fetchUserData();
  }

  // void listofservice() {
  //   servicelist();
  // }

  Future bannerImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    try {
      Response response = await ApiClient().dio.post(Constant.bannerImage,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          homePageBannerModel = HomePageBannerModel.fromJson(response.data);
        });
      }

      if (response.statusCode == 200) {
        // print(response.data);
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
    // DioError catch (e) {
    //   print(e.message);
    // }
  }

  Future searchService() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    FormData data = FormData.fromMap({"search_service": searchController.text});

    try {
      Response response = await ApiClient().dio.post(Constant.searchService,
          data: data,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      search = Search.fromJson(response.data);

      if (response.statusCode == 200) {
        (response.data);

        if (search?.success == 1) {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewScreen(data: search?.data)))
              .then((value) {
            searchController.clear();
            isLoading.value = false;
          });
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  Future fetchCategoryList() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      Response response = await ApiClient().dio.post(
            Constant.categoryList,
            options: Options(headers: {"Authorization": "Bearer $token"}),
          );

      if (mounted) {
        setState(() {
          categoryList = CategoryList.fromJson(response.data);
          allcategory = categoryList!.data!;
        });
      }

      if (response.statusCode == 200) {
        print(response.data);
        //return serviceModel;
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  // Future<ServiceModel?> fetchFilterData() async {
  //   try {
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     String? token = preferences.getString('token');
  //
  //     if (searchcontroller.text != "") {
  //       FormData formData = FormData.fromMap({
  //         "search_service": searchcontroller.text,
  //         "category_id": widget.categoryId
  //       });
  //
  //       Response response = await ApiClient().dio.post(Constant.getService,
  //           options: Options(headers: {"Authorization": "Bearer $token"}),
  //           data: formData);
  //
  //       if (mounted) {
  //         setState(() {
  //           serviceModel = ServiceModel.fromJson(response.data);
  //         });
  //       }
  //
  //       if (response.statusCode == 200) {
  //         print(response.data);
  //         return serviceModel;
  //       }
  //     } else {
  //       FormData formData =
  //           FormData.fromMap({"category_id": widget.categoryId});
  //
  //       Response response = await ApiClient().dio.post(
  //             Constant.getService,
  //             data: formData,
  //             options: Options(headers: {"Authorization": "Bearer $token"}),
  //           );
  //       if (mounted) {
  //         setState(() {
  //           serviceModel = ServiceModel.fromJson(response.data);
  //         });
  //       }
  //
  //       if (response.statusCode == 200) {
  //         print(response.data);
  //         return serviceModel;
  //       }
  //     }
  //   } on DioError catch (e) {
  //     final errorMessage = DioExceptions.fromDioError(e).toString();
  //     CustomToast.toast(errorMessage);
  //   }
  // }

  Future servicelist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    try {
      FormData data = FormData.fromMap({"lat": lat, "long": long});

      Response response = await ApiClient().dio.post(Constant.homePageService,
          data: data,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          homePage = HomePage.fromJson(response.data);
        });
      }

      if (response.statusCode == 200) {
        print(homePage?.data?.peoplesFavourite?.toList());
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
              body: homePage?.data == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: CustomTheme.primarycolor,
                      ),
                    )
                  : RefreshIndicator(
                      color: CustomTheme.primarycolor,
                      onRefresh: () async {
                        await fetchUserData();
                      },
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                fontWeight: FontWeight.normal)),
                                        userModel?.data?.name == null
                                            ? Container(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.black,
                                                ))
                                            : Text('${userModel?.data?.name}',
                                                maxLines: 2,
                                                style: CustomTheme.body3
                                                    .copyWith(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                  CustomProfilePicture(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MenuPage()));
                                      },
                                      url: userModel?.data?.profile)
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Container(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          Row(
                                            children: [
                                              IntrinsicWidth(
                                                child: Wrap(
                                                  children: [
                                                    Container(
                                                      width: 190,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        // color: Colors.green,
                                                      ),
                                                      child: userData?.data
                                                                  ?.ipointWallet ==
                                                              null
                                                          ? Text("")
                                                          : Wrap(
                                                              children: [
                                                                Text(
                                                                  "${userData?.data?.ipointWallet}",
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          25,
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
                                                                          vertical:
                                                                              15),
                                                                  child: Text(
                                                                    'pts',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
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
                                            ],
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                        height: Height / 20,
                                        width: Width / 3.3,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: CustomTheme.yellow),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BottomNavigation(
                                                          indexOne: index = 1,
                                                        )),
                                                (route) => false);
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
                            ),
                            SizedBox(
                              height: Height / 40,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 4 + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == 4) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BottomNavigation(
                                                        index: index = 2,
                                                      )));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Text(
                                            "View All",
                                            style: CustomTheme.body3.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    }
                                    return Row(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .grey.shade300,
                                                          blurRadius: 0,
                                                          spreadRadius: 1.0,
                                                          offset:
                                                              Offset(4.0, 4.0),
                                                        ),
                                                        BoxShadow(
                                                            color: Colors
                                                                .grey.shade200,
                                                            blurRadius: 10,
                                                            spreadRadius: 5.0,
                                                            offset: Offset(
                                                                3.0, 6.0))
                                                      ]),
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => AllService(
                                                                    categoryId: categoryList
                                                                        ?.data?[
                                                                            index]
                                                                        .categoryId)));
                                                      },
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          child:
                                                              CachedNetworkImage(
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Image.asset(
                                                              Images
                                                                  .iPointsIcon,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                              Images
                                                                  .iPointsIcon,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            height: 22,
                                                            width: 22,
                                                            imageUrl:
                                                                "${categoryList?.data?[index].image}",
                                                          )
                                                          //Image.asset(
                                                          //   _menuItem[index]
                                                          //       .img
                                                          //       .toString(),
                                                          //   scale: 3,
                                                          // ),
                                                          ))),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${categoryList?.data?[index].categoryName ?? ""}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: CustomTheme.body3
                                                    .copyWith(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: Height / 30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.grey.shade200,
                                    ),
                                    width: 230,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 0),
                                      child: TextField(
                                        controller: searchController,
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
                                        onTap: () async {
                                          if (searchController.text != "") {
                                            FocusScope.of(context).unfocus();
                                            isLoading.value = true;
                                            await searchService();

                                            isLoading.value = false;
                                          }
                                        },
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
                                                        padding: EdgeInsets
                                                            .symmetric(
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
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "Category",
                                                                      style: CustomTheme
                                                                          .body1,
                                                                    ),
                                                                    Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              Width / 30),
                                                                      decoration: BoxDecoration(
                                                                          border: Border(
                                                                              top: BorderSide(color: CustomTheme.grey),
                                                                              bottom: BorderSide(color: CustomTheme.grey),
                                                                              right: BorderSide(color: CustomTheme.grey),
                                                                              left: BorderSide(color: CustomTheme.grey)),
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          // Text(
                                                                          //   "Select Category",
                                                                          //   style:
                                                                          //       CustomTheme.body1,
                                                                          // ),
                                                                          StatefulBuilder(
                                                                            builder:
                                                                                (BuildContext context, void Function(void Function()) setState) {
                                                                              return DropdownButtonHideUnderline(
                                                                                child: DropdownButton<AllCategory>(
                                                                                  value: dropdownvalue,
                                                                                  hint: Text(
                                                                                    "Select Category",
                                                                                    style: CustomTheme.body1.copyWith(color: CustomTheme.darkGrey),
                                                                                  ),
                                                                                  items: allcategory.map<DropdownMenuItem<AllCategory>>((AllCategory value) {
                                                                                    return DropdownMenuItem<AllCategory>(value: value, child: Text(value.categoryName.toString()));
                                                                                  }).toList(),
                                                                                  onChanged: (AllCategory? newValue) {
                                                                                    setState(() {
                                                                                      isCategorySelect = true;
                                                                                      dropdownvalue = newValue;
                                                                                      print(isCategorySelect);
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
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
                                                                          if (isCategorySelect ==
                                                                              true) {
                                                                            isLoading.value =
                                                                                true;
                                                                            Navigator.pop(context);

                                                                            await getServices("${dropdownvalue?.categoryId}");

                                                                            isLoading.value =
                                                                                false;
                                                                          } else {
                                                                            Fluttertoast.showToast(msg: "Please select any category");
                                                                          }
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
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: homePageBannerModel?.data == null
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: CustomTheme.primarycolor,
                                      ),
                                    )
                                  : CarouselSlider(
                                      items: [
                                        for (int i = 0;
                                            i <
                                                (homePageBannerModel?.data
                                                                ?.length !=
                                                            null ||
                                                        homePageBannerModel
                                                                ?.data !=
                                                            []
                                                    ? homePageBannerModel!
                                                        .data!.length
                                                    : 0);
                                            i++)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WongCheLaiCarCareScreen(
                                                                serviceid:
                                                                    homePageBannerModel
                                                                        ?.data?[
                                                                            i]
                                                                        .serviceId)));
                                              },
                                              child: CachedNetworkImage(
                                                imageUrl: homePageBannerModel
                                                        ?.data?[i].banner ??
                                                    "",
                                                placeholder: (context, url) =>
                                                    Container(
                                                  width: Width / 1,
                                                  decoration: BoxDecoration(
                                                      color: CustomTheme.grey),
                                                  child: Center(
                                                    child: Image.asset(
                                                      Images.iPointsIcon,
                                                      color:
                                                          CustomTheme.darkGrey,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  width: Width / 1,
                                                  decoration: BoxDecoration(
                                                      color: CustomTheme.grey),
                                                  child: Center(
                                                    child: Image.asset(
                                                      Images.iPointsIcon,
                                                      color:
                                                          CustomTheme.darkGrey,
                                                    ),
                                                  ),
                                                ),
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return Container(
                                                    width: Width / 1,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image:
                                                                imageProvider)),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: Width / 1,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  image: AssetImage(
                                                                      Images
                                                                          .rectangleShadow))),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 10),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Container(
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          "${homePageBannerModel?.data?[i].catImage}",
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      placeholder: (context,
                                                                              url) =>
                                                                          Image
                                                                              .asset(
                                                                        Images
                                                                            .iPointsIcon,
                                                                        color: CustomTheme
                                                                            .grey,
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Image
                                                                              .asset(
                                                                        Images
                                                                            .iPointsIcon,
                                                                        color: CustomTheme
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        color: CustomTheme
                                                                            .primarycolor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "${homePageBannerModel?.data?[i].serviceName}",
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: CustomTheme
                                                                        .body1
                                                                        .copyWith(
                                                                            color:
                                                                                CustomTheme.white),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      ...List.generate(
                                                                          homePageBannerModel?.data?[i].rate == "" ? 0 : 1
                                                                          //double.parse(homePageBannerModel?.data?[i].rate == "" ? "0" : homePageBannerModel?.data?[i].rate ?? '')

                                                                          ,
                                                                          (index) => Row(children: [
                                                                                Image.asset(
                                                                                  Images.stick,
                                                                                  color: CustomTheme.yellow,
                                                                                  scale: 3,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 4,
                                                                                )
                                                                              ])),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        "${homePageBannerModel?.data?[i].rate ?? ""}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                CustomTheme.yellow),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      homePageBannerModel?.data?[i].rateCount == 0 ||
                                                                              homePageBannerModel?.data?[i].rate ==
                                                                                  ""
                                                                          ? Text(
                                                                              "")
                                                                          : Text(
                                                                              "(" + Numeral(int.parse(homePageBannerModel?.data?[i].rateCount.toString() ?? "")).value() + ")",
                                                                              style: TextStyle(color: CustomTheme.yellow),
                                                                            ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              Text(
                                                                "Best Service for the month " +
                                                                    "${homePageBannerModel?.data?[i].currentMonth}",
                                                                style: CustomTheme.body1.copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    color: CustomTheme
                                                                        .yellow),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
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
                            ),
                            SizedBox(height: Height / 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...List.generate(
                                  homePageBannerModel?.data?.length ?? 0,
                                  (index) => Indicator(
                                      isActive: _selectedIndex == index
                                          ? true
                                          : false),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            homePage?.data?.servicesWithin10kmFromYou?.length !=
                                    0
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Text("Services within 10km from you",
                                        style: CustomTheme.body1
                                            .copyWith(fontSize: 14)),
                                  )
                                : SizedBox.shrink(),
                            homePage?.data?.servicesWithin10kmFromYou?.length !=
                                    0
                                ? CardsListOne()
                                : SizedBox.shrink(),
                            homePage?.data?.top20ServicesThisMonth?.length != 0
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Text("Top 20 services this Month",
                                        style: CustomTheme.body1
                                            .copyWith(fontSize: 14)),
                                  )
                                : SizedBox.shrink(),
                            homePage?.data?.top20ServicesThisMonth?.length != 0
                                ? CardsListtwo()
                                : SizedBox.shrink(),
                            homePage?.data?.peoplesFavourite?.length != 0
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Text("People's favourite",
                                        style: CustomTheme.body1
                                            .copyWith(fontSize: 14)),
                                  )
                                : SizedBox.shrink(),
                            homePage?.data?.peoplesFavourite?.length != 0
                                ? CardsListthree()
                                : SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          Provider.of<InternetConnectivityCheck>(context, listen: true)
                  .isNoInternet
              ? NoInterNetScreen()
              : SizedBox.shrink(),
          isLoading.value == true
              ? ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (BuildContext context, value, Widget? child) {
                    return Center(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.2),
                                blurRadius: 2.9,
                                spreadRadius: 1.0,
                                offset: Offset(4.0, 4.0),
                              ),
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 5.0,
                                spreadRadius: 2.0,
                                offset: Offset(6.0, 6.0),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        width: Width / 1.5,
                        height: Height / 14,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("Loading..."),
                              Transform.scale(
                                scale: .5,
                                child: CircularProgressIndicator(
                                  color: CustomTheme.primarycolor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }

  Widget CardsListOne() {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            //  color: Colors.green,
            height: Height / 6,
            child: Row(
              children: [
                Expanded(
                    child:
                        homePage?.data?.servicesWithin10kmFromYou?.length ==
                                    0 ||
                                homePage?.data?.servicesWithin10kmFromYou == []
                            ? Center(
                                child: Text("No Services",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: CustomTheme.fontFamily,
                                        fontSize: 14)),
                              )
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    homePage?.data?.servicesWithin10kmFromYou !=
                                            null
                                        ? homePage?.data
                                            ?.servicesWithin10kmFromYou?.length
                                        : 0,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WongCheLaiCarCareScreen(
                                                    serviceid: homePage
                                                        ?.data
                                                        ?.servicesWithin10kmFromYou?[
                                                            index]
                                                        .serviceId))).then(
                                        (value) async {
                                      await servicelist();
                                    }),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${homePage?.data?.servicesWithin10kmFromYou?[index].image}',
                                      errorWidget: (context, url, error) =>
                                          Container(),
                                      placeholder: (context, url) => Container(
                                        margin: EdgeInsets.all(5),
                                        width: Width / 3.87,
                                        decoration: BoxDecoration(
                                            color: CustomTheme.grey,
                                            borderRadius:
                                                BorderRadius.circular(18)),
                                        child: Center(
                                          child: Image.asset(
                                            Images.iPointsIcon,
                                            color: CustomTheme.darkGrey,
                                          ),
                                        ),
                                      ),
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                            margin: EdgeInsets.all(5),
                                            width: Width / 3.87,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: imageProvider)),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            Images.shadow),
                                                        fit: BoxFit.fill),
                                                  ),
                                                  //width: 50,
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 8),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                height: 20,
                                                                width: 20,
                                                                decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        scale:
                                                                            5,
                                                                        image: CachedNetworkImageProvider(
                                                                            "${homePage?.data?.servicesWithin10kmFromYou?[index].catImage}")),
                                                                    color: CustomTheme
                                                                        .primarycolor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                              )
                                                            ],
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                            constraints:
                                                                BoxConstraints(
                                                                    minWidth:
                                                                        30),
                                                            //width: 100,
                                                            child: Text(
                                                              "${homePage?.data?.servicesWithin10kmFromYou?[index].serviceName}",
                                                              style: CustomTheme.body1.copyWith(
                                                                  fontFamily:
                                                                      CustomTheme
                                                                          .fontFamily,
                                                                  color:
                                                                      CustomTheme
                                                                          .white),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Text(
                                                            "10 km",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    CustomTheme
                                                                        .fontFamily,
                                                                color:
                                                                    CustomTheme
                                                                        .white),
                                                          ),
                                                          Row(
                                                            children: [
                                                              ...List.generate(
                                                                  homePage?.data?.servicesWithin10kmFromYou?[index].rate ==
                                                                          ""
                                                                      ? 0
                                                                      : 1,
                                                                  //1,
                                                                  // int.parse(homePage
                                                                  //             ?.data
                                                                  //             ?.top20ServicesThisMonth?[
                                                                  //                 index]
                                                                  //             .rate ==
                                                                  //         ""
                                                                  //     ? "0"
                                                                  //     : homePage
                                                                  //             ?.data
                                                                  //             ?.top20ServicesThisMonth?[
                                                                  //                 index]
                                                                  //             .rate ??
                                                                  //         '')
                                                                  //
                                                                  // ,
                                                                  (index) =>
                                                                      Row(
                                                                          children: [
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
                                                                "${homePage?.data?.servicesWithin10kmFromYou?[index].rate}",
                                                                style: TextStyle(
                                                                    color: CustomTheme
                                                                        .yellow),
                                                              ),
                                                              homePage?.data?.servicesWithin10kmFromYou?[index].rateCount ==
                                                                          0 ||
                                                                      homePage
                                                                              ?.data
                                                                              ?.servicesWithin10kmFromYou?[index]
                                                                              .rate ==
                                                                          ""
                                                                  ? Text("")
                                                                  : Text(
                                                                      "(" +
                                                                          Numeral(int.parse(homePage?.data?.servicesWithin10kmFromYou?[index].rateCount.toString() ?? ""))
                                                                              .value() +
                                                                          ")",
                                                                      style: TextStyle(
                                                                          color:
                                                                              CustomTheme.yellow),
                                                                    ),
                                                            ],
                                                          ),
                                                        ]))
                                              ],
                                            ));
                                      },
                                    ),
                                  );
                                })),
                homePage!.data!.servicesWithin10kmFromYou!.length == 3
                    ? Visibility(
                        visible: true,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceOfThisMonth(listopentenkm: 1)));
                          },
                          child: Container(
                            child: Image.asset(
                              Images.showMoreImage,
                              scale: 3.5,
                            ),
                          ),
                        ),
                      )
                    : Visibility(
                        visible: false,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            child: Image.asset(
                              Images.showMoreImage,
                              scale: 3.5,
                            ),
                          ),
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget CardsListtwo() {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            //  color: Colors.green,
            height: Height / 6,
            child: Row(
              children: [
                Expanded(
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            homePage?.data?.top20ServicesThisMonth != null
                                ? homePage?.data?.top20ServicesThisMonth?.length
                                : 0,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        WongCheLaiCarCareScreen(
                                            serviceid: homePage
                                                ?.data
                                                ?.top20ServicesThisMonth?[index]
                                                .serviceId))).then(
                                (value) async {
                              await servicelist();
                            }),
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${homePage?.data?.top20ServicesThisMonth?[index].image}',
                              errorWidget: (context, url, error) => Container(),
                              placeholder: (context, url) => Container(
                                margin: EdgeInsets.all(5),
                                width: Width / 3.87,
                                decoration: BoxDecoration(
                                    color: CustomTheme.grey,
                                    borderRadius: BorderRadius.circular(18)),
                                child: Center(
                                  child: Image.asset(
                                    Images.iPointsIcon,
                                    color: CustomTheme.darkGrey,
                                  ),
                                ),
                              ),
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                    margin: EdgeInsets.all(5),
                                    width: Width / 3.87,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: imageProvider)),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    AssetImage(Images.shadow),
                                                fit: BoxFit.fill),
                                          ),
                                          //width: 50,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                scale: 5,
                                                                image: CachedNetworkImageProvider(
                                                                    "${homePage?.data?.top20ServicesThisMonth?[index].catImage}")),
                                                            color: CustomTheme
                                                                .primarycolor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    constraints: BoxConstraints(
                                                        minWidth: 30),
                                                    //width: 100,
                                                    child: Text(
                                                      "${homePage?.data?.top20ServicesThisMonth?[index].serviceName}",
                                                      style: CustomTheme.body1
                                                          .copyWith(
                                                              fontFamily:
                                                                  CustomTheme
                                                                      .fontFamily,
                                                              color: CustomTheme
                                                                  .white),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                    "10 km",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: CustomTheme
                                                            .fontFamily,
                                                        color:
                                                            CustomTheme.white),
                                                  ),
                                                  Row(
                                                    children: [
                                                      ...List.generate(
                                                          homePage
                                                                      ?.data
                                                                      ?.top20ServicesThisMonth?[
                                                                          index]
                                                                      .rate ==
                                                                  ""
                                                              ? 0
                                                              : 1,
                                                          //1,
                                                          // int.parse(homePage
                                                          //             ?.data
                                                          //             ?.top20ServicesThisMonth?[
                                                          //                 index]
                                                          //             .rate ==
                                                          //         ""
                                                          //     ? "0"
                                                          //     : homePage
                                                          //             ?.data
                                                          //             ?.top20ServicesThisMonth?[
                                                          //                 index]
                                                          //             .rate ??
                                                          //         '')
                                                          //
                                                          // ,
                                                          (index) =>
                                                              Row(children: [
                                                                Image.asset(
                                                                  Images.stick,
                                                                  color:
                                                                      CustomTheme
                                                                          .yellow,
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
                                                        "${homePage?.data?.top20ServicesThisMonth?[index].rate ?? ""}",
                                                        style: TextStyle(
                                                            color: CustomTheme
                                                                .yellow),
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      homePage
                                                                      ?.data
                                                                      ?.top20ServicesThisMonth?[
                                                                          index]
                                                                      .rateCount ==
                                                                  0 ||
                                                              homePage
                                                                      ?.data
                                                                      ?.top20ServicesThisMonth?[
                                                                          index]
                                                                      .rate ==
                                                                  ""
                                                          ? Text("")
                                                          : Text(
                                                              "(" +
                                                                  Numeral(int.parse(homePage
                                                                              ?.data
                                                                              ?.top20ServicesThisMonth?[index]
                                                                              .rateCount
                                                                              .toString() ??
                                                                          ""))
                                                                      .value() +
                                                                  ")",
                                                              style: TextStyle(
                                                                  color: CustomTheme
                                                                      .yellow),
                                                            ),
                                                    ],
                                                  ),
                                                ]))
                                      ],
                                    ));
                              },
                            ),
                          );
                        })),
                homePage!.data!.top20ServicesThisMonth!.length == 3
                    ? Visibility(
                        visible: true,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ServiceOfThisMonth(
                                        listopentoptwenty: 2)));
                          },
                          child: Container(
                            child: Image.asset(
                              Images.showMoreImage,
                              scale: 3.5,
                            ),
                          ),
                        ),
                      )
                    : Visibility(
                        visible: false,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            child: Image.asset(
                              Images.showMoreImage,
                              scale: 3.5,
                            ),
                          ),
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget CardsListthree() {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            //color: Colors.green,
            height: Height / 6,
            child: homePage?.data?.peoplesFavourite?.length == 0 ||
                    homePage?.data?.peoplesFavourite == []
                ? Center(
                    child: Text("No Services",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: CustomTheme.fontFamily,
                            fontSize: 14)),
                  )
                : Row(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  homePage?.data?.peoplesFavourite != null
                                      ? homePage?.data?.peoplesFavourite?.length
                                      : 0,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WongCheLaiCarCareScreen(
                                                        serviceid: homePage
                                                            ?.data
                                                            ?.peoplesFavourite?[
                                                                index]
                                                            .serviceId))).then(
                                            (value) async {
                                          await servicelist();
                                        }),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${homePage?.data?.peoplesFavourite?[index].image}",
                                      placeholder: (context, url) => Container(
                                        margin: EdgeInsets.all(5),
                                        width: Width / 3.87,
                                        decoration: BoxDecoration(
                                            color: CustomTheme.grey,
                                            borderRadius:
                                                BorderRadius.circular(18)),
                                        child: Center(
                                          child: Image.asset(
                                            Images.iPointsIcon,
                                            color: CustomTheme.darkGrey,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        margin: EdgeInsets.all(5),
                                        width: Width / 3.87,
                                        decoration: BoxDecoration(
                                            color: CustomTheme.grey,
                                            borderRadius:
                                                BorderRadius.circular(18)),
                                        child: Center(
                                          child: Image.asset(
                                            Images.iPointsIcon,
                                            color: CustomTheme.darkGrey,
                                          ),
                                        ),
                                      ),
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                            margin: EdgeInsets.all(5),
                                            width: Width / 3.87,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: imageProvider)),
                                            child: Stack(children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          Images.shadow),
                                                      fit: BoxFit.fill),
                                                ),
                                                //width: 50,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: CustomTheme
                                                                    .primarycolor,
                                                                image: DecorationImage(
                                                                    scale: 5,
                                                                    image: CachedNetworkImageProvider(
                                                                        "${homePage?.data?.peoplesFavourite?[index].catImage}"))),
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                        ]),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      constraints:
                                                          BoxConstraints(
                                                              minWidth: 30),
                                                      // width: 100,
                                                      child: Text(
                                                        "${homePage?.data?.peoplesFavourite?[index].serviceName}",
                                                        style: CustomTheme.body1
                                                            .copyWith(
                                                                fontFamily:
                                                                    CustomTheme
                                                                        .fontFamily,
                                                                color:
                                                                    CustomTheme
                                                                        .white),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Text(
                                                      "10 km",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              CustomTheme
                                                                  .fontFamily,
                                                          color: CustomTheme
                                                              .white),
                                                    ),
                                                    Row(
                                                      children: [
                                                        ...List.generate(
                                                            homePage
                                                                        ?.data
                                                                        ?.peoplesFavourite?[
                                                                            index]
                                                                        .rate ==
                                                                    ""
                                                                ? 0
                                                                : 1,

                                                            // 1
                                                            // int.parse(homePage
                                                            //             ?.data
                                                            //             ?.peoplesFavourite?[
                                                            //                 index]
                                                            //             .rate ==
                                                            //         ""
                                                            //     ? "0"
                                                            //     : homePage
                                                            //             ?.data
                                                            //             ?.peoplesFavourite?[
                                                            //                 index]
                                                            //             .rate ??
                                                            //         '')

                                                            (index) =>
                                                                Row(children: [
                                                                  Image.asset(
                                                                    Images
                                                                        .stick,
                                                                    color: CustomTheme
                                                                        .yellow,
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
                                                          "${homePage?.data?.peoplesFavourite?[index].rate ?? ""}",
                                                          style: TextStyle(
                                                              color: CustomTheme
                                                                  .yellow),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        homePage
                                                                        ?.data
                                                                        ?.peoplesFavourite?[
                                                                            index]
                                                                        .rateCount ==
                                                                    0 ||
                                                                homePage
                                                                        ?.data
                                                                        ?.peoplesFavourite?[
                                                                            index]
                                                                        .rate ==
                                                                    ""
                                                            ? Text("")
                                                            : Text(
                                                                "(" +
                                                                    Numeral(int.parse(homePage?.data?.peoplesFavourite?[index].rateCount.toString() ??
                                                                            ""))
                                                                        .value() +
                                                                    ")",
                                                                style: TextStyle(
                                                                    color: CustomTheme
                                                                        .yellow),
                                                              ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ]));
                                      },
                                    ));
                              })),
                      homePage!.data!.peoplesFavourite!.length == 3
                          ? Visibility(
                              visible: true,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ServiceOfThisMonth(
                                                listopenpeople: 3,
                                              )));
                                },
                                child: Container(
                                  child: Image.asset(
                                    Images.showMoreImage,
                                    scale: 3.5,
                                  ),
                                ),
                              ),
                            )
                          : Visibility(
                              visible: false,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  child: Image.asset(
                                    Images.showMoreImage,
                                    scale: 3.5,
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
          )
        ],
      ),
    );
  }
}

class MenuItems {
  String? name;
  String? img;
  MenuItems({required this.img, required this.name});
}

class ListOne {
  String? name;
  String? img;
  String? icon;
  String? rating;
  String? title;
  ListOne({
    required this.img,
    required this.name,
    required this.icon,
    required this.rating,
    required this.title,
  });
}

class Indicator extends StatelessWidget {
  final bool isActive;
  const Indicator({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      width: isActive ? 22.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? CustomTheme.primarycolor : CustomTheme.black,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
