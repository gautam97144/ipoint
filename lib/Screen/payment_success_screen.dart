import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/bottom_navigation.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/extension/extension.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/model/commonmodel.dart';
import 'package:ipoint/model/payment_detail_model.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentSuccessScreen extends StatefulWidget {
  String? paymentIntent;
  String? appointmentId;
  String? amount;
  PaymentSuccessScreen(
      {Key? key, this.paymentIntent, this.appointmentId, this.amount})
      : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

enum Status { sales, failed }

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  ReadPayment? readPayment;
  var newDate;
  CommonModel? commonModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.paymentIntent);
    paymentDetail();
  }

  Future onlinePay() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    try {
      FormData data = FormData.fromMap({
        "appointment_id": widget.appointmentId,
        "amount": widget.amount,
        "payment_type": 2,
        "online_pay_response_id": ""
      });

      Response response = await ApiClient().dio.post(Constant.invoicePayOnline,
          data: data,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.data != null) {
        if (response.statusCode == 200) {
          commonModel = CommonModel.fromJson(response.data);
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  Future paymentDetail() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('paymentToken');

      Response response = await ApiClient().dio.get(
          "https://sandbox-payexapi.azurewebsites.net/api/v1/Transactions",
          queryParameters: {"payment_intent": widget.paymentIntent},
          options: Options(headers: {"Authorization": "Bearer $token"}));

      print(response.data);

      if (response.data != null) {
        if (response.statusCode == 200) {
          setState(() {
            readPayment = ReadPayment.fromJson(response.data);
          });

          if (readPayment?.status == "00") {
            if (readPayment?.result?[0].status != "Failed") {
              await onlinePay();
            }
          }
        } else {
          print("something went wrong");
        }
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  getFormatedDate(date) {
    var inputFormat = DateFormat('yyyyMMdd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('d MMM y');
    newDate = outputFormat.format(inputDate);
    print(newDate);
    return newDate;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation()),
            (route) => false);
      },
      child: Scaffold(
        body: SafeArea(
          child: readPayment?.result == null
              ? Center(
                  child: CircularProgressIndicator(
                  color: CustomTheme.primarycolor,
                ))
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        readPayment?.result?[0].status == "Failed"
                            ? Text(
                                "Transaction Failed",
                                style: CustomTheme.body1
                                    .copyWith(color: Colors.red, fontSize: 25),
                              )
                            : Text("Transaction Successful",
                                style: CustomTheme.body1.copyWith(
                                    color: Colors.green, fontSize: 25)),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border(
                                top: BorderSide(color: CustomTheme.black),
                                bottom: BorderSide(color: CustomTheme.black),
                                left: BorderSide(color: CustomTheme.black),
                                right: BorderSide(color: CustomTheme.black),
                              )),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Transaction Summary",
                                    style: CustomTheme.body1
                                        .copyWith(fontSize: 16),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Transaction Date :",
                                    style: CustomTheme.body1
                                        .copyWith(fontSize: 14),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${readPayment?.result?[0].txnDate!.getDateFormat()}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Transaction Id :",
                                    style: CustomTheme.body1
                                        .copyWith(fontSize: 14),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${readPayment?.result?[0].txnId ?? ""}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Amount :",
                                    style: CustomTheme.body1
                                        .copyWith(fontSize: 14),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${readPayment?.result?[0].amount ?? ""}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Status :",
                                    style: CustomTheme.body1
                                        .copyWith(fontSize: 14),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${readPayment?.result?[0].response ?? ""}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    readPayment?.result?[0].status == "Failed"
                                        ? Colors.red
                                        : Colors.green,
                                child: Icon(
                                  readPayment?.result?[0].status == "Failed"
                                      ? Icons.clear
                                      : Icons.check,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                      ]),
                ),
        ),
      ),
    );
  }
}
