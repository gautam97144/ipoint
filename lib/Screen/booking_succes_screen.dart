import 'package:flutter/material.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:provider/provider.dart';

import 'booking_page.dart';
import 'no_internet_screen.dart';

class BookingSuccesScreen extends StatefulWidget {
  String? appointmentid;
  BookingSuccesScreen({
    Key? key,
    this.appointmentid,
  }) : super(key: key);

  @override
  _BookingSuccesScreenState createState() => _BookingSuccesScreenState();
}

class _BookingSuccesScreenState extends State<BookingSuccesScreen> {
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () {
                                // Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BookingPage(
                                            deleteid: widget.appointmentid)));
                              },
                              child: Icon(Icons.clear,
                                  size: 30, color: CustomTheme.white)),
                        ],
                      ),
                      SizedBox(height: Height / 4),
                      Image.asset(Images.check, scale: 4),
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
