import 'package:flutter/material.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:provider/provider.dart';

import 'no_internet_screen.dart';

class CopyLinkScreen extends StatefulWidget {
  const CopyLinkScreen({Key? key}) : super(key: key);

  @override
  _CopyLinkScreenState createState() => _CopyLinkScreenState();
}

class _CopyLinkScreenState extends State<CopyLinkScreen> {
  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent.withOpacity(.7),
            body: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 12),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.clear,
                                size: 30, color: CustomTheme.white)),
                      ],
                    ),
                    SizedBox(height: Height / 4),
                    Container(
                      height: Height / 3.5,
                      width: Width / 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: CustomTheme.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 24),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Please use this link to gain points for your referral.",
                                style: CustomTheme.body3,
                              ),
                            ),
                            SizedBox(height: Height / 30),

                            SizedBox(height: Height / 30),
                            Container(
                              height: Height / 24,
                              width: Width / 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                color: CustomTheme.yellow,
                              ),
                              child: TextButton(
                                onPressed: () {},
                                child:
                                    Text("Copy Link", style: CustomTheme.body2),
                              ),
                            )
                          ],
                        ),
                      ),
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
