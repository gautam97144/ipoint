import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/model/payment_detail_model.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_navigation.dart';

class PaymentFailed extends StatefulWidget {
  String? paymentIntent;
  PaymentFailed({Key? key, this.paymentIntent}) : super(key: key);

  @override
  State<PaymentFailed> createState() => _PaymentFailedState();
}

class _PaymentFailedState extends State<PaymentFailed> {
  ReadPayment? readPayment;

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
            print(readPayment);
          }
        } else {
          print("something went wrong");
        }
      }
    } on DioError catch (e) {
      print(e);
    }
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
                        Text(
                          "Payment Unsuccessful !",
                          style: CustomTheme.body1
                              .copyWith(color: Colors.green, fontSize: 25),
                        ),
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
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Transaction Date :",
                                    style: CustomTheme.body1
                                        .copyWith(fontSize: 14),
                                  ),
                                  Text(
                                      "${readPayment?.result?[0].txnDate ?? ""}"),
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
                                  Text("${readPayment?.result?[0].txnId ?? ""}")
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
                                  Text(
                                      "${readPayment?.result?[0].amount ?? ""}"),
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
                                  Text(
                                      "${readPayment?.result?[0].response ?? ""}"),
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.clear,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer()
                            ],
                          ),
                        )
                      ]),
                ),

          // Center(
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 25),
          //     child: Container(
          //       height: 100,
          //       decoration:
          //           BoxDecoration(borderRadius: BorderRadius.circular(10)),
          //       child: Text(
          //         "Payment Failed !",
          //         style:
          //             CustomTheme.body1.copyWith(color: Colors.red, fontSize: 25),
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
