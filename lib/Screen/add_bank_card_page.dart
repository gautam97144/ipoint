import 'package:flutter/material.dart';
import 'package:ipoint/Screen/addCard_detail.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:provider/provider.dart';

import 'no_internet_screen.dart';

class AddBankCardPage extends StatefulWidget {
  const AddBankCardPage({Key? key}) : super(key: key);

  @override
  _AddBankCardPageState createState() => _AddBankCardPageState();
}

class _AddBankCardPageState extends State<AddBankCardPage> {
  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
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
                                      height: 15,
                                    ),
                                    Text("Payment Method",
                                        style: CustomTheme.title),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Height / 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              opaque: false,
                              fullscreenDialog: true,
                              pageBuilder: (BuildContext context, _, __) =>
                                  AddCardDetail()));
                        },
                        child: Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: CustomTheme.primarycolor,
                            child: Image.asset(
                              Images.addIcon,
                              scale: 2.8,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Height / 50,
                      ),
                      Center(
                        child: Text("Add your bank card",
                            style: CustomTheme.body2),
                      ),
                      Center(
                        child: Text("here.", style: CustomTheme.body2),
                      ),
                      SizedBox(
                        height: Height / 5,
                      ),
                      Text(
                        "You only can add one card at a time. This is to ensure the cashback process is without much difficulties.",
                        style: CustomTheme.title4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Provider.of<InternetConnectivityCheck>(context, listen: true)
                .isNoInternet
            ? NoInterNetScreen()
            : SizedBox.shrink()
      ],
    );
  }
}
