import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipoint/Screen/splash_screen.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/provider/one_check_internet_connectivity.dart';
import 'package:provider/provider.dart';

class NoInterNetScreen extends StatefulWidget {
  const NoInterNetScreen({Key? key}) : super(key: key);

  @override
  _NoInterNetScreenState createState() => _NoInterNetScreenState();
}

class _NoInterNetScreenState extends State<NoInterNetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 200, height: 200, child: Image.asset(Images.noDataImage)),
          Center(
            child: Text(
              'No Internet !\nPlease Check Your Internet Connection.',
              textAlign: TextAlign.center,
              style: CustomTheme.body3.copyWith(fontSize: 15),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CupertinoButton(
            color: CustomTheme.primarycolor,
            child: Text(
              "Retry",
              style: CustomTheme.body1.copyWith(fontSize: 16),
            ),
            onPressed: () async {
              await Provider.of<InternetConnectivityCheckOneTime>(context,
                      listen: false)
                  .checkOneTimeConnectivity();

              if (!Provider.of<InternetConnectivityCheckOneTime>(context,
                      listen: false)
                  .isOneTimeInternet) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                    (route) => false);
              }
            },
          )
        ],
      ),
    );
  }
}
