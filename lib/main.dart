import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipoint/Screen/agent_redeem_screen.dart';
import 'package:ipoint/Screen/service_provider.dart';
import 'package:ipoint/Screen/splash_screen.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/provider/image_provider.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/provider/location_provider.dart';
import 'package:ipoint/provider/one_check_internet_connectivity.dart';
import 'package:ipoint/provider/point_update_provide.dart';
import 'package:ipoint/provider/username_provider.dart';
import 'package:provider/provider.dart';

import 'Screen/new_update_screen.dart';
import 'Screen/services_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: CustomTheme.primarycolor,
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => InvoicePoint(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImageProfile(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
        ),
        ChangeNotifierProvider(
            create: (context) => InternetConnectivityCheck()),
        ChangeNotifierProvider(
          create: (context) => InternetConnectivityCheckOneTime(),
        ),
      ],
      child: MaterialApp(
          // theme: ThemeData(primaryColor: CustomTheme.primarycolor),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: CustomTheme.primarycolor,
              //accentColor: Colors.greenAccent,
              timePickerTheme: TimePickerThemeData(
                backgroundColor: CustomTheme.white,
                hourMinuteTextColor: CustomTheme.primarycolor,
                dialHandColor: CustomTheme.primarycolor,
                dayPeriodTextColor: CustomTheme.primarycolor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                hourMinuteShape: CircleBorder(),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: CustomTheme.primarycolor,
                  elevation: 0,
                ),
              )),
          home: SplashScreen()),
    );
  }
}
