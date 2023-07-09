import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/invoice_screen.dart';
import 'package:ipoint/Screen/swipe_pay_screen.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/model/appointmant_detaile_model.dart';
import 'package:ipoint/model/get_appoitment_model.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'no_internet_screen.dart';

class PaymentScreen extends StatefulWidget {
  AppointmentData? getAppointmentsModel;
  int? rmTotal;
  PaymentScreen({Key? key, this.getAppointmentsModel, this.rmTotal})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  GetAppointmentsModel? getAppointmentsModel;
  AppointmentDetailModel? appointmentDetailModel;
  int selected = 0;
  var formatter = NumberFormat('#,##,000');

  Future getAppointment(int flag) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData = FormData.fromMap({"flag": flag});
      Response response = await ApiClient().dio.post(Constant.getAppointment,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          getAppointmentsModel = GetAppointmentsModel.fromJson(response.data);
        });
      }

      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    // tabController = TabController(length: 1, vsync: this);
    getAppointment(4);
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(Height / 4),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: CustomTheme.white,
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Height / 60,
                    ),
                    Text("Payment",
                        style: CustomTheme.body7.copyWith(fontSize: 18)),
                    SizedBox(
                      height: Height / 40,
                    ),
                    Container(
                        alignment: Alignment.center,
                        height: Height / 19,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: CustomTheme.yellow
                            // : Colors.grey.withOpacity(0.2),
                            ),
                        child: Text('Pending',
                            style: CustomTheme.body3.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 14))),

                    // TabBar(
                    //   // onTap: (value) {
                    //   //   setState(() {
                    //   //     selected = value;
                    //   //   });
                    //   // },
                    //   indicatorColor: Colors.transparent,
                    //   controller: tabController,
                    //   tabs: [
                    //     Container(
                    //         alignment: Alignment.center,
                    //         height: Height / 19,
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(30),
                    //             color: CustomTheme.yellow
                    //             // : Colors.grey.withOpacity(0.2),
                    //             ),
                    //         child: Text('Pending',
                    //             style: CustomTheme.body3.copyWith(
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 14))),
                    //     // Container(
                    //     //     alignment: Alignment.center,
                    //     //     height: Height / 19,
                    //     //     decoration: BoxDecoration(
                    //     //       borderRadius: BorderRadius.circular(30),
                    //     //       color: selected == 1
                    //     //           ? CustomTheme.primarycolor
                    //     //           : Colors.grey.withOpacity(0.2),
                    //     //     ),
                    //     //     child: Text('Paid',
                    //     //         style: CustomTheme.body3.copyWith(
                    //     //             fontWeight: FontWeight.bold,
                    //     //             fontSize: 14))),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 11),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
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
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.getAppointmentsModel?.vendorName}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: CustomTheme.fontFamily,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "${widget.getAppointmentsModel?.appointmentDate}",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: CustomTheme.fontFamily,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                  "RM " +
                                      "${widget.getAppointmentsModel?.amount}",
                                  style: CustomTheme.title2),
                              SizedBox(width: 10),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      CustomTheme.red),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  //appoitmanDetails();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InVoiceScreen(
                                          getAppointmentsModel:
                                              widget.getAppointmentsModel),
                                    ),
                                  );
                                },
                                child: Text("view Invoice",
                                    style: CustomTheme.body6),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),

              // ListView.builder(
              //     itemCount: getAppointmentsModel?.data != null
              //         ? getAppointmentsModel?.data?.length
              //         : 0,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Column(children: [
              //         Container(
              //             padding: EdgeInsets.symmetric(horizontal: 11),
              //             margin: EdgeInsets.only(left: 10, right: 10),
              //             width: double.infinity,
              //             decoration: BoxDecoration(
              //               boxShadow: [
              //                 BoxShadow(
              //                   color: Colors.grey.withOpacity(.2),
              //                   blurRadius: 2.9,
              //                   spreadRadius: 1.0,
              //                   offset: Offset(4.0, 4.0),
              //                 ),
              //                 BoxShadow(
              //                     color: Colors.grey.shade200,
              //                     blurRadius: 5.0,
              //                     spreadRadius: 2.0,
              //                     offset: Offset(6.0, 6.0))
              //               ],
              //               // color: Colors.green,
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(30),
              //             ),
              //             child: Padding(
              //               padding: EdgeInsets.symmetric(
              //                   horizontal: 10, vertical: 10),
              //               child: Column(
              //                 children: [
              //                   Row(
              //                     children: [
              //                       Expanded(
              //                         child: Column(
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.start,
              //                           children: [
              //                             Text(
              //                               "${getAppointmentsModel?.data?[index].servicesName}",
              //                               style: TextStyle(
              //                                   fontSize: 14,
              //                                   fontFamily:
              //                                       CustomTheme.fontFamily,
              //                                   fontWeight: FontWeight.bold),
              //                             ),
              //                             SizedBox(
              //                               height: 12,
              //                             ),
              //                             Text(
              //                               // "2-2-2022"
              //                               "${getAppointmentsModel?.data?[index].appointmentDate}",
              //                               style: TextStyle(
              //                                   fontSize: 10,
              //                                   fontFamily:
              //                                       CustomTheme.fontFamily,
              //                                   fontWeight: FontWeight.normal),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                       Text(
              //                           "RM " +
              //                               "${(getAppointmentsModel?.data?[index].amount)! + (getAppointmentsModel?.data?[index].additionalCharge?[4].price ?? 0)}"
              //
              //                           //"${widget.rmTotal}"
              //                           ,
              //                           style: CustomTheme.title2),
              //                       SizedBox(
              //                         width: 20,
              //                       ),
              //                       TextButton(
              //                           style: ButtonStyle(
              //                               backgroundColor:
              //                                   MaterialStateProperty.all(
              //                                       CustomTheme.red),
              //                               overlayColor:
              //                                   MaterialStateProperty.all(
              //                                       Colors.transparent),
              //                               shape: MaterialStateProperty.all(
              //                                   RoundedRectangleBorder(
              //                                 borderRadius:
              //                                     BorderRadius.circular(30.0),
              //                               ))),
              //                           onPressed: () {},
              //                           child: Text("view Invoice",
              //                               style: CustomTheme.body6)),
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //             )),
              //         SizedBox(
              //           height: 10,
              //         )
              //       ]);
              //     }),

              // TabBarView(
              //   // physics: NeverScrollableScrollPhysics(),
              //   controller: tabController,
              //   children: [
              //
              //     // Column(
              //     //   children: [
              //     //     Container(
              //     //       padding: EdgeInsets.symmetric(horizontal: 11),
              //     //       margin: EdgeInsets.only(left: 10, right: 10),
              //     //       width: double.infinity,
              //     //       decoration: BoxDecoration(
              //     //         boxShadow: [
              //     //           BoxShadow(
              //     //             color: Colors.grey.withOpacity(.2),
              //     //             blurRadius: 2.9,
              //     //             spreadRadius: 1.0,
              //     //             offset: Offset(4.0, 4.0),
              //     //           ),
              //     //           BoxShadow(
              //     //             color: Colors.grey.shade200,
              //     //             blurRadius: 5.0,
              //     //             spreadRadius: 2.0,
              //     //             offset: Offset(6.0, 6.0),
              //     //           )
              //     //         ],
              //     //         color: Colors.white,
              //     //         borderRadius: BorderRadius.circular(30),
              //     //       ),
              //     //       child: Padding(
              //     //         padding: EdgeInsets.symmetric(
              //     //             horizontal: 10, vertical: 10),
              //     //         child: Column(
              //     //           children: [
              //     //             Row(
              //     //               children: [
              //     //                 Expanded(
              //     //                   child: Column(
              //     //                     crossAxisAlignment:
              //     //                         CrossAxisAlignment.start,
              //     //                     children: [
              //     //                       Text(
              //     //                         "${widget.getAppointmentsModel?.vendorName}",
              //     //                         style: TextStyle(
              //     //                             fontSize: 14,
              //     //                             fontFamily:
              //     //                                 CustomTheme.fontFamily,
              //     //                             fontWeight: FontWeight.bold),
              //     //                       ),
              //     //                       SizedBox(
              //     //                         height: 12,
              //     //                       ),
              //     //                       Text(
              //     //                         "${widget.getAppointmentsModel?.appointmentDate}",
              //     //                         style: TextStyle(
              //     //                             fontSize: 10,
              //     //                             fontFamily:
              //     //                                 CustomTheme.fontFamily,
              //     //                             fontWeight: FontWeight.normal),
              //     //                       ),
              //     //                     ],
              //     //                   ),
              //     //                 ),
              //     //                 Text(
              //     //                     "RM " +
              //     //                         formatter.format(widget
              //     //                             .getAppointmentsModel?.amount),
              //     //                     style: CustomTheme.title2),
              //     //                 SizedBox(width: 10),
              //     //                 TextButton(
              //     //                   style: ButtonStyle(
              //     //                     backgroundColor:
              //     //                         MaterialStateProperty.all(
              //     //                             CustomTheme.red),
              //     //                     overlayColor: MaterialStateProperty.all(
              //     //                         Colors.transparent),
              //     //                     shape: MaterialStateProperty.all(
              //     //                       RoundedRectangleBorder(
              //     //                         borderRadius:
              //     //                             BorderRadius.circular(30.0),
              //     //                       ),
              //     //                     ),
              //     //                   ),
              //     //                   onPressed: () {
              //     //                     //appoitmanDetails();
              //     //                     Navigator.push(
              //     //                       context,
              //     //                       MaterialPageRoute(
              //     //                         builder: (context) => InVoiceScreen(
              //     //                             getAppointmentsModel:
              //     //                                 widget.getAppointmentsModel),
              //     //                       ),
              //     //                     );
              //     //                   },
              //     //                   child: Text("view Invoice",
              //     //                       style: CustomTheme.body6),
              //     //                 ),
              //     //               ],
              //     //             ),
              //     //           ],
              //     //         ),
              //     //       ),
              //     //     ),
              //     //     SizedBox(
              //     //       height: 10,
              //     //     )
              //     //   ],
              //     // ),
              //   ],
              // ),
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
