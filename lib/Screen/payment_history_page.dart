import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/bottom_navigation.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/payment_history_model.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'car_description_page.dart';
import 'no_internet_screen.dart';

class PaymentHistoryPage extends StatefulWidget {
  int? paymentType;

  int? status;
  PaymentHistoryPage({Key? key, this.paymentType, this.status})
      : super(key: key);

  @override
  _PaymentHistoryPageState createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  PaymentHistory? paymentHistory;
  String? newDate;
  var formatter = NumberFormat('#,##,000');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentHistoryDetail();
  }

  getFormatedDate(date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('d MMM y');
    newDate = outputFormat.format(inputDate);
    return newDate;
  }

  Future paymentHistoryDetail() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      Response response = await ApiClient().dio.post(Constant.paymentHistory,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          paymentHistory = PaymentHistory.fromJson(response.data);
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
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (widget.status == 1) {
          await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigation()),
              (route) => false);
        } else {
          print("not working");
        }
        return true;
      },
      child: Stack(
        children: [
          SafeArea(
            child: Scaffold(
              body: paymentHistory?.data == null || paymentHistory?.data == []
                  ? Center(
                      child: CircularProgressIndicator(
                        color: CustomTheme.primarycolor,
                      ),
                    )
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Height / 40,
                          ),
                          Text(
                            "Payment History",
                            style: CustomTheme.title,
                          ),
                          SizedBox(
                            height: Height / 30,
                          ),
                          Expanded(
                            child: Scrollbar(
                              child: paymentHistory?.data?.length == 0
                                  ? Center(
                                      child: Text("No Payment History",
                                          style: TextStyle(
                                              fontFamily:
                                                  CustomTheme.fontFamily)))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: paymentHistory?.data != null ||
                                              paymentHistory?.data == []
                                          ? paymentHistory?.data?.length
                                          : 0,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        getFormatedDate(paymentHistory
                                            ?.data?[index].payCreatedAt);

                                        print(newDate.toString() + "nnnnnnnn");
                                        return Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(.2),
                                                    blurRadius: 2.9,
                                                    spreadRadius: 1.0,
                                                    offset: Offset(4.0, 4.0),
                                                  ),
                                                  BoxShadow(
                                                      color:
                                                          Colors.grey.shade200,
                                                      blurRadius: 5.0,
                                                      spreadRadius: 2.0,
                                                      offset: Offset(6.0, 6.0))
                                                ],
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                              ),
                                              child: Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      height: 55,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color: CustomTheme.grey,
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
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container(
                                                      height: 55,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color: CustomTheme.grey,
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
                                                    imageUrl:
                                                        "${paymentHistory?.data?[index].servicesImages}",
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
                                                          "${paymentHistory?.data?[index].vendorName}",
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
                                                          height: Height / 80,
                                                        ),
                                                        Text(
                                                          "Paid on " +
                                                              newDate
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              fontFamily:
                                                                  CustomTheme
                                                                      .fontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                        SizedBox(
                                                          height: Height / 80,
                                                        ),
                                                        paymentHistory
                                                                    ?.data?[
                                                                        index]
                                                                    .paymentType ==
                                                                1
                                                            ? Visibility(
                                                                visible: true,
                                                                child: Text(
                                                                  "${paymentHistory?.data?[index].payInvoiceAmount}"
                                                                  " point"
                                                                  //"RM "
                                                                  ,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          CustomTheme
                                                                              .fontFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              )
                                                            : Visibility(
                                                                visible: false,
                                                                child: Text(
                                                                  "${paymentHistory?.data?[index].payInvoiceAmount}"
                                                                  " point"
                                                                  //"RM "
                                                                  ,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          CustomTheme
                                                                              .fontFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                        paymentHistory
                                                                    ?.data?[
                                                                        index]
                                                                    .paymentType ==
                                                                2
                                                            ? Visibility(
                                                                visible: true,
                                                                child: Text(
                                                                  "RM " +
                                                                      "${paymentHistory?.data?[index].payInvoiceAmount}"
                                                                  //"RM "
                                                                  ,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          CustomTheme
                                                                              .fontFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              )
                                                            : Visibility(
                                                                visible: false,
                                                                child: Text(
                                                                  "RM " +
                                                                      "${paymentHistory?.data?[index].payInvoiceAmount}"

                                                                  //"RM "
                                                                  ,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          CustomTheme
                                                                              .fontFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                        paymentHistory
                                                                    ?.data?[
                                                                        index]
                                                                    .paymentType ==
                                                                3
                                                            ? Visibility(
                                                                visible: true,
                                                                child: Text(
                                                                  "RM " +
                                                                      "${paymentHistory?.data?[index].payInvoiceAmount}"

                                                                  //"RM "
                                                                  ,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          CustomTheme
                                                                              .fontFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              )
                                                            : Visibility(
                                                                visible: false,
                                                                child: Text(
                                                                  "RM " +
                                                                      "${paymentHistory?.data?[index].payInvoiceAmount}"

                                                                  //"RM "
                                                                  ,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          CustomTheme
                                                                              .fontFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                        paymentHistory
                                                                    ?.data?[
                                                                        index]
                                                                    .paymentType ==
                                                                4
                                                            ? Visibility(
                                                                visible: true,
                                                                child: Text(
                                                                  "RM " +
                                                                      "${paymentHistory?.data?[index].payInvoiceAmount}"

                                                                  //"RM "
                                                                  ,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          CustomTheme
                                                                              .fontFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              )
                                                            : Visibility(
                                                                visible: false,
                                                                child: Text(
                                                                  "RM " +
                                                                      "${paymentHistory?.data?[index].payInvoiceAmount}"

                                                                  //"RM "
                                                                  ,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          CustomTheme
                                                                              .fontFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                                  // Spacer(),
                                                  paymentHistory?.data?[index]
                                                              .paymentType ==
                                                          1
                                                      ? Visibility(
                                                          visible: true,
                                                          child: Image.asset(
                                                            Images
                                                                .iPointBlueIcon,
                                                            scale: 3,
                                                          ),
                                                        )
                                                      : Visibility(
                                                          visible: false,
                                                          child: Image.asset(
                                                            Images
                                                                .iPointBlueIcon,
                                                            scale: 3,
                                                          ),
                                                        ),
                                                  paymentHistory?.data?[index]
                                                              .paymentType ==
                                                          2
                                                      ? Visibility(
                                                          visible: true,
                                                          child: Image.asset(
                                                            Images
                                                                .debitCircleIcon,
                                                            scale: 3,
                                                          ))
                                                      : Visibility(
                                                          visible: false,
                                                          child: Image.asset(
                                                            Images
                                                                .iPointBlueIcon,
                                                            scale: 3,
                                                          ),
                                                        ),
                                                  paymentHistory?.data?[index]
                                                              .paymentType ==
                                                          3
                                                      ? Visibility(
                                                          visible: true,
                                                          child: Image.asset(
                                                            Images
                                                                .iPointBlueIcon,
                                                            scale: 3,
                                                          ),
                                                        )
                                                      : Visibility(
                                                          visible: false,
                                                          child: Image.asset(
                                                            Images
                                                                .iPointBlueIcon,
                                                            scale: 3,
                                                          ),
                                                        ),
                                                  paymentHistory?.data?[index]
                                                              .paymentType ==
                                                          4
                                                      ? Visibility(
                                                          visible: true,
                                                          child: Image.asset(
                                                            Images
                                                                .iPointBlueIcon,
                                                            scale: 3,
                                                          ),
                                                        )
                                                      : Visibility(
                                                          visible: false,
                                                          child: Image.asset(
                                                            Images
                                                                .iPointBlueIcon,
                                                            scale: 3,
                                                          ),
                                                        ),
                                                  // Spacer(),
                                                  SizedBox(width: 20),
                                                  TextButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(CustomTheme
                                                                      .grey),
                                                          overlayColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .transparent),
                                                          shape: MaterialStateProperty
                                                              .all(
                                                                  RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                          ))),
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => AppointmentDetail(
                                                                    appoitmantId: paymentHistory
                                                                        ?.data?[
                                                                            index]
                                                                        .appointmentId,
                                                                    payment_mode:
                                                                        1,
                                                                    payment_date:
                                                                        paymentHistory
                                                                            ?.data?[index])));
                                                      },
                                                      child: Text("View",
                                                          style: CustomTheme
                                                              .body2)),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        );
                                      },
                                    ),
                            ),
                          )
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
      ),
    );
  }
}
