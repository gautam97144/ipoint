import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/help_center_model.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'no_internet_screen.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({Key? key}) : super(key: key);

  @override
  _HelpCenterState createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  TextEditingController controller = TextEditingController();
  HelpCenterModel? helpCenter;
  bool is_loading = false;

  Future issueSubmit() async {
    FormData formData = FormData.fromMap({
      "message": controller.text,
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    try {
      Response response = await ApiClient().dio.post(Constant.addHelp,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          data: formData);

      helpCenter = HelpCenterModel.fromJson(response.data);

      if (response.statusCode == 200) {
        print(response.data);

        if (helpCenter?.success == 1) {
          Fluttertoast.showToast(msg: "Submit Successfully");
        } else {
          Fluttertoast.showToast(msg: "${helpCenter?.message}");
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(children: [
        SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
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
                        ],
                      ),
                      SizedBox(height: height / 50),
                      Text("Help Center", style: CustomTheme.title),
                      SizedBox(height: height / 16),
                      Text(
                        "Let us know your issue. We will get back to you within 2 working days.",
                        style: CustomTheme.body1.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            fontFamily: CustomTheme.fontFamily),
                      ),
                      SizedBox(height: height / 30),
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(
                            left: width / 30, right: width / 30),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: CustomTheme.offwhite.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          cursorColor: CustomTheme.primarycolor,
                          controller: controller,
                          maxLines: 10,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Writing your issue here.',
                            hintStyle: CustomTheme.title4,
                          ),
                        ),
                      ),
                      SizedBox(height: height / 17),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.yellow,
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: () async {
                              setState(() {
                                is_loading = true;
                              });
                              await issueSubmit().whenComplete(() {
                                controller.clear();
                              });
                              setState(() {
                                is_loading = false;
                              });
                            },
                            child: Text(
                              "Submit",
                              style: CustomTheme.body3,
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
        Provider.of<InternetConnectivityCheck>(context, listen: true)
                .isNoInternet
            ? NoInterNetScreen()
            : SizedBox.shrink(),
        is_loading ? LoaderLayoutWidget() : SizedBox.shrink()
      ]),
    );
  }
}
