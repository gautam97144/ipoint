import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipoint/Screen/sign_up_profile.dart';
import 'package:ipoint/Screen/googlemap.dart';
import 'package:ipoint/Widget/custom_blue_button.dart';
import 'package:ipoint/Widget/custom_text_field.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/provider/location_provider.dart';
import 'package:provider/provider.dart';

import 'no_internet_screen.dart';

class SignUp extends StatefulWidget {
  SignUp({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //variable

  bool islocvalidation = false;
  bool isMrs = true;
  bool isMiss = false;
  bool isMirs = false;
  bool nameError = false;
  bool doberror = false;
  String prifixname = 'Mr';
  String? date;
  String? name;
  DateTime selectedDate = DateTime.now();
  String ddmmyy = 'YYYY-MM-DD';
  String? location;
  bool filled = false;
  bool map = false;
  bool checkDobvalidation = false;

  String? address;
  bool? is_loc_selected = false;
  String? currentlat;
  String? currentlong;

  final _formkey = GlobalKey<FormState>();

  //controller

  TextEditingController namecontroller = TextEditingController();
  TextEditingController yearcontroller = TextEditingController();
  TextEditingController monthcontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkRealTime();
  }

  checkRealTime() {
    Provider.of<InternetConnectivityCheck>(context, listen: false)
        .checkRealTimeConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Form(
                key: _formkey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "<Back",
                                style: CustomTheme.body2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Container(
                          height: height / 10,
                          width: width / 2.6,
                          child: Image.asset(Images.splashIpoint),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isMirs = false;
                                isMiss = false;
                                isMrs = !isMrs;
                                prifixname = "Mr";
                              });
                            },
                            child: Container(
                              child: Text('Mr', style: CustomTheme.body2),
                              alignment: Alignment.center,
                              width: width / 4,
                              height: height / 14,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: CustomTheme.shadowcolor1
                                            .withOpacity(0.2),
                                        blurRadius: 7.0,
                                        spreadRadius: 3.0,
                                        offset: Offset(3.0, 3.0))
                                  ],
                                  color: isMrs == false
                                      ? CustomTheme.white
                                      : CustomTheme.primarycolor),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isMirs = false;
                                isMrs = false;
                                isMiss = !isMiss;
                                prifixname = "Miss";
                              });
                            },
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Miss',
                                  style: CustomTheme.body2,
                                ),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: CustomTheme.shadowcolor1
                                              .withOpacity(0.2),
                                          blurRadius: 7.0,
                                          spreadRadius: 3.0,
                                          offset: Offset(3.0, 3.0))
                                    ],
                                    color: isMiss == false
                                        ? CustomTheme.white
                                        : CustomTheme.primarycolor),
                                width: width / 4,
                                height: height / 14),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isMiss = false;
                                isMrs = false;
                                isMirs = !isMirs;
                                prifixname = "Mrs";
                              });
                            },
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Mrs',
                                  style: CustomTheme.body2,
                                ),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: CustomTheme.shadowcolor1
                                              .withOpacity(0.2),
                                          blurRadius: 7.0,
                                          spreadRadius: 3.0,
                                          offset: Offset(3.0, 3.0))
                                    ],
                                    color: isMirs == false
                                        ? CustomTheme.white
                                        : CustomTheme.primarycolor),
                                width: width / 4,
                                height: height / 14),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 30),
                      CoustomInPutField(
                        autofocus: false,
                        fieldController: namecontroller,
                        fieldInputType: TextInputType.text,
                        validator: (value) {
                          if (value == '') {
                            setState(() {
                              nameError = true;
                            });
                          } else {
                            setState(() {
                              nameError = false;
                            });
                          }
                        },
                        hint: "Your Name",
                        hintStyle: CustomTheme.inputFieldHintStyle,
                        cursorHeight: height / 34,
                        cursorcolor: CustomTheme.primarycolor,
                      ),
                      Visibility(
                        visible: nameError,
                        child: Text(
                          'Please enter your name',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(height: height / 35),
                      Text(
                        'Please verify that you are 18 years and above.',
                        style: TextStyle(fontFamily: CustomTheme.fontFamily),
                      ),
                      SizedBox(height: height / 40),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(15),
                            child: filled
                                ? Text(
                                    "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.black))
                                : Text(
                                    ddmmyy,
                                    style: CustomTheme.inputFieldHintStyle,
                                  ),
                            alignment: Alignment.centerLeft,
                            height: height / 12,
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                  color:
                                      CustomTheme.shadowcolor1.withOpacity(0.2),
                                  blurRadius: 7.0,
                                  spreadRadius: 3.0,
                                  offset: Offset(3.0, 3.0))
                            ])),
                      ),
                      Visibility(
                          visible: checkDobvalidation,
                          child: Text(
                            'Please enter your birthdate',
                            style: TextStyle(color: Colors.red),
                          )),
                      SizedBox(
                        height: height / 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Test())).then((value) {
                            setState(() {
                              is_loc_selected = true;
                              address = Provider.of<LocationProvider>(context,
                                      listen: false)
                                  .address;
                              currentlat = Provider.of<LocationProvider>(
                                      context,
                                      listen: false)
                                  .lat;
                              currentlong = Provider.of<LocationProvider>(
                                      context,
                                      listen: false)
                                  .long;
                            });

                            if (Provider.of<LocationProvider>(context,
                                        listen: false)
                                    .address ==
                                '') {
                              address = null;
                            }
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                address == null
                                    ? Text(
                                        '${location = 'Set your Location'}',
                                        style: CustomTheme.inputFieldHintStyle,
                                      )
                                    : Expanded(
                                        child: Text("${address}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black)),
                                      ),
                                Image.asset(
                                  Images.locationlogo,
                                  scale: 4,
                                )
                              ],
                            ),
                            alignment: Alignment.centerLeft,
                            height: height / 12,
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                  color:
                                      CustomTheme.shadowcolor1.withOpacity(0.2),
                                  blurRadius: 7.0,
                                  spreadRadius: 3.0,
                                  offset: Offset(3.0, 3.0))
                            ])),
                      ),
                      Visibility(
                          visible: islocvalidation,
                          child: Text(
                            'Set your location',
                            style: TextStyle(color: Colors.red),
                          )),
                      Expanded(
                        child: SizedBox(),
                      ),
                      CustomBlueButton(
                          title: 'Next',
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              if (filled == false) {
                                setState(
                                  () {
                                    checkDobvalidation = true;
                                    doberror = true;
                                  },
                                );
                              } else {
                                checkDobvalidation = false;
                                doberror = false;
                              }

                              if (address == null) {
                                setState(() {
                                  islocvalidation = true;
                                });
                              } else {
                                islocvalidation = false;
                              }

                              if (nameError == false &&
                                  islocvalidation == false &&
                                  doberror == false) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpProfile(
                                        name: namecontroller.text,
                                        dob:
                                            ("${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"),
                                        location: address.toString(),
                                        prifixname: prifixname,
                                        longitude: currentlong!,
                                        latitude: currentlat!),
                                  ),
                                );
                              }
                            }
                          }),
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
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: CustomTheme.primarycolor,
            colorScheme: ColorScheme.light(primary: CustomTheme.primarycolor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child ?? Text(''),
        );
      },
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        filled = true;
        selectedDate = selected;
      });
  }
}
