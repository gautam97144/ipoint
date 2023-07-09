import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/model/cashback_model.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'no_internet_screen.dart';

class CashBackPage extends StatefulWidget {
  const CashBackPage({Key? key}) : super(key: key);

  @override
  _CashBackPageState createState() => _CashBackPageState();
}

class _CashBackPageState extends State<CashBackPage> {
  CashbackModel? cashback;
  var newDate;
  //int? index;
  // var inputFormat = DateFormat("yMMMMd");
  // var time = inputFormat.parse()

// <-- dd/MM 24H format

  @override
  void initState() {
    super.initState();
    fetchCashbackList();
  }

  getFormatedDate(date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('d MMM y');
    newDate = outputFormat.format(inputDate);
    return newDate;
  }

  Future fetchCashbackList() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      Response response = await ApiClient().dio.post(
            Constant.cashbackList,
            options: Options(headers: {"Authorization": "Bearer $token"}),
          );

      if (response.data != null) {
        if (response.statusCode == 200) {
          print(response.data);
        }

        if (mounted) {
          setState(() {
            cashback = CashbackModel.fromJson(response.data);
          });
        }

        if (cashback?.success == 1) {
          print(cashback?.data);
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var hight = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stack(
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
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "<Back",
                          style: CustomTheme.body3,
                        ),
                      ),
                      // Text('Help?'),
                    ],
                  ),
                  SizedBox(
                    height: hight / 50,
                  ),
                  Text("Cashback", style: CustomTheme.title),
                  SizedBox(height: hight / 20),
                  Expanded(
                    child: Scrollbar(
                      child: cashback?.data == null
                          ? Center(
                              child: CircularProgressIndicator(
                                color: CustomTheme.primarycolor,
                              ),
                            )
                          : cashback?.data?.length == 0 || cashback?.data == []
                              ? Center(
                                  child: Text(
                                    "No any record",
                                    style: CustomTheme.body1,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: cashback?.data != null
                                      ? cashback?.data?.length
                                      : 0,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    getFormatedDate(
                                        cashback?.data?[index].createdAt);
                                    return Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 7),
                                          padding: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${cashback?.data?[index].points ?? ""}",
                                                  style: CustomTheme.title2),
                                              Spacer(),
                                              Text('cashback on ',
                                                  style: CustomTheme.italic),
                                              Text(
                                                newDate,
                                                style: CustomTheme.title2,
                                              )
                                            ],
                                          ),
                                          height: hight / 16,
                                          width: width / 1,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: CustomTheme.primarycolor),
                                        ),
                                        SizedBox(height: hight / 40)
                                      ],
                                    );
                                  }),
                    ),
                  ),
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
}
