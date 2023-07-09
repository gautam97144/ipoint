import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/booking_page.dart';
import 'package:ipoint/Screen/bottom_navigation.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/appointmant_detaile_model.dart';
import 'package:ipoint/model/get_appoitment_model.dart';
import 'package:ipoint/model/update_appoinment_model.dart';
import 'package:ipoint/model/vendor_model.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'no_internet_screen.dart';

class UpdateBookingScreen extends StatefulWidget {
  AppointmentData? appointmentData;
  VendorData? vendormodel;

  UpdateBookingScreen({
    Key? key,
    position,
    this.appointmentData,
  }) : super(key: key);

  @override
  _UpdateBookingScreenState createState() => _UpdateBookingScreenState();
}

class _UpdateBookingScreenState extends State<UpdateBookingScreen> {
  String? selectedTime;
  bool? updateIsSelect;

  bool iosStyle = true;
  String? formatTime;

  String changeTime = DateFormat.HOUR24_MINUTE_SECOND.toString();
  DateTime selectedDate = DateTime.now();
  bool filled = false;
  bool nameError = false;
  bool contactError = false;
  bool vehicleError = false;
  bool selectedDatError = false;
  bool selectedTimeError = false;
  bool selectedServicerError = false;
  bool is_loading = false;
  bool isServicevalidation = false;
  bool service = false;
  var serviceprice;
  double servicedata = 0.00;
  // var servicedata=0;
  String? passSelectDate;
  String? passDate;
  String? selectedUpdatedTime;
  List<String> id = [];
  var formatter = NumberFormat('#,##,000');

  // VendorDetailModel? vendorDetailModel;
  //AppointmentModel? appointmentModel;

  //GetAppointmentsModel? getAppointmentsModel;
  AppointmentUpdateModel? appointmentUpdateModel;
  AppointmentDetailModel? appointmentDetailModel;

  var updateServiceName;
  var updateServicePrice;
  String? selectdeList;
  int? index;

  final _formkey = GlobalKey<FormState>();

  GetAppointmentsModel? getAppointmentsModel;

  TextEditingController nameController = TextEditingController();
  TextEditingController contectnoController = TextEditingController();
  TextEditingController vehiclenoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appoitmanDetails();
    setState(() {
      nameController.text = widget.appointmentData?.name ?? "";
      vehiclenoController.text = widget.appointmentData?.vehicleNo ?? "";
      contectnoController.text = widget.appointmentData?.contactNo ?? "";
      selectedDate =
          DateTime.parse(widget.appointmentData?.appointmentDate ?? "");

      filled = true;

      passDate = widget.appointmentData?.appointmentTime ?? "";
    });
    // TimeOfDay _startTime = TimeOfDay(
    //     hour: int.parse(selectedTime!.split(":")[0]),
    //     minute: int.parse(selectedTime!.split(":")[1]));
    //
    // DateTime tempDate = DateFormat("hh:mm")
    //     .parse(_startTime.hour.toString() + ":" + _startTime.minute.toString());
    // var dateFormat = DateFormat("h:mm a");
    //
    // // you can change the format here
    //
    // setState(() {
    //    selectedUpdatedTime = dateFormat.format(tempDate);
    //  });
  }

  @override
  void dispose() {
    // ignore: avoid_print
    print('hello');
    //getAppointment(3);
    super.dispose();
  }

  Future getAppointment(int flag) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData = FormData.fromMap({"flag": flag});
      Response response = await ApiClient().dio.post(Constant.getAppointment,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          getAppointmentsModel = GetAppointmentsModel.fromJson(response.data);
          // screenBlank = false;
        });
      }

      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future updateAppointment() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      print(id.join(",").toString());
      FormData formData = FormData.fromMap({
        "appointment_id": "${widget.appointmentData?.appointmentId}",
        "name": nameController.text,
        "contact_no": contectnoController.text,
        "vehicle_no": vehiclenoController.text,
        "appointment_date": selectedDate,
        "appointment_time": passDate,
        // "${selectedTime}",
        "service_id": id.join(","),
        "amount": servicedata,
      });
      Response response = await ApiClient().dio.post(
          Constant.appointmentUpdate,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      appointmentUpdateModel = AppointmentUpdateModel.fromJson(response.data);

      if (response.statusCode == 200) {
        print(response.data);
        Fluttertoast.showToast(msg: '${appointmentUpdateModel?.message}');

        if (mounted) {
          Navigator.pop(context, true);

          //await getAppointment(3);
        }

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => BottomNavigation(
        //               index: index = 3,
        //             ))).then((value) {});
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future appoitmanDetails() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData = FormData.fromMap(
          {"appointment_id": "${widget.appointmentData?.appointmentId}"});

      Response response = await ApiClient().dio.post(
          Constant.appointmentDetail,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      setState(() {
        appointmentDetailModel = AppointmentDetailModel.fromJson(response.data);
      });

      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(children: [
        Scaffold(
          //resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent.withOpacity(.7),
          body: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Height / 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.clear,
                                size: 30, color: CustomTheme.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Height / 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? selected = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2099),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData(
                                  primaryColor: CustomTheme.primarycolor,
                                  // accentColor: CustomTheme.primarycolor,
                                  colorScheme: ColorScheme.light(
                                      primary: CustomTheme.primarycolor),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary),
                                ),
                                child: child ?? Text(''),
                              );
                            },
                          );
                          if (selected != null && selected != selectedDate)
                            setState(
                              () {
                                var date = "00";
                                if (selected.month < 10) {
                                  date = "0${selected.month}";
                                } else {
                                  date = selected.month.toString();
                                }
                                passSelectDate =
                                    "${selected.year}-$date-${selected.day}";
                                filled = true;
                                selectedDate = selected;
                              },
                            );
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: Height / 14,
                          width: Width / 1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: CustomTheme.grey),
                          child: filled
                              ? Text(
                                  "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: CustomTheme.fontFamily),
                                )
                              : Text(
                                  "Selected your date",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: CustomTheme.fontFamily),
                                ),
                        ),
                      ),
                      Visibility(
                          visible: selectedDatError,
                          child: Text("select your date",
                              style: TextStyle(
                                color: Colors.red,
                              ))),
                      SizedBox(height: Height / 40),
                      GestureDetector(
                        onTap: () {
                          show();
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: Height / 14,
                          width: Width / 1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: CustomTheme.grey),
                          child: Text("$passDate"
                              // selectedTime != ""
                              //     ? selectedTime!
                              //     : "Select your time",
                              // style: selectedTime != null
                              //     ? TextStyle(
                              //         fontSize: 16,
                              //         color: Colors.black,
                              //         fontFamily: CustomTheme.fontFamily)
                              //     : TextStyle(
                              //         fontSize: 16,
                              //         color: Colors.black,
                              //         fontFamily: CustomTheme.fontFamily)
                              ),
                        ),
                      ),
                      Visibility(
                          visible: selectedTimeError,
                          child: Text("select your Time",
                              style: TextStyle(color: Colors.red))),
                      SizedBox(height: Height / 40),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: Height / 14,
                        width: Width / 1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: CustomTheme.grey),
                        child: TextFormField(
                          validator: (value) {
                            if (value == '') {
                              setState(
                                () {
                                  nameError = true;
                                },
                              );
                            } else {
                              setState(
                                () {
                                  nameError = false;
                                },
                              );
                            }
                          },
                          controller: nameController,
                          cursorColor: CustomTheme.primarycolor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: CustomTheme.fontFamily),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: nameError,
                        child: Text('please enter your name',
                            style: TextStyle(color: Colors.red)),
                      ),
                      SizedBox(height: Height / 40),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: Height / 14,
                        width: Width / 1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: CustomTheme.grey),
                        child: TextFormField(
                          validator: (value) {
                            if (value == '') {
                              setState(
                                () {
                                  contactError = true;
                                },
                              );
                            } else {
                              setState(
                                () {
                                  contactError = false;
                                },
                              );
                            }
                          },
                          controller: contectnoController,
                          cursorColor: CustomTheme.primarycolor,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Contact no',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: CustomTheme.fontFamily),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: contactError,
                        child: Text('please enter your Contact no',
                            style: TextStyle(color: Colors.red)),
                      ),
                      SizedBox(height: Height / 40),
                      appointmentDetailModel?.data?.catName == "Car Showroom"
                          ? Visibility(
                              visible: true,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: Height / 14,
                                width: Width / 1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: CustomTheme.grey),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == '') {
                                      setState(
                                        () {
                                          vehicleError = true;
                                        },
                                      );
                                    } else {
                                      setState(
                                        () {
                                          vehicleError = false;
                                        },
                                      );
                                    }
                                  },
                                  controller: vehiclenoController,
                                  cursorColor: CustomTheme.primarycolor,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Vehicle no ',
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontFamily: CustomTheme.fontFamily),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      Visibility(
                        visible: vehicleError,
                        child: Text(
                          'please enter your Vehicle no',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(height: Height / 24),
                      Text("Choose your service(s) you need.",
                          style: CustomTheme.body9),
                      SizedBox(height: Height / 24),
                      appointmentDetailModel == null
                          ? Center(
                              widthFactor:
                                  MediaQuery.of(context).size.width / 2,
                              child: Container(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                    color: CustomTheme.primarycolor),
                              ),
                            )
                          : Wrap(
                              runSpacing: 10,
                              spacing: 15,
                              children: [
                                ...List.generate(
                                  appointmentDetailModel != null
                                      ? appointmentDetailModel!.data!.services!
                                          .length //vendorDetailModel!.data!.services!.length
                                      : 0,
                                  (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        // servicedata = appointmentDetailModel
                                        //     ?.data?.amount;
                                        // print(servicedata.toString() +
                                        //     "uuuuuuuu");

                                        setState(() {
                                          if (appointmentDetailModel
                                                  ?.data
                                                  ?.services?[index]
                                                  .isSelected ==
                                              1) {
                                            appointmentDetailModel
                                                ?.data
                                                ?.services?[index]
                                                .isSelected = 0;
                                          } else {
                                            appointmentDetailModel
                                                ?.data
                                                ?.services?[index]
                                                .isSelected = 1;
                                          }
                                        });
                                      },
                                      child: IntrinsicHeight(
                                        child: Wrap(
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                  minHeight: 100, minWidth: 40),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                              //  alignment: Alignment.center,
                                              width: Width / 5,
                                              // height: Height / 8,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: appointmentDetailModel
                                                              ?.data
                                                              ?.services?[index]
                                                              .isSelected ==
                                                          1
                                                      ? CustomTheme.primarycolor
                                                      : Colors.transparent),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Wrap(
                                                    children: [
                                                      Text(
                                                        "${appointmentDetailModel?.data?.services?[index].serviceName}",
                                                        style: CustomTheme.body1
                                                            .copyWith(
                                                                color:
                                                                    CustomTheme
                                                                        .white),
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "RM " +
                                                        "${appointmentDetailModel?.data?.services?[index].price}",
                                                    style: CustomTheme.body1
                                                        .copyWith(
                                                            color: CustomTheme
                                                                .white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                      Visibility(
                          visible: isServicevalidation,
                          child: Text(
                            "Select your service",
                            style: TextStyle(color: Colors.red),
                          )),
                      SizedBox(height: Height / 15),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.yellow),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ))),
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              var count = 0;
                              for (var i = 0;
                                  i <
                                      appointmentDetailModel!
                                          .data!.services!.length;
                                  i++) {
                                if (appointmentDetailModel!
                                        .data!.services?[i].isSelected ==
                                    1) {
                                  count = count + 1;
                                }
                              }

                              if (count == 0) {
                                setState(() {
                                  isServicevalidation = true;
                                });
                              } else {
                                setState(() {
                                  isServicevalidation = false;
                                });
                              }
                              print(count);
                              if (isServicevalidation == false &&
                                  nameError == false &&
                                  contactError == false &&
                                  vehicleError == false) {
                                setState(() {
                                  is_loading = true;
                                  FocusScope.of(context).unfocus();
                                });

                                id.clear();
                                appointmentDetailModel!.data?.services!
                                    .forEach((element) {
                                  if (element.isSelected == 1) {
                                    setState(() {
                                      id.add(element.serviceId!);
                                    });
                                  }
                                });
                                for (int i = 0;
                                    i <
                                        appointmentDetailModel!
                                            .data!.services!.length;
                                    i++) {
                                  if (appointmentDetailModel
                                          ?.data?.services?[i].isSelected ==
                                      1) {
                                    servicedata = servicedata +
                                        double.parse(
                                            "${appointmentDetailModel?.data?.services?[i].price?.replaceAll(",", "")}");
                                    print(servicedata);
                                  }
                                }

                                await updateAppointment();

                                servicedata = 0.00;
                                if (mounted) {
                                  setState(() {
                                    is_loading = false;
                                  });
                                }
                              }
                            }

                            //   var count = 0;
                            //   for (var i = 0;
                            //       i <
                            //           appointmentDetailModel!
                            //               .data!.services!.length;
                            //       i++) {
                            //     if (appointmentDetailModel!
                            //             .data!.services?[i].isSelected ==
                            //         1) {
                            //       count = count + 1;
                            //     }
                            //   }
                            //
                            //   if (count == 0) {
                            //     setState(() {
                            //       isServicevalidation = true;
                            //     });
                            //   } else {
                            //     setState(() {
                            //       isServicevalidation = false;
                            //     });
                            //   }
                            //   print(count);
                            //
                            //
                            //   if (isServicevalidation == false &&
                            //       nameError == false &&
                            //       contactError == false &&
                            //       vehicleError == false) {
                            //     setState(() {
                            //       is_loading = true;
                            //       FocusScope.of(context).unfocus();
                            //     });
                            //
                            //     id.clear();
                            //     appointmentDetailModel!.data?.services!
                            //         .forEach((element) {
                            //       if (element.isSelected == 1) {
                            //         setState(() {
                            //           id.add(element.serviceId!);
                            //         });
                            //       }
                            //     });
                            //     for (int i = 0;
                            //         i <
                            //             appointmentDetailModel!
                            //                 .data!.services!.length;
                            //         i++) {
                            //       if (appointmentDetailModel
                            //               ?.data?.services?[i].isSelected ==
                            //           1) {
                            //         servicedata = servicedata +
                            //             (appointmentDetailModel
                            //                     ?.data?.services?[i].price ??
                            //                 0);
                            //         print(servicedata);
                            //       }
                            //     }
                            //
                            //     await updateAppointment();
                            //
                            //     servicedata = 0;
                            //     if (mounted) {
                            //       setState(() {
                            //         is_loading = false;
                            //       });
                            //     }
                            //   }
                          },
                          child: Text(
                            "Update  Appointment",
                            style: CustomTheme.body2,
                          ),
                        ),
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
            : SizedBox.shrink(),
        is_loading ? LoaderLayoutWidget() : SizedBox.shrink()
      ]),
    );
  }

  Future<void> show() async {
    final TimeOfDay? result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 12-Hour format
                  alwaysUse24HourFormat: false),
              // If you want 24-Hour format, just change alwaysUse24HourFormat to true
              child: child!);
        });
    if (result != null) {
      setState(() {
        var min = "00";
        if (result.minute < 10) {
          min = "0${result.minute}";
        } else {
          min = result.minute.toString();
        }
        passDate = "${result.hour}:$min:00";
        selectedTime = result.format(context);
        changeTime = selectedTime!;
        print(passDate);
      });
    }
  }
}
