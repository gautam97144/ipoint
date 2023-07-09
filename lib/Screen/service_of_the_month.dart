import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipoint/Screen/vendor_detail.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/like_list_model.dart';
import 'package:ipoint/model/peoples_favrioute_service_model.dart';
import 'package:ipoint/model/service_like.dart';
import 'package:ipoint/model/service_model.dart';
import 'package:ipoint/model/service_of_tenkm_model.dart';
import 'package:ipoint/model/service_of_top_twenty_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'no_internet_screen.dart';

class ServiceOfThisMonth extends StatefulWidget {
  int? listopentenkm;
  int? listopentoptwenty;
  int? listopenpeople;
  ServiceOfThisMonth(
      {Key? key,
      this.listopentenkm,
      this.listopenpeople,
      this.listopentoptwenty})
      : super(key: key);

  @override
  _ServiceOfThisMonthState createState() => _ServiceOfThisMonthState();
}

class _ServiceOfThisMonthState extends State<ServiceOfThisMonth> {
  int selected = 0;
  bool? value = false;
  bool isvisible = false;
  ServiceSection? serviceSection;
  ServiceTenKm? serviceTenKm;
  PeopleFavourite? peopleFavourite;
  UserModel? userModel;
  File? image;
  double? lat;
  double? long;
  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
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

    if (widget.listopentoptwenty == 2) {
      serviceSectionList(2);
    }
    if (widget.listopenpeople == 3) {
      serviceSectionList(3);
    }

    if (widget.listopentenkm == 1) {
      getLocation();
    }

    print(widget.listopentenkm);
  }

  void sectiontwo() {}

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

    _determinePosition().then((value) async {
      print("${value.latitude} + hello");
      print('latlng on get location : $value');
      _latlng = LatLng(lat = value.latitude, long = value.longitude);
      print(lat.toString() + "uuuuu");
      print(long.toString() + "ttttt");

      // setState(() {
      //   lat = value.latitude;
      //   long = value.latitude;
      // });

      await serviceSectionList(1);
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

  Future serviceSectionList(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    FormData formData = FormData.fromMap({
      "section": id,
      "lat": id == 2 || id == 3 ? "" : lat,
      "long": id == 2 || id == 3 ? "" : long
    });
    try {
      print(lat.toString() + "ooooo");
      print(long.toString() + "mmmmmm");

      Response response = await ApiClient().dio.post(
          Constant.homePageServiceSection,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          data: formData);

      if (mounted) {
        if (id == 2) {
          setState(() {
            serviceSection = ServiceSection.fromJson(response.data);
          });
        }

        if (mounted) {
          if (id == 1) {
            print(id);
            setState(() {
              serviceTenKm = ServiceTenKm.fromJson(response.data);
            });
          }
        }
      }
      if (mounted) {
        if (id == 3) {
          setState(() {
            peopleFavourite = PeopleFavourite.fromJson(response.data);
          });
        }
      }

      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            body: serviceSection?.data == null &&
                    peopleFavourite?.data == null &&
                    serviceTenKm?.data == null
                ? Center(
                    child: CircularProgressIndicator(
                    color: CustomTheme.primarycolor,
                  ))
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(
                          height: Height / 50,
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
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             MenuPage()));
                                },
                                url: userModel?.data?.profile)
                          ],
                        ),
                        SizedBox(height: Height / 50),
                        Text('List of Service', style: CustomTheme.title),
                        Container(height: Height / 20, child: Text("")),
                        SizedBox(
                          height: 20,
                        ),
                        listOfData()
                        // widget.listopentoptwenty == 2
                        //     ? Expanded(
                        //         child: Scrollbar(
                        //           child: serviceSection
                        //                       ?.data
                        //                       ?.top20ServicesThisMonth
                        //                       ?.length ==
                        //                   0
                        //               ? Center(
                        //                   child: Text(
                        //                     "No more service",
                        //                     style: CustomTheme.body1,
                        //                   ),
                        //                 )
                        //               : GridView.builder(
                        //                   physics: BouncingScrollPhysics(),
                        //                   itemCount:
                        //                       serviceSection?.data != null
                        //                           ? serviceSection
                        //                               ?.data
                        //                               ?.top20ServicesThisMonth
                        //                               ?.length
                        //                           : 0,
                        //                   shrinkWrap: true,
                        //                   gridDelegate:
                        //                       SliverGridDelegateWithFixedCrossAxisCount(
                        //                           mainAxisSpacing: 10,
                        //                           crossAxisSpacing: 2,
                        //                           crossAxisCount: 3),
                        //                   itemBuilder: (BuildContext context,
                        //                       int index) {
                        //                     return GestureDetector(
                        //                         onTap: () => Navigator.push(
                        //                                 context,
                        //                                 MaterialPageRoute(
                        //                                     builder: (context) =>
                        //                                         WongCheLaiCarCareScreen(
                        //                                             serviceid: serviceSection
                        //                                                 ?.data
                        //                                                 ?.top20ServicesThisMonth?[
                        //                                                     index]
                        //                                                 .serviceId))).then(
                        //                                 (value) async {
                        //                               await serviceSectionList(
                        //                                   2);
                        //                             }),
                        //                         child: CachedNetworkImage(
                        //                           placeholder: (context, url) =>
                        //                               Container(
                        //                             margin: EdgeInsets.only(
                        //                                 right: 10),
                        //                             decoration: BoxDecoration(
                        //                               color: CustomTheme.grey,
                        //                               borderRadius:
                        //                                   BorderRadius.circular(
                        //                                       18),
                        //                             ),
                        //                             child: Center(
                        //                               child: Image.asset(
                        //                                 Images.iPointsIcon,
                        //                                 color: CustomTheme
                        //                                     .darkGrey,
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           errorWidget:
                        //                               (context, url, error) =>
                        //                                   Container(
                        //                             margin: EdgeInsets.only(
                        //                                 right: 10),
                        //                             decoration: BoxDecoration(
                        //                               color: CustomTheme.grey,
                        //                               borderRadius:
                        //                                   BorderRadius.circular(
                        //                                       18),
                        //                             ),
                        //                             child: Center(
                        //                               child: Image.asset(
                        //                                 Images.iPointsIcon,
                        //                                 color: CustomTheme
                        //                                     .darkGrey,
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           imageUrl:
                        //                               '${serviceSection?.data?.top20ServicesThisMonth?[index].image}',
                        //                           imageBuilder:
                        //                               (context, imageProvider) {
                        //                             return Container(
                        //                               margin: EdgeInsets.only(
                        //                                   right: 10),
                        //                               decoration: BoxDecoration(
                        //                                 borderRadius:
                        //                                     BorderRadius
                        //                                         .circular(18),
                        //                                 image: DecorationImage(
                        //                                     fit: BoxFit.fill,
                        //                                     image:
                        //                                         imageProvider),
                        //                               ),
                        //                               child: Stack(
                        //                                 children: [
                        //                                   Container(
                        //                                     decoration:
                        //                                         BoxDecoration(
                        //                                       image: DecorationImage(
                        //                                           image: AssetImage(
                        //                                               Images
                        //                                                   .shadow),
                        //                                           fit: BoxFit
                        //                                               .fill),
                        //                                     ),
                        //                                   ),
                        //                                   Padding(
                        //                                     padding: EdgeInsets
                        //                                         .symmetric(
                        //                                             horizontal:
                        //                                                 8),
                        //                                     child: Column(
                        //                                       mainAxisAlignment:
                        //                                           MainAxisAlignment
                        //                                               .center,
                        //                                       crossAxisAlignment:
                        //                                           CrossAxisAlignment
                        //                                               .start,
                        //                                       children: [
                        //                                         Container(
                        //                                           child: Text(
                        //                                             '${serviceSection?.data?.top20ServicesThisMonth?[index].serviceName}',
                        //                                             style: CustomTheme
                        //                                                 .body1
                        //                                                 .copyWith(
                        //                                                     color:
                        //                                                         CustomTheme.white),
                        //                                             maxLines: 2,
                        //                                             overflow:
                        //                                                 TextOverflow
                        //                                                     .ellipsis,
                        //                                           ),
                        //                                         ),
                        //                                         Text(
                        //                                           "10km",
                        //                                           style: CustomTheme
                        //                                               .body1
                        //                                               .copyWith(
                        //                                                   color:
                        //                                                       CustomTheme.white),
                        //                                         ),
                        //                                         Row(
                        //                                           children: [
                        //                                             ...List.generate(
                        //                                                 serviceSection?.data?.top20ServicesThisMonth?[index].rate == "" ? 0 : 1,
                        //                                                 // serviceSection!
                        //                                                 //             .data!
                        //                                                 //             .top20ServicesThisMonth![
                        //                                                 //                 index]
                        //                                                 //             .rateCount! >=
                        //                                                 //         1
                        //                                                 //     ? 1
                        //                                                 //     : 0,
                        //
                        //                                                 // int.parse(serviceSection
                        //                                                 //           ?.data
                        //                                                 //             ?.top20ServicesThisMonth?[
                        //                                                 //                 index]
                        //                                                 //             .rate ==
                        //                                                 //         ""
                        //                                                 //     ? "0"
                        //                                                 //     : serviceSection
                        //                                                 //             ?.data
                        //                                                 //             ?.top20ServicesThisMonth?[
                        //                                                 //                 index]
                        //                                                 //             .rate ??
                        //                                                 //         ''),
                        //                                                 (index) => Row(children: [
                        //                                                       Image.asset(
                        //                                                         Images.stick,
                        //                                                         color: CustomTheme.yellow,
                        //                                                         scale: 3,
                        //                                                       ),
                        //                                                       SizedBox(
                        //                                                         width: 4,
                        //                                                       )
                        //                                                     ])),
                        //                                             SizedBox(
                        //                                               width: 4,
                        //                                             ),
                        //                                             Text(
                        //                                               "${serviceSection?.data?.top20ServicesThisMonth?[index].rate ?? ""}",
                        //                                               style: TextStyle(
                        //                                                   color:
                        //                                                       CustomTheme.yellow),
                        //                                             ),
                        //                                             SizedBox(
                        //                                               width: 4,
                        //                                             ),
                        //                                             serviceSection?.data?.top20ServicesThisMonth?[index].rateCount ==
                        //                                                         0 ||
                        //                                                     serviceSection?.data?.top20ServicesThisMonth?[index].rate ==
                        //                                                         ""
                        //                                                 ? Text(
                        //                                                     "")
                        //                                                 : Text(
                        //                                                     "(" +
                        //                                                         Numeral(int.parse(serviceSection?.data?.top20ServicesThisMonth?[index].rateCount.toString() ?? "")).value() +
                        //                                                         ")",
                        //                                                     style:
                        //                                                         TextStyle(color: CustomTheme.yellow),
                        //                                                   ),
                        //                                           ],
                        //                                         )
                        //                                       ],
                        //                                     ),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                             );
                        //                           },
                        //                         ));
                        //                   },
                        //                 ),
                        //         ),
                        //       )
                        //     : SizedBox.shrink(),
                        // widget.listopenpeople == 3
                        //     ? Expanded(
                        //         child: Scrollbar(
                        //           child: peopleFavourite?.data?.peoplesFavourite
                        //                       ?.length ==
                        //                   0
                        //               ? Center(
                        //                   child: Text("No more service"),
                        //                 )
                        //               : GridView.builder(
                        //                   physics: BouncingScrollPhysics(),
                        //                   itemCount:
                        //                       peopleFavourite?.data != null
                        //                           ? peopleFavourite?.data
                        //                               ?.peoplesFavourite?.length
                        //                           : 0,
                        //                   shrinkWrap: true,
                        //                   gridDelegate:
                        //                       SliverGridDelegateWithFixedCrossAxisCount(
                        //                           mainAxisSpacing: 10,
                        //                           crossAxisSpacing: 2,
                        //                           crossAxisCount: 3),
                        //                   itemBuilder: (BuildContext context,
                        //                       int index) {
                        //                     return GestureDetector(
                        //                         onTap: () => Navigator.push(
                        //                                 context,
                        //                                 MaterialPageRoute(
                        //                                     builder: (context) =>
                        //                                         WongCheLaiCarCareScreen(
                        //                                             serviceid: peopleFavourite
                        //                                                 ?.data
                        //                                                 ?.peoplesFavourite?[
                        //                                                     index]
                        //                                                 .serviceId))).then(
                        //                                 (value) async {
                        //                               serviceSectionList(3);
                        //                             }),
                        //                         child: CachedNetworkImage(
                        //                           imageUrl:
                        //                               '${peopleFavourite?.data?.peoplesFavourite?[index].image}',
                        //                           placeholder: (context, url) =>
                        //                               Container(
                        //                             margin: EdgeInsets.only(
                        //                                 right: 10),
                        //                             decoration: BoxDecoration(
                        //                               color: CustomTheme.grey,
                        //                               borderRadius:
                        //                                   BorderRadius.circular(
                        //                                       18),
                        //                             ),
                        //                             child: Center(
                        //                               child: Image.asset(
                        //                                 Images.iPointsIcon,
                        //                                 color: CustomTheme
                        //                                     .darkGrey,
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           errorWidget:
                        //                               (context, url, error) =>
                        //                                   Container(
                        //                             margin: EdgeInsets.only(
                        //                                 right: 10),
                        //                             decoration: BoxDecoration(
                        //                               color: CustomTheme.grey,
                        //                               borderRadius:
                        //                                   BorderRadius.circular(
                        //                                       18),
                        //                             ),
                        //                             child: Center(
                        //                               child: Image.asset(
                        //                                 Images.iPointsIcon,
                        //                                 color: CustomTheme
                        //                                     .darkGrey,
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           imageBuilder:
                        //                               (context, imageProvider) {
                        //                             return Container(
                        //                               margin: EdgeInsets.only(
                        //                                   right: 10),
                        //                               decoration: BoxDecoration(
                        //                                 borderRadius:
                        //                                     BorderRadius
                        //                                         .circular(18),
                        //                                 image: DecorationImage(
                        //                                     fit: BoxFit.fill,
                        //                                     image:
                        //                                         imageProvider),
                        //                               ),
                        //                               child: Stack(
                        //                                 children: [
                        //                                   Container(
                        //                                     decoration:
                        //                                         BoxDecoration(
                        //                                       image: DecorationImage(
                        //                                           image: AssetImage(
                        //                                               Images
                        //                                                   .shadow),
                        //                                           fit: BoxFit
                        //                                               .fill),
                        //                                     ),
                        //                                   ),
                        //                                   Padding(
                        //                                     padding: EdgeInsets
                        //                                         .symmetric(
                        //                                             horizontal:
                        //                                                 8),
                        //                                     child: Column(
                        //                                       mainAxisAlignment:
                        //                                           MainAxisAlignment
                        //                                               .center,
                        //                                       crossAxisAlignment:
                        //                                           CrossAxisAlignment
                        //                                               .start,
                        //                                       children: [
                        //                                         Container(
                        //                                           child: Text(
                        //                                             '${peopleFavourite?.data?.peoplesFavourite?[index].serviceName}',
                        //                                             style: CustomTheme
                        //                                                 .body1
                        //                                                 .copyWith(
                        //                                                     color:
                        //                                                         CustomTheme.white),
                        //                                             maxLines: 2,
                        //                                             overflow:
                        //                                                 TextOverflow
                        //                                                     .ellipsis,
                        //                                           ),
                        //                                           constraints:
                        //                                               BoxConstraints(
                        //                                                   minWidth:
                        //                                                       30),
                        //                                           // color: Colors.green,
                        //                                           //width: 100,
                        //                                         ),
                        //                                         Text(
                        //                                           "10km",
                        //                                           style: CustomTheme
                        //                                               .body1
                        //                                               .copyWith(
                        //                                                   color:
                        //                                                       CustomTheme.white),
                        //                                         ),
                        //                                         Row(
                        //                                           children: [
                        //                                             ...List.generate(
                        //                                                 peopleFavourite?.data?.peoplesFavourite?[index].rate == "" ? 0 : 1,
                        //                                                 (index) => Row(children: [
                        //                                                       Image.asset(
                        //                                                         Images.stick,
                        //                                                         color: CustomTheme.yellow,
                        //                                                         scale: 3,
                        //                                                       ),
                        //                                                       SizedBox(
                        //                                                         width: 4,
                        //                                                       )
                        //                                                     ])),
                        //                                             SizedBox(
                        //                                               width: 4,
                        //                                             ),
                        //                                             Text(
                        //                                               "${peopleFavourite?.data?.peoplesFavourite?[index].rate ?? ""}",
                        //                                               style: TextStyle(
                        //                                                   color:
                        //                                                       CustomTheme.yellow),
                        //                                             ),
                        //                                             SizedBox(
                        //                                               width: 4,
                        //                                             ),
                        //                                             peopleFavourite?.data?.peoplesFavourite?[index].rateCount ==
                        //                                                         0 ||
                        //                                                     peopleFavourite?.data?.peoplesFavourite?[index].rate ==
                        //                                                         ""
                        //                                                 ? Text(
                        //                                                     "")
                        //                                                 : Text(
                        //                                                     "(" +
                        //                                                         Numeral(int.parse(peopleFavourite?.data?.peoplesFavourite?[index].rateCount.toString() ?? "")).value() +
                        //                                                         ")",
                        //                                                     style:
                        //                                                         TextStyle(color: CustomTheme.yellow),
                        //                                                   ),
                        //                                           ],
                        //                                         )
                        //                                       ],
                        //                                     ),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                             );
                        //                           },
                        //                         ));
                        //                   },
                        //                 ),
                        //         ),
                        //       )
                        //     : SizedBox.shrink(),
                        // widget.listopentenkm == 1
                        //     ? Expanded(
                        //         child: Scrollbar(
                        //           child:
                        //               serviceTenKm
                        //                           ?.data
                        //                           ?.servicesWithin10kmFromYou
                        //                           ?.length ==
                        //                       0
                        //                   ? Center(
                        //                       child: Text(
                        //                         "No more service",
                        //                         style: CustomTheme.body1,
                        //                       ),
                        //                     )
                        //                   : GridView.builder(
                        //                       physics: BouncingScrollPhysics(),
                        //                       itemCount: serviceTenKm?.data !=
                        //                               null
                        //                           ? serviceTenKm
                        //                               ?.data
                        //                               ?.servicesWithin10kmFromYou
                        //                               ?.length
                        //                           : 0,
                        //                       shrinkWrap: true,
                        //                       gridDelegate:
                        //                           SliverGridDelegateWithFixedCrossAxisCount(
                        //                               mainAxisSpacing: 10,
                        //                               crossAxisSpacing: 2,
                        //                               crossAxisCount: 3),
                        //                       itemBuilder:
                        //                           (BuildContext context,
                        //                               int index) {
                        //                         return GestureDetector(
                        //                           onTap: () => Navigator.push(
                        //                               context,
                        //                               MaterialPageRoute(
                        //                                   builder: (context) =>
                        //                                       WongCheLaiCarCareScreen(
                        //                                           serviceid: serviceTenKm
                        //                                               ?.data
                        //                                               ?.servicesWithin10kmFromYou?[
                        //                                                   index]
                        //                                               .serviceId))).then(
                        //                               (value) {
                        //                             serviceSectionList(1);
                        //                           }),
                        //                           child: Container(
                        //                             margin: EdgeInsets.only(
                        //                                 right: 10),
                        //                             decoration: BoxDecoration(
                        //                               borderRadius:
                        //                                   BorderRadius.circular(
                        //                                       18),
                        //                               image: DecorationImage(
                        //                                   fit: BoxFit.fill,
                        //                                   image:
                        //                                       CachedNetworkImageProvider(
                        //                                     "${serviceTenKm?.data?.servicesWithin10kmFromYou?[index].image}",
                        //                                   )),
                        //                             ),
                        //                             child: Stack(
                        //                               children: [
                        //                                 Container(
                        //                                   decoration:
                        //                                       BoxDecoration(
                        //                                     image: DecorationImage(
                        //                                         image: AssetImage(
                        //                                             Images
                        //                                                 .shadow),
                        //                                         fit: BoxFit
                        //                                             .fill),
                        //                                   ),
                        //                                 ),
                        //                                 Padding(
                        //                                   padding: EdgeInsets
                        //                                       .symmetric(
                        //                                           horizontal:
                        //                                               8),
                        //                                   child: Column(
                        //                                     mainAxisAlignment:
                        //                                         MainAxisAlignment
                        //                                             .center,
                        //                                     crossAxisAlignment:
                        //                                         CrossAxisAlignment
                        //                                             .start,
                        //                                     children: [
                        //                                       Container(
                        //                                         child: Text(
                        //                                           '${serviceTenKm?.data?.servicesWithin10kmFromYou?[index].serviceName}',
                        //                                           style: CustomTheme
                        //                                               .body1
                        //                                               .copyWith(
                        //                                                   color:
                        //                                                       CustomTheme.white),
                        //                                           maxLines: 2,
                        //                                           overflow:
                        //                                               TextOverflow
                        //                                                   .ellipsis,
                        //                                         ),
                        //                                         constraints:
                        //                                             BoxConstraints(
                        //                                                 minWidth:
                        //                                                     30),
                        //                                         // color: Colors.green,
                        //                                         //   width: 100,
                        //                                       ),
                        //                                       Text(
                        //                                         "10km",
                        //                                         style: CustomTheme
                        //                                             .body1
                        //                                             .copyWith(
                        //                                                 color: CustomTheme
                        //                                                     .white),
                        //                                       ),
                        //                                       Row(
                        //                                         children: [
                        //                                           ...List.generate(
                        //                                               serviceTenKm?.data?.servicesWithin10kmFromYou?[index].rate == "" ? 0 : 1,
                        //                                               // int.parse(serviceTenKm
                        //                                               //             ?.data
                        //                                               //             ?.servicesWithin10kmFromYou?[
                        //                                               //                 index]
                        //                                               //             .rate ==
                        //                                               //         ""
                        //                                               //     ? "0"
                        //                                               //     : serviceTenKm
                        //                                               //             ?.data
                        //                                               //             ?.servicesWithin10kmFromYou?[
                        //                                               //                 index]
                        //                                               //             .rate ??
                        //                                               //         ''),
                        //
                        //                                               (index) => Row(children: [
                        //                                                     Image.asset(
                        //                                                       Images.stick,
                        //                                                       color: CustomTheme.yellow,
                        //                                                       scale: 4,
                        //                                                     ),
                        //                                                     SizedBox(
                        //                                                       width: 4,
                        //                                                     )
                        //                                                   ])),
                        //                                           SizedBox(
                        //                                             width: 4,
                        //                                           ),
                        //                                           Text(
                        //                                             "${serviceTenKm?.data?.servicesWithin10kmFromYou?[index].rate ?? ""}",
                        //                                             style: TextStyle(
                        //                                                 color: CustomTheme
                        //                                                     .yellow),
                        //                                           ),
                        //                                           SizedBox(
                        //                                             width: 4,
                        //                                           ),
                        //                                           serviceTenKm?.data?.servicesWithin10kmFromYou?[index].rateCount ==
                        //                                                       0 ||
                        //                                                   serviceTenKm?.data?.servicesWithin10kmFromYou?[index].rate ==
                        //                                                       ""
                        //                                               ? Text("")
                        //                                               : Text(
                        //                                                   "(" +
                        //                                                       Numeral(int.parse(serviceTenKm?.data?.servicesWithin10kmFromYou?[index].rateCount.toString() ?? "")).value() +
                        //                                                       ")",
                        //                                                   style:
                        //                                                       TextStyle(color: CustomTheme.yellow),
                        //                                                 ),
                        //                                         ],
                        //                                       )
                        //                                     ],
                        //                                   ),
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                           ),
                        //                         );
                        //                       },
                        //                     ),
                        //         ),
                        //       )
                        //     : SizedBox.shrink()
                      ],
                    ),
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

  Widget tenKmService() {
    return Expanded(
      child: Scrollbar(
        child: serviceTenKm?.data?.servicesWithin10kmFromYou?.length == 0
            ? Center(
                child: Text(
                  "No more service",
                  style: CustomTheme.body1,
                ),
              )
            : GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: serviceTenKm?.data != null
                    ? serviceTenKm?.data?.servicesWithin10kmFromYou?.length
                    : 0,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 2,
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WongCheLaiCarCareScreen(
                                serviceid: serviceTenKm
                                    ?.data
                                    ?.servicesWithin10kmFromYou?[index]
                                    .serviceId))).then((value) {
                      serviceSectionList(1);
                    }),
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(
                              "${serviceTenKm?.data?.servicesWithin10kmFromYou?[index].image}",
                            )),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(Images.shadow),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    '${serviceTenKm?.data?.servicesWithin10kmFromYou?[index].serviceName}',
                                    style: CustomTheme.body1
                                        .copyWith(color: CustomTheme.white),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  constraints: BoxConstraints(minWidth: 30),
                                  // color: Colors.green,
                                  //   width: 100,
                                ),
                                Text(
                                  "10km",
                                  style: CustomTheme.body1
                                      .copyWith(color: CustomTheme.white),
                                ),
                                Row(
                                  children: [
                                    ...List.generate(
                                        serviceTenKm
                                                    ?.data
                                                    ?.servicesWithin10kmFromYou?[
                                                        index]
                                                    .rate ==
                                                ""
                                            ? 0
                                            : 1,
                                        // int.parse(serviceTenKm
                                        //             ?.data
                                        //             ?.servicesWithin10kmFromYou?[
                                        //                 index]
                                        //             .rate ==
                                        //         ""
                                        //     ? "0"
                                        //     : serviceTenKm
                                        //             ?.data
                                        //             ?.servicesWithin10kmFromYou?[
                                        //                 index]
                                        //             .rate ??
                                        //         ''),

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
                                      "${serviceTenKm?.data?.servicesWithin10kmFromYou?[index].rate ?? ""}",
                                      style:
                                          TextStyle(color: CustomTheme.yellow),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    serviceTenKm
                                                    ?.data
                                                    ?.servicesWithin10kmFromYou?[
                                                        index]
                                                    .rateCount ==
                                                0 ||
                                            serviceTenKm
                                                    ?.data
                                                    ?.servicesWithin10kmFromYou?[
                                                        index]
                                                    .rate ==
                                                ""
                                        ? Text("")
                                        : Text(
                                            "(" +
                                                Numeral(int.parse(serviceTenKm
                                                            ?.data
                                                            ?.servicesWithin10kmFromYou?[
                                                                index]
                                                            .rateCount
                                                            .toString() ??
                                                        ""))
                                                    .value() +
                                                ")",
                                            style: TextStyle(
                                                color: CustomTheme.yellow),
                                          ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget topTwentyServiceList() {
    return Expanded(
      child: Scrollbar(
        child: serviceSection?.data?.top20ServicesThisMonth?.length == 0
            ? Center(
                child: Text(
                  "No more service",
                  style: CustomTheme.body1,
                ),
              )
            : GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: serviceSection?.data != null
                    ? serviceSection?.data?.top20ServicesThisMonth?.length
                    : 0,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 2,
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WongCheLaiCarCareScreen(
                                      serviceid: serviceSection
                                          ?.data
                                          ?.top20ServicesThisMonth?[index]
                                          .serviceId))).then((value) async {
                            await serviceSectionList(2);
                          }),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: CustomTheme.grey,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Image.asset(
                              Images.iPointsIcon,
                              color: CustomTheme.darkGrey,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: CustomTheme.grey,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Image.asset(
                              Images.iPointsIcon,
                              color: CustomTheme.darkGrey,
                            ),
                          ),
                        ),
                        imageUrl:
                            '${serviceSection?.data?.top20ServicesThisMonth?[index].image}',
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              image: DecorationImage(
                                  fit: BoxFit.fill, image: imageProvider),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(Images.shadow),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          '${serviceSection?.data?.top20ServicesThisMonth?[index].serviceName}',
                                          style: CustomTheme.body1.copyWith(
                                              color: CustomTheme.white),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "10km",
                                        style: CustomTheme.body1
                                            .copyWith(color: CustomTheme.white),
                                      ),
                                      Row(
                                        children: [
                                          ...List.generate(
                                              serviceSection
                                                          ?.data
                                                          ?.top20ServicesThisMonth?[
                                                              index]
                                                          .rate ==
                                                      ""
                                                  ? 0
                                                  : 1,
                                              // serviceSection!
                                              //             .data!
                                              //             .top20ServicesThisMonth![
                                              //                 index]
                                              //             .rateCount! >=
                                              //         1
                                              //     ? 1
                                              //     : 0,

                                              // int.parse(serviceSection
                                              //           ?.data
                                              //             ?.top20ServicesThisMonth?[
                                              //                 index]
                                              //             .rate ==
                                              //         ""
                                              //     ? "0"
                                              //     : serviceSection
                                              //             ?.data
                                              //             ?.top20ServicesThisMonth?[
                                              //                 index]
                                              //             .rate ??
                                              //         ''),
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
                                            width: 4,
                                          ),
                                          Text(
                                            "${serviceSection?.data?.top20ServicesThisMonth?[index].rate ?? ""}",
                                            style: TextStyle(
                                                color: CustomTheme.yellow),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          serviceSection
                                                          ?.data
                                                          ?.top20ServicesThisMonth?[
                                                              index]
                                                          .rateCount ==
                                                      0 ||
                                                  serviceSection
                                                          ?.data
                                                          ?.top20ServicesThisMonth?[
                                                              index]
                                                          .rate ==
                                                      ""
                                              ? Text("")
                                              : Text(
                                                  "(" +
                                                      Numeral(int.parse(serviceSection
                                                                  ?.data
                                                                  ?.top20ServicesThisMonth?[
                                                                      index]
                                                                  .rateCount
                                                                  .toString() ??
                                                              ""))
                                                          .value() +
                                                      ")",
                                                  style: TextStyle(
                                                      color:
                                                          CustomTheme.yellow),
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
      ),
    );
  }

  Widget peopleFavouriteList() {
    return Expanded(
      child: Scrollbar(
        child: peopleFavourite?.data?.peoplesFavourite?.length == 0
            ? Center(
                child: Text("No more service"),
              )
            : GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: peopleFavourite?.data != null
                    ? peopleFavourite?.data?.peoplesFavourite?.length
                    : 0,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 2,
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WongCheLaiCarCareScreen(
                                      serviceid: peopleFavourite
                                          ?.data
                                          ?.peoplesFavourite?[index]
                                          .serviceId))).then((value) async {
                            serviceSectionList(3);
                          }),
                      child: CachedNetworkImage(
                        imageUrl:
                            '${peopleFavourite?.data?.peoplesFavourite?[index].image}',
                        placeholder: (context, url) => Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: CustomTheme.grey,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Image.asset(
                              Images.iPointsIcon,
                              color: CustomTheme.darkGrey,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: CustomTheme.grey,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Image.asset(
                              Images.iPointsIcon,
                              color: CustomTheme.darkGrey,
                            ),
                          ),
                        ),
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              image: DecorationImage(
                                  fit: BoxFit.fill, image: imageProvider),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(Images.shadow),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          '${peopleFavourite?.data?.peoplesFavourite?[index].serviceName}',
                                          style: CustomTheme.body1.copyWith(
                                              color: CustomTheme.white),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        constraints:
                                            BoxConstraints(minWidth: 30),
                                        // color: Colors.green,
                                        //width: 100,
                                      ),
                                      Text(
                                        "10km",
                                        style: CustomTheme.body1
                                            .copyWith(color: CustomTheme.white),
                                      ),
                                      Row(
                                        children: [
                                          ...List.generate(
                                              peopleFavourite
                                                          ?.data
                                                          ?.peoplesFavourite?[
                                                              index]
                                                          .rate ==
                                                      ""
                                                  ? 0
                                                  : 1,
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
                                            width: 4,
                                          ),
                                          Text(
                                            "${peopleFavourite?.data?.peoplesFavourite?[index].rate ?? ""}",
                                            style: TextStyle(
                                                color: CustomTheme.yellow),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          peopleFavourite
                                                          ?.data
                                                          ?.peoplesFavourite?[
                                                              index]
                                                          .rateCount ==
                                                      0 ||
                                                  peopleFavourite
                                                          ?.data
                                                          ?.peoplesFavourite?[
                                                              index]
                                                          .rate ==
                                                      ""
                                              ? Text("")
                                              : Text(
                                                  "(" +
                                                      Numeral(int.parse(peopleFavourite
                                                                  ?.data
                                                                  ?.peoplesFavourite?[
                                                                      index]
                                                                  .rateCount
                                                                  .toString() ??
                                                              ""))
                                                          .value() +
                                                      ")",
                                                  style: TextStyle(
                                                      color:
                                                          CustomTheme.yellow),
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
      ),
    );
  }

  Widget listOfData() {
    if (widget.listopentenkm == 1) {
      return tenKmService();
    } else if (widget.listopentoptwenty == 2) {
      return topTwentyServiceList();
    } else {
      return peopleFavouriteList();
    }
  }
}
