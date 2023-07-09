import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/choose_payment_method_screen.dart';
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
import 'package:slide_to_act/slide_to_act.dart';

import 'no_internet_screen.dart';

class InVoiceScreen extends StatefulWidget {
  AppointmentData? getAppointmentsModel;
  // AppointmentDetailData? appointmentDetailModel;
  InVoiceScreen({Key? key, this.getAppointmentsModel}) : super(key: key);

  @override
  _InVoiceScreenState createState() => _InVoiceScreenState();
}

class _InVoiceScreenState extends State<InVoiceScreen> {
  GetAppointmentsModel? getAppointmentsModel;
  AppointmentDetailModel? appointmentDetailModel;
  var itemprice = 0.0;
  var chargesPrice = 0.0;
  var total = 0.0;
  bool isVisible = false;
  var formatter = NumberFormat('#,##,000');

  Future appoitmanDetails() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData = FormData.fromMap(
          {"appointment_id": widget.getAppointmentsModel?.appointmentId});

      Response response = await ApiClient().dio.post(Constant.appointmentDetail,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      setState(() {
        appointmentDetailModel = AppointmentDetailModel.fromJson(response.data);

        setState(() {
          if (widget.getAppointmentsModel != null) {
            if (widget.getAppointmentsModel!.amount != null) {
              itemprice = itemprice +
                  (double.parse(
                      "${widget.getAppointmentsModel?.amount?.replaceAll(",", "")}"));
            }
          }
          if (appointmentDetailModel != null) {
            if (appointmentDetailModel!.data != null) {
              if (appointmentDetailModel!.data!.additionalCharges != null) {
                for (int i = 0;
                    i < appointmentDetailModel!.data!.additionalCharges!.length;
                    i++) {
                  chargesPrice = chargesPrice +
                      (double.parse(
                          "${appointmentDetailModel?.data?.additionalCharges?[i].price?.replaceAll(",", "")}"));
                }
              }
            }
          }
          total = itemprice + chargesPrice;
        });
      });

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
    // TODO: implement initState
    super.initState();
    appoitmanDetails();
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            body: appointmentDetailModel?.data == null
                ? Center(
                    child: CircularProgressIndicator(
                      color: CustomTheme.primarycolor,
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                          SizedBox(height: Height / 70),
                          appointmentDetailModel?.data?.vendorName == null
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ))
                              : Text(
                                  "${appointmentDetailModel?.data?.vendorName}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: CustomTheme.body4),
                          SizedBox(height: Height / 20),
                          Text("Your Invoice:", style: CustomTheme.body4),
                          SizedBox(height: Height / 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Item name", style: CustomTheme.body2),
                              // Spacer(),
                              // Text("QTY", style: CustomTheme.body2),
                              Spacer(),
                              Text("Item Amount", style: CustomTheme.body2),
                              Spacer(),
                              Text("Price", style: CustomTheme.body2)
                            ],
                          ),
                          SizedBox(height: Height / 30),
                          Container(
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            "${widget.getAppointmentsModel?.servicesName}",
                                            style: CustomTheme.textStyle),
                                      ),
                                      Spacer(),
                                      Text(
                                          "${widget.getAppointmentsModel?.amount}",
                                          style: CustomTheme.textStyle),
                                      Spacer(),
                                      Text(
                                          "${widget.getAppointmentsModel?.amount}",
                                          style: CustomTheme.textStyle)
                                    ],
                                  ))),
                          SizedBox(height: Height / 30),
                          Divider(thickness: 2, color: CustomTheme.black),
                          SizedBox(height: Height / 24),
                          appointmentDetailModel
                                      ?.data?.additionalCharges?.length ==
                                  0
                              ? Center(child: Text(" "))
                              : Visibility(
                                  visible: true,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Additional Charges :",
                                          style: CustomTheme.body4),
                                      SizedBox(height: Height / 24),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Item name",
                                              style: CustomTheme.body2),
                                          Spacer(),
                                          Text("Price",
                                              style: CustomTheme.body2)
                                        ],
                                      ),
                                      SizedBox(height: Height / 24),
                                      Container(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: appointmentDetailModel
                                                        ?.data
                                                        ?.additionalCharges !=
                                                    null
                                                ? appointmentDetailModel?.data
                                                    ?.additionalCharges?.length
                                                : 0,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Column(children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "${appointmentDetailModel?.data?.additionalCharges?[index].name}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                CustomTheme
                                                                    .fontFamily,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    //Spacer(),
                                                    Text(
                                                        "${appointmentDetailModel?.data?.additionalCharges?[index].price}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                CustomTheme
                                                                    .fontFamily,
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ]);
                                            }),
                                      ),
                                      SizedBox(height: Height / 30),
                                      Divider(
                                          thickness: 2,
                                          color: CustomTheme.black),
                                      SizedBox(height: Height / 30),
                                    ],
                                  )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total", style: CustomTheme.body4),
                              // Spacer(),
                              Text("RM " + "$total", style: CustomTheme.body4),
                            ],
                          ),
                          SizedBox(
                            height: Height / 8,
                          ),
                          Builder(
                            builder: (context) {
                              final GlobalKey<SlideActionState> _key =
                                  GlobalKey();
                              return SlideAction(
                                elevation: 0,
                                sliderButtonIconSize: 16,
                                height: 60,
                                text: "Swipe to pay",
                                textStyle: CustomTheme.body3,
                                key: _key,
                                onSubmit: () {
                                  Future.delayed(
                                    Duration(seconds: 1),
                                    () => _key.currentState?.reset(),
                                  );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChoosePaymentMethodSCreen(
                                                getAppointmentsModel:
                                                    widget.getAppointmentsModel,
                                                appointmentDetailModel:
                                                    appointmentDetailModel
                                                        ?.data,
                                                totalprice: total,
                                              )));
                                },
                                innerColor: CustomTheme.black,
                                outerColor: CustomTheme.yellow,
                              );
                            },
                          ),
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
      ],
    );
  }
}
