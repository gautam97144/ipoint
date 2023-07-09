import 'dart:async';
import 'package:ipoint/Screen/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/appoitment_maodel.dart';
import 'package:ipoint/model/vendor_model.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'booking_page.dart';
import 'no_internet_screen.dart';

class SelectedDateScreen extends StatefulWidget {
  VendorData? vendormodel;
  List<Services>? serviceid;
  String? venderid;
  SelectedDateScreen(
      {Key? key, this.serviceid, this.venderid, this.vendormodel})
      : super(key: key);

  @override
  _SelectedDateScreenState createState() => _SelectedDateScreenState();
}

class _SelectedDateScreenState extends State<SelectedDateScreen> {
  String? selectedTime;
  String? passDate;
  String? passSelectDate;
  bool iosStyle = true;
  String? formatTime;
  String clearTime = "Select your Time";
  List<String> id = [];

  int? index;
  String changeTime = DateFormat.HOUR24_MINUTE_SECOND.toString();
  DateTime selectedDate = DateTime.now();
  bool filled = false;
  bool nameError = false;
  bool contactError = false;
  bool VehicleError = false;
  bool selectedDatError = false;
  bool selectedTimeError = false;
  bool selectedServicerError = false;
  bool is_loading = false;
  bool isServicevalidation = false;
  bool service = false;
  var serviceprice = 0.0;
  var formatter = NumberFormat('#,##,000');

  VendorDetailModel? vendorDetailModel;
  AppointmentModel? appointmentModel;

  final _formkey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController contectnoController = TextEditingController();
  TextEditingController vehiclenoController = TextEditingController();

  Future saveAppointment() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      print(id.join(","));

      FormData formData = FormData.fromMap({
        "vendor_id": widget.venderid,
        "name": nameController.text,
        "contact_no": contectnoController.text,
        "vehicle_no": vehiclenoController.text,
        "appointment_date": "${passSelectDate}",
        "appointment_time": "${passDate}",
        "service_id": id.join(","),
        "amount": serviceprice.toDouble(),
      });

      Response response = await ApiClient().dio.post(Constant.saveAppointment,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      appointmentModel = AppointmentModel.fromJson(response.data);

      if (response.statusCode == 200) {
        print(response.data);
        Fluttertoast.showToast(msg: '${appointmentModel?.message}');

        // Navigator.of(context)
        //     .push(PageRouteBuilder(
        //         opaque: false,
        //         fullscreenDialog: true,
        //         pageBuilder: (BuildContext context, _, __) =>
        //             BookingSuccesScreen()))
        //     .then((value) {
        //   nameController.clear();
        //   contectnoController.clear();
        //   vehiclenoController.clear();
        //   setState(() {
        //     value = "Select your Time";
        //     selectedTime = value;
        //     //selectedDate = "Selected date" as DateTime;
        //     //  value = "Select your Date";
        //
        //     //selectedDate = value;
        //   });
        // });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BottomNavigation(
            index: index = 3,
          );
        })).then((value) {
          nameController.clear();
          contectnoController.clear();
          vehiclenoController.clear();
          setState(() {
            filled = false;
          });
          setState(() {
            selectedTime = 'Select your Time';
          });

          setState(() {
            for (var i = 0; i < widget.vendormodel!.services!.length; i++)
              widget.vendormodel?.services![i].isSelected = false;
          });
        });
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.vendormodel?.categoryName.toString());
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
        SafeArea(
          child: Scaffold(
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
                                    "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontFamily: CustomTheme.fontFamily),
                                  )
                                : Text(
                                    "Select your date",
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
                            child: Text(
                                selectedTime != null
                                    ? selectedTime!
                                    : 'Select your time',
                                style: selectedTime != null
                                    ? TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontFamily: CustomTheme.fontFamily)
                                    : TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontFamily: CustomTheme.fontFamily)),
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
                        // widget.index == 1
                        //     ?
                        widget.vendormodel?.categoryName == "Car Showroom"
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
                                            VehicleError = true;
                                          },
                                        );
                                      } else {
                                        setState(
                                          () {
                                            VehicleError = false;
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
                          visible: VehicleError,
                          child: Text(
                            'please enter your Vehicle no',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(height: Height / 24),
                        Text("Choose your service(s) you need.",
                            style: CustomTheme.body9),
                        SizedBox(height: Height / 24),
                        Wrap(
                          // runAlignment: WrapAlignment.center,
                          runSpacing: 15,
                          spacing: 15,
                          children: [
                            ...List.generate(
                                widget.vendormodel != null
                                    ? widget.vendormodel!.services!
                                        .length //vendorDetailModel!.data!.services!.length
                                    : 0, (index) {
                              return GestureDetector(
                                onTap: () {
                                  print(widget
                                      .vendormodel?.services?[index].price);

                                  setState(
                                    () {
                                      if (widget.vendormodel?.services?[index]
                                              .isSelected ==
                                          true) {
                                        widget.vendormodel?.services?[index]
                                            .isSelected = false;

                                        // serviceprice = serviceprice -
                                        //     (double.parse(
                                        //         "${widget.vendormodel?.services?[index].price}"));
                                      } else {
                                        widget.vendormodel?.services?[index]
                                            .isSelected = true;

                                        // serviceprice = serviceprice +
                                        //     double.parse(widget.vendormodel!
                                        //         .services![index].price!);

                                        print(serviceprice);
                                      }
                                    },
                                  );
                                },
                                child: IntrinsicHeight(
                                  child: Wrap(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            minHeight: 100, minWidth: 40),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        width: Width / 5,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: widget
                                                        .vendormodel
                                                        ?.services?[index]
                                                        .isSelected ==
                                                    true
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
                                                  "${widget.vendormodel?.services?[index].serviceName}",
                                                  style: CustomTheme.body1
                                                      .copyWith(
                                                          color: CustomTheme
                                                              .white),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "RM " +
                                                  "${widget.vendormodel?.services?[index].price}",
                                              style: CustomTheme.body1.copyWith(
                                                  color: CustomTheme.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
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
                                if (filled == false) {
                                  setState(() {
                                    selectedDatError = true;
                                  });
                                } else {
                                  selectedDatError = false;
                                }

                                if (selectedTime == null) {
                                  setState(() {
                                    selectedTimeError = true;
                                  });
                                } else {
                                  selectedTimeError = false;
                                }

                                var count = 0;
                                for (var i = 0;
                                    i < widget.vendormodel!.services!.length;
                                    i++) {
                                  if (widget.vendormodel!.services![i]
                                          .isSelected ==
                                      true) {
                                    count = count + 1;
                                  }
                                }

                                if (count == 0) {
                                  isServicevalidation = true;
                                } else {
                                  isServicevalidation = false;
                                }

                                if (nameError == false &&
                                    contactError == false &&
                                    VehicleError == false &&
                                    selectedDatError == false &&
                                    selectedTimeError == false &&
                                    isServicevalidation == false) {
                                  setState(() {
                                    is_loading = true;
                                    FocusScope.of(context).unfocus();
                                  });

                                  id.clear();
                                  widget.vendormodel!.services!
                                      .forEach((element) {
                                    if (element.isSelected == true) {
                                      print(element.serviceId);

                                      setState(() {
                                        id.add(element.serviceId!);
                                      });
                                    } else {}
                                  });

                                  for (int i = 0;
                                      i < widget.vendormodel!.services!.length;
                                      i++) {
                                    if (widget.vendormodel?.services?[i]
                                            .isSelected ==
                                        true) {
                                      serviceprice = serviceprice +
                                          double.parse(
                                              "${widget.vendormodel!.services![i].price!.replaceAll(',', "")}");
                                      print(serviceprice);
                                    }
                                  }
                                  await saveAppointment();
                                  serviceprice = 0.0;

                                  setState(() {
                                    is_loading = false;
                                  });
                                }
                              }
                            },
                            child: Text(
                              "Book Now",
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
        print(changeTime);
      });
    }
  }
}
