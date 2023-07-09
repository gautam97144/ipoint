import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/payment_history_page.dart';
import 'package:ipoint/Screen/webview_screen.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/appointmant_detaile_model.dart';
import 'package:ipoint/model/get_appoitment_model.dart';
import 'package:ipoint/model/invoice_pay_model.dart';
import 'package:ipoint/model/payment_model.dart';
import 'package:ipoint/model/payment_token_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'menu_page.dart';
import 'no_internet_screen.dart';

class ChoosePaymentMethodSCreen extends StatefulWidget {
  AppointmentData? getAppointmentsModel;
  AppointmentDetailData? appointmentDetailModel;
  double? totalprice;
  ChoosePaymentMethodSCreen(
      {Key? key,
      this.getAppointmentsModel,
      this.appointmentDetailModel,
      this.totalprice})
      : super(key: key);

  @override
  _ChoosePaymentMethodSCreenState createState() =>
      _ChoosePaymentMethodSCreenState();
}

class _ChoosePaymentMethodSCreenState extends State<ChoosePaymentMethodSCreen> {
  UserModel? userModel;
  InvoicePayModel? invoicePayModel;
  Token? paymentToken;

//success
  //https://sandbox-payexapi.azurewebsites.net/Payment/Return?ZjAwMV9NSUQ9MDAwMDAwMDAwMDEwMjEwJmYyNjBfU2VydklEPVVNJmYyNjNfTVJOPVBYMTAwMDAxNGU1NDY4ODkwZTY4JmVuY3J5cHRlZERhdGE9cTdDRFpoSm1KTjRKMnJ1SmVuT21UdTZkYk15aUFSeGZ3NGNDRE4weWZMdGhmMzN3Y2RrOFNwdUVEOU01NnpnalY1WHRMYUZPaWxLaVFGWTJtckZYdHNuUXdxblhrYmNvaFRPR1FNSzhTZlBER1N5RElJSmNSbEVRNlh2UDdFTkRpWmNwRlNOcnpjbzI0eVZ0ZVEyMjNBVU12TmhsaU1yUDk0blEzdklxd2RyTUN5S0FIZ0dSVFQ5Njk0VzljcWZPNW5LVG5YNkNpbU5ZazNLN2hXWm9KMEtzREZJZXdXTHpwU3lpVElybFZOcXBjODVYdm9EakVUUFU4dS05SlNLQ083QjBZb0t2emMyUEZuRDVScXFkY2NzbHhKbE5HaEVOLWxDaE9mZU5GTGpnRjhwR1pFbG44RzN1c1hUdHhFMEN4Ymg3TEJxN2xrQ1hRZ3FJVDZWNHlwU05rZ2p0X2Y3UGlvRUE4TFl3RkQwdktleXJHUHhCbEhLWUtMRlFpMFIzWGFzNjBITDc3LXI4V2Fab2hOX2hRUURLYlN6c3NmM1lKOWdCb19aNVZOWjlwRW5RMnVXWmUwaGQxTmxNUmhDTmZfNUl3eXFISVU0dE9RRDBNUDhBbEt1VnRaeXBXNmVHWFNDNG5GLXlFcGQ3cVZXb2pEUV9hdWs1QS1RUW10b3JuSmZwYjhEVktCTmFSdFFRbzNXakpwZGcyV2pramhoWXlLUkhWWDQ3TnRhZXU2WUtWSzlaMkVkV20zVkhYVWdlV2xEalpiX19raUdMdGhNVnRZUFFESmNxYnJmZ3A0TXRqN29VZ0ZLa245WmR1X0ZnLWRnQWdFZzdQLXdDN0RqakNjWTl0cDZWUjdpV1BycnFNb1ctdEhNb1k1MEkzbWU5cXZDWHlrNUhNaFdGel9KRlBqVXVDWDhQYkRObW1OR0liQkJseUloNW9GZm1RUmh0aXFMWjFnOWI0Skw0aTZEZmtMVUR4ZFVUaXk5RWZqcEVYemVVMzgzbVc2a1Q4cHRZdk5DY0V6NzdYMVM1dnU2emg5clZHd1puRngwY3NiWjlkOC1UTXZHS29CUXh0R2VwU3NGZmZZbHBjc1hYNy1pRlEzUHpuaG02Y3FYMEFBTGdRVXpjTmVyZFpfZE4tbk4xZXdFdl9wY3g3QWlVOGQ5blZtSU8zNUdDdlVvenUtaTlJUlJZdFNTbWV4bzdIOW9iVkRmQWlwelRTSU5LQ25UN2NaZFdTbzBpeDFtUE81d3pXSVNFTWhKeE93MGl2MENVQlpxTkcxOW91Z29kTEthTGVmZUE4M2l6Vm9STFIxdGl1MzNxR3NPTVlaa09SMGRkZThqR0hucWhWZ3VTR0kzVHAzMVNLektKUmozYmxJdUx5V19BUzdmN29pODVSclUyVnp6N3YtSC1xM091VHBNVzZKM2lfZzlvZ3Joc09RZFllT2RBZW54OE5HTDZBLTNldmhxQW1tamlhNFZYckpvJml2PTIwZWJmZjhhNDc5MjlhZWFmNmFjMGM2NjQzOGZkMjNiNDM4ODQyMjMwZGYzMDI1MjlhNzA1Njk5YzM1ODA4OWY

  String? point;
  int? payment_type = 0;
  bool is_loading = false;
  bool is_fpx = false;
  bool is_ewallet = false;
  File? image;
  bool is_ipoint = true;
  Payment? payment;
  bool isWebviewOpen = false;
  var formatter = NumberFormat('#,##,000');

  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    setState(() {});
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());
    setState(() {
      userModel = UserModel.fromJson(jsondecode);
    });
  }

  setmodel(value) async {
    String data = jsonEncode(value);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("invoice", data);
  }

  Future invoicePay(int mode) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData = FormData.fromMap({
        "appointment_id": "${widget.getAppointmentsModel?.appointmentId}",
        "amount": "${widget.totalprice}",
        "payment_type": mode
      });
      Response response = await ApiClient().dio.post(Constant.invoicePay,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      setState(() {
        invoicePayModel = InvoicePayModel.fromJson(response.data);
        userModel?.data?.ipointWallet = invoicePayModel?.data?.ipointWallet;
        setmodel(userModel);
      });

      if (response.statusCode == 200) {
        print(response.data);

        if (invoicePayModel?.success == 1) {
          Fluttertoast.showToast(msg: '${invoicePayModel?.message}');

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PaymentHistoryPage(paymentType: 0, status: 1)));
        }
      } else {
        Fluttertoast.showToast(msg: '${invoicePayModel?.message}');
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  tokenAuth() async {
    await tokenRequest();
  }

  Future paymentRequest() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('paymentToken');
      print("new token" + token.toString());

      //
      print(widget.totalprice);
      print(invoicePayModel?.data?.amount);
      var newAmount = widget.totalprice! * 100;
      print(newAmount.toInt().toString() + ";;;;;;");

      var formData = [
        {
          "amount": "${newAmount.toInt()}",
          "currency": "MYR",
          "collection_id": 123,
          "capture": true,
          "customer_name": "${userModel?.data?.name}",
          "email": "${userModel?.data?.email}",
          "contact_number": "${userModel?.data?.mobile}",
          "address": "${userModel?.data?.location}"
          // "reject_url": "https://www.vocabulary.com/dictionary/rejected"
        }
      ];

      print(formData);

      Response response = await ApiClient().dio.post(
          "https://sandbox-payexapi.azurewebsites.net/api/v1/PaymentIntents",
          data: jsonEncode(formData),
          //queryParameters: jsonEncode(formData),
          options: Options(
              //  contentType: "application/json",
              headers: {"Authorization": "Bearer $token"}));

      // setState(() {
      //   invoicePayModel = InvoicePayModel.fromJson(response.data);
      //   userModel?.data?.ipointWallet = invoicePayModel?.data?.ipointWallet;
      //   setmodel(userModel);
      // });
      if (response.statusCode == 200) {
        print(response.data);

        payment = Payment.fromJson(response.data);

        print(response.data);

        if (payment?.status == "00") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyAppWebView(
                      amount: widget.getAppointmentsModel?.amount,
                      appointmentId: widget.getAppointmentsModel?.appointmentId,
                      paymentIntent: payment?.result?[0].key,
                      url: payment?.result?[0].url)));
        } else {
          Fluttertoast.showToast(msg: 'Something went wrong!Try again');
        }

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => PaymentHistoryPage(payment_type: 0)
        //     )

      } else {}
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  Future tokenRequest() async {
    try {
      String username = "merchantdemo02@payex.io";
      String password = "zjm7Suz9ep7OA1R3Cdw8n9JafRzzfiIT";

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));

      Response response = await ApiClient().dio.post(
          "https://sandbox-payexapi.azurewebsites.net/api/Auth/Token",
          //data: jsonEncode(formData),
          //queryParameters: jsonEncode(formData),
          options: Options(
              contentType: "application/json",
              headers: {"Authorization": basicAuth}));

      if (response.statusCode == 200) {
        print(response.data);

        paymentToken = Token.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getModel();
    tokenRequest();
    // invoicePay(1);
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
                body: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "<Back",
                                  style: CustomTheme.body3,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Height / 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                            // "${Provider.of<UsernameProvider>(context, listen: false).userModel?.data?.name}",
                                            maxLines: 2,
                                            style: CustomTheme.body3.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(minHeight: 50),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                width: Width / 3,
                                decoration: BoxDecoration(
                                  color: CustomTheme.primarycolor,
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: IntrinsicWidth(
                                          child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                            Numeral(double.parse(
                                                    "${userModel?.data?.ipointWallet ?? "0"}"))
                                                .value(),
                                            //"${userModel?.data?.ipointWallet}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: CustomTheme.body3.copyWith(
                                                fontWeight: FontWeight.w700)),
                                      )),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        " pts",
                                        style: CustomTheme.body1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              CustomProfilePicture(
                                  url: userModel?.data?.profile ?? "")
                            ],
                          ),
                          SizedBox(height: Height / 30),
                          Text(
                              "${widget.appointmentDetailModel?.vendorName ?? ""}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTheme.body5.copyWith(fontSize: 16)),
                          SizedBox(height: Height / 24),
                          Text("Choose your payment method.",
                              style: CustomTheme.body4),
                          SizedBox(height: Height / 20),
                          Row(
                            children: [
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    is_ipoint = true;
                                    is_fpx = false;
                                  });
                                },
                                child: Container(
                                  height: Height / 6,
                                  width: Width / 3.5,
                                  decoration: BoxDecoration(
                                    border: is_ipoint == true
                                        ? Border(
                                            left: BorderSide(
                                                color:
                                                    CustomTheme.primarycolor),
                                            right: BorderSide(
                                                color:
                                                    CustomTheme.primarycolor),
                                            top: BorderSide(
                                                color:
                                                    CustomTheme.primarycolor),
                                            bottom: BorderSide(
                                                color:
                                                    CustomTheme.primarycolor),
                                          )
                                        : Border(
                                            left: BorderSide(
                                                color: CustomTheme.white),
                                            right: BorderSide(
                                                color: CustomTheme.white),
                                            top: BorderSide(
                                                color: CustomTheme.white),
                                            bottom: BorderSide(
                                                color: CustomTheme.white),
                                          ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 2.9,
                                        spreadRadius: 1.0,
                                        offset: Offset(4.0, 4.0),
                                      ),
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          blurRadius: 5.0,
                                          spreadRadius: 2.0,
                                          offset: Offset(6.0, 6.0))
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(children: [
                                    SizedBox(height: Height / 30),
                                    Image.asset(Images.iPointsIcon, scale: 2),
                                    SizedBox(height: Height / 70),
                                    Text(
                                      "iPoints",
                                      style: CustomTheme.body1,
                                    ),
                                  ]),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  // Uri uri =
                                  //     Uri.parse("${payment?.result?[0].url}");
                                  //
                                  // await openBrowserUrl(url: uri);
                                  setState(() {
                                    is_fpx = true;
                                    is_ipoint = false;
                                  });
                                },
                                child: Container(
                                  height: Height / 6,
                                  width: Width / 3.5,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 2.9,
                                        spreadRadius: 1.0,
                                        offset: Offset(4.0, 4.0),
                                      ),
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          blurRadius: 5.0,
                                          spreadRadius: 2.0,
                                          offset: Offset(6.0, 6.0))
                                    ],
                                    border: is_fpx == true
                                        ? Border(
                                            left: BorderSide(
                                                color:
                                                    CustomTheme.primarycolor),
                                            right: BorderSide(
                                                color:
                                                    CustomTheme.primarycolor),
                                            top: BorderSide(
                                                color:
                                                    CustomTheme.primarycolor),
                                            bottom: BorderSide(
                                                color:
                                                    CustomTheme.primarycolor),
                                          )
                                        : Border(
                                            left: BorderSide(
                                                color: CustomTheme.white),
                                            right: BorderSide(
                                                color: CustomTheme.white),
                                            top: BorderSide(
                                                color: CustomTheme.white),
                                            bottom: BorderSide(
                                                color: CustomTheme.white),
                                          ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(children: [
                                    SizedBox(height: Height / 20),
                                    Image.asset(Images.fpxImg, scale: 2),
                                    SizedBox(height: Height / 35),
                                    Text(
                                      "Online Banking",
                                      style: CustomTheme.body1,
                                    ),
                                  ]),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                          SizedBox(height: Height / 24),
                          Center(child: Text("OR", style: CustomTheme.body3)),
                          SizedBox(height: Height / 24),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: CustomTheme.primarycolor),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(
                                            Images.debitCodeIcon,
                                            scale: 3,
                                          ),
                                          Image.asset(
                                            Images.debitCircleIcon,
                                            scale: 3,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Height / 40,
                                      ),
                                      Text(
                                        "XXX   XXX   XXX   5311",
                                        style: CustomTheme.body2,
                                      ),
                                      SizedBox(
                                        height: Height / 60,
                                      ),
                                      Text(
                                        "JOHN DOE",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: CustomTheme.fontFamily,
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: Height / 40,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "VALID THRU",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontFamily:
                                                    CustomTheme.fontFamily,
                                                fontSize: 10),
                                          ),
                                          SizedBox(
                                            width: Width / 40,
                                          ),
                                          Text(
                                            "10/30",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    CustomTheme.fontFamily,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))),
                          Expanded(child: SizedBox(height: Height / 24)),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.yellow)),
                              onPressed: () async {
                                if (is_fpx == true) {
                                  setState(() {
                                    is_loading = true;
                                  });

                                  await paymentRequest();

                                  setState(() {
                                    is_loading = false;
                                  });

                                  // WebView(
                                  //   initialUrl: "${payment?.result?[0].url}",
                                  //   onPageFinished: (String url) {
                                  //     bool isSuccess = url.contains("Error");
                                  //
                                  //     if (isSuccess) {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   ChoosePaymentMethodSCreen()));
                                  //     }
                                  //   },
                                  //   onPageStarted: (String url) {
                                  //     bool isSuccess = url.contains("Error");
                                  //   },
                                  // );

                                  //isWebviewOpen = true;
                                  //   Uri uri =
                                  //       Uri.parse("${payment?.result?[0].url}");
                                  //
                                  //   await openBrowserUrl(url: uri);
                                } else {
                                  if (userModel!.data!.ipointWallet != null) {
                                    if (double.parse(
                                            userModel!.data!.ipointWallet!) <
                                        widget.totalprice!) {
                                      _showMyDialog();
                                    } else {
                                      setState(() {
                                        is_loading = true;
                                        FocusScope.of(context).unfocus();
                                      });

                                      await invoicePay(1);

                                      setState(() {
                                        is_loading = false;
                                      });
                                    }
                                  }
                                }
                              },
                              child: Text(
                                "Proceed",
                                style: CustomTheme.body2,
                              ),
                            ),
                          ),
                        ])),
              ),
            ),
            Provider.of<InternetConnectivityCheck>(context, listen: true)
                    .isNoInternet
                ? NoInterNetScreen()
                : SizedBox.shrink(),
            is_loading ? LoaderLayoutWidget() : SizedBox.shrink(),
            // isWebviewOpen == true
            //     ?
            //     : SizedBox.shrink()
          ],
        ));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Warning',
            style: CustomTheme.body4,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("You have insufficient ipoint!",
                    style: CustomTheme.textStyle.copyWith(fontSize: 15)),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'ok',
                style: TextStyle(color: CustomTheme.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future openBrowserUrl({required Uri url, bool inApp = true}) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  // return showDialog<void>(
  // context: context,
  // barrierDismissible:
  // false, // user must tap button!
  // builder: (BuildContext context) {
  // return AlertDialog(
  // title: Text(
  // 'Warning',
  // style: CustomTheme.body4,
  // ),
  // content: SingleChildScrollView(
  // child: ListBody(
  // children: [
  // Text(
  // 'You have insufficient ipoint!',
  // style: CustomTheme.textStyle
  //     .copyWith(fontSize: 15)),
  // ],
  // ),
  // ),
  // actions: [
  // TextButton(
  // child: Text('ok',
  // style: CustomTheme.body1),
  // onPressed: () {
  // Navigator.pop(context);
  // },
  // ),
  // ],
  // );
  // },
  // );
}
