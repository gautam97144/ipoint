import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/Widget/custom_yellow_grey_button.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/referral_model.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'no_internet_screen.dart';

class Reffral extends StatefulWidget {
  const Reffral({Key? key}) : super(key: key);

  @override
  _ReffralState createState() => _ReffralState();
}

class _ReffralState extends State<Reffral> with SingleTickerProviderStateMixin {
  int selected = 0;
  TabController? _tabController;
  ReferralList? referralList;
  var newDate;

  @override
  void initState() {
    // _tabController = TabController(length: 2, vsync: this);

    super.initState();
    fetchreferral();
  }

  Future fetchreferral() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      Response response = await ApiClient().dio.post(
            Constant.referralList,
            options: Options(headers: {"Authorization": "Bearer $token"}),
          );

      if (response.data != null) {
        if (response.statusCode == 200) {
          print(response.data);
        }

        if (mounted) {
          setState(() {
            referralList = ReferralList.fromJson(response.data);
          });
        }

        if (referralList?.success == 1) {
          print(referralList?.data);
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  getFormatedDate(date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('d MMM y');
    newDate = outputFormat.format(inputDate);
    return newDate;
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Stack(children: [
      SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                SizedBox(
                  height: Height / 60,
                ),
                Text("Referral",
                    style: CustomTheme.body7.copyWith(fontSize: 18)),
                Expanded(
                  child: referralList?.data == null
                      ? Center(
                          child: CircularProgressIndicator(
                            color: CustomTheme.primarycolor,
                          ),
                        )
                      : referralList?.data?.length == 0 ||
                              referralList?.data == []
                          ? Center(
                              child: Text("No Any Record"),
                            )
                          : SizedBox(
                              height: 600,
                              child: ListView.builder(
                                itemCount: referralList?.data != null
                                    ? referralList?.data?.length
                                    : 0,
                                //shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  getFormatedDate(
                                      "${referralList?.data?[index].refDate}");
                                  return Column(
                                    children: [
                                      Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10),
                                          // height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.grey.withOpacity(.2),
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
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    CachedNetworkImage(
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        height: 55,
                                                        width: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              CustomTheme.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                        ),
                                                        child: Center(
                                                          child: Image.asset(
                                                            Images.iPointsIcon,
                                                            color: CustomTheme
                                                                .darkGrey,
                                                          ),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(
                                                        height: 55,
                                                        width: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              CustomTheme.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                        ),
                                                        child: Center(
                                                          child: Image.asset(
                                                            Images.iPointsIcon,
                                                            color: CustomTheme
                                                                .darkGrey,
                                                          ),
                                                        ),
                                                      ),
                                                      imageUrl: "",
                                                      //"${getAppointmentsModel?.data?[index].servicesImages}",
                                                      imageBuilder: (context,
                                                          imageProvider) {
                                                        return Container(
                                                          height: 55,
                                                          width: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                                  // color: Colors.green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image:
                                                                          imageProvider)),
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${referralList?.data?[index].name}",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    CustomTheme
                                                                        .fontFamily,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            height: 12,
                                                          ),
                                                          Text(
                                                            "${newDate.substring(0, 11)}",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontFamily:
                                                                    CustomTheme
                                                                        .fontFamily,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    // Spacer(),

                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  );

                                  //   Column(
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   children: [
                                  //     Container(
                                  //       margin: EdgeInsets.only(
                                  //           right: 10, left: 10),
                                  //       width: double.infinity,
                                  //       // height: 100,
                                  //
                                  //       decoration: BoxDecoration(
                                  //         color: Colors.white,
                                  //         boxShadow: [
                                  //           BoxShadow(
                                  //             color:
                                  //                 Colors.grey.withOpacity(.2),
                                  //             blurRadius: 2.9,
                                  //             spreadRadius: 1.0,
                                  //             offset: Offset(4.0, 4.0),
                                  //           ),
                                  //           BoxShadow(
                                  //               color: Colors.grey.shade200,
                                  //               blurRadius: 6.0,
                                  //               spreadRadius: 1.0,
                                  //               offset: Offset(6.0, 3.0))
                                  //         ],
                                  //         borderRadius:
                                  //             BorderRadius.circular(30),
                                  //       ),
                                  //       padding: EdgeInsets.symmetric(
                                  //           horizontal: 10, vertical: 10),
                                  //       child: Row(
                                  //         children: [
                                  //           Image.asset(
                                  //             Images.carImg,
                                  //             scale: 4,
                                  //           ),
                                  //           SizedBox(
                                  //             width: 10,
                                  //           ),
                                  //           Expanded(
                                  //             child: Column(
                                  //               mainAxisSize: MainAxisSize.min,
                                  //               crossAxisAlignment:
                                  //                   CrossAxisAlignment.start,
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment
                                  //                       .spaceBetween,
                                  //               children: [
                                  //                 Text(
                                  //                   "ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt",
                                  //                   //"${referralList?.data?[index].name}",
                                  //                   maxLines: 1,
                                  //                   overflow:
                                  //                       TextOverflow.ellipsis,
                                  //                   style: TextStyle(
                                  //                       fontSize: 14,
                                  //                       fontFamily: CustomTheme
                                  //                           .fontFamily,
                                  //                       fontWeight:
                                  //                           FontWeight.bold),
                                  //                 ),
                                  //                 Text(
                                  //                   "${referralList?.data?[index].createdAt}",
                                  //                   style: TextStyle(
                                  //                       fontSize: 10,
                                  //                       fontFamily: CustomTheme
                                  //                           .fontFamily,
                                  //                       fontWeight:
                                  //                           FontWeight.normal),
                                  //                   maxLines: 1,
                                  //                   overflow:
                                  //                       TextOverflow.ellipsis,
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //     SizedBox(
                                  //       height: 10,
                                  //     )
                                  //   ],
                                  // );
                                },
                              ),
                            ),
                )
                // SizedBox(
                //   height: Height / 40,
                // ),
                // TabBar(
                //   onTap: (value) {
                //     setState(() {
                //       selected = value;
                //     });
                //   },
                //   indicatorColor: Colors.transparent,
                //   controller: _tabController,
                //   tabs: [
                //     Container(
                //         alignment: Alignment.center,
                //         height: Height / 19,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(30),
                //           color: selected == 0
                //               ? CustomTheme.yellow
                //               : Colors.grey.withOpacity(0.2),
                //         ),
                //         child: Text('Individual',
                //             style: CustomTheme.body3.copyWith(
                //                 fontWeight: FontWeight.bold, fontSize: 14))),
                //     Container(
                //         alignment: Alignment.center,
                //
                //         height: Height / 19,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(30),
                //           color: selected == 1
                //               ? CustomTheme.primarycolor
                //               : Colors.grey.withOpacity(0.2),
                //         ),
                //         child: Text('Industry',
                //             style: CustomTheme.body3.copyWith(
                //                 fontWeight: FontWeight.bold, fontSize: 14))),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
      Provider.of<InternetConnectivityCheck>(context, listen: true).isNoInternet
          ? NoInterNetScreen()
          : SizedBox.shrink()
    ]);
  }

  // Widget referralCard() {
  //   var Height = MediaQuery.of(context).size.height;
  //   var Width = MediaQuery.of(context).size.width;
  //   return Container(
  //       width: double.infinity,
  //       margin: EdgeInsets.only(left: 10, right: 10),
  //       // height: 100,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(.2),
  //             blurRadius: 2.9,
  //             spreadRadius: 1.0,
  //             offset: Offset(4.0, 4.0),
  //           ),
  //           BoxShadow(
  //               color: Colors.grey.shade200,
  //               blurRadius: 5.0,
  //               spreadRadius: 2.0,
  //               offset: Offset(6.0, 6.0))
  //         ],
  //         borderRadius: BorderRadius.circular(30),
  //       ),
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //         child: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 Image.asset(
  //                   Images.carImg,
  //                   scale: 4,
  //                 ),
  //                 SizedBox(
  //                   width: 10,
  //                 ),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "Wong Che Lai Car Care",
  //                         style: TextStyle(
  //                             fontSize: 14,
  //                             fontFamily: CustomTheme.fontFamily,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                       SizedBox(
  //                         height: 12,
  //                       ),
  //                       Text(
  //                         "10 Feb 2021",
  //                         style: TextStyle(
  //                             fontSize: 10,
  //                             fontFamily: CustomTheme.fontFamily,
  //                             fontWeight: FontWeight.normal),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                 //Spacer(),
  //                 Container(
  //                   padding: EdgeInsets.all(6),
  //                   decoration: BoxDecoration(
  //                     color: CustomTheme.primarycolor,
  //                     borderRadius: BorderRadius.circular(14),
  //                   ),
  //                   child: Image.asset(
  //                     Images.watchIcon,
  //                     scale: 2.5,
  //                   ),
  //                 ),
  //
  //                 SizedBox(
  //                   width: 20,
  //                 ),
  //                 TextButton(
  //                     style: ButtonStyle(
  //                         backgroundColor:
  //                             MaterialStateProperty.all(CustomTheme.grey),
  //                         overlayColor:
  //                             MaterialStateProperty.all(Colors.transparent),
  //                         shape:
  //                             MaterialStateProperty.all(RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(30.0),
  //                         ))),
  //                     onPressed: () {},
  //                     child: Text("Edit", style: CustomTheme.body2)),
  //                 SizedBox(
  //                   width: 20,
  //                 ),
  //                 Container(
  //                   height: Height / 22,
  //                   width: Width / 12,
  //                   padding: EdgeInsets.all(6),
  //                   decoration: BoxDecoration(
  //                     color: CustomTheme.red,
  //                     borderRadius: BorderRadius.circular(14),
  //                   ),
  //                   child: Image.asset(
  //                     Images.deleteIcon,
  //                     scale: 2.5,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ));
  // }
}
