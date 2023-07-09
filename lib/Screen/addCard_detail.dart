import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Screen/list_of_card.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/add_card_model.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'no_internet_screen.dart';

class AddCardDetail extends StatefulWidget {
  const AddCardDetail({Key? key}) : super(key: key);

  @override
  _AddCardDetailState createState() => _AddCardDetailState();
}

class _AddCardDetailState extends State<AddCardDetail> {
  AddCardModel? addCardModel;
  bool is_loading = false;
  bool isYearValidate = false;
  bool isMonthValidate = false;
  bool monthFilled = false;
  String? value1;
  DateTime? date1;
  String? chosenVal;
  DateTime selectedDate = DateTime.now();
  bool filled = false;
  String hintText = 'Year';
  DateTime selecteddate = DateTime.now();
  Color color = CustomTheme.primarycolor;
  // DateTime value = DateTime.now();
  var item = [
    '01',
    "02 ",
    "03 ",
    "04 ",
    "05 ",
    "06 ",
    "07 ",
    "08 ",
    '09 ',
    "10 ",
    "11 ",
    "12 "
  ];
  final _formkey = GlobalKey<FormState>();

  TextEditingController namecontroller = TextEditingController();
  TextEditingController card_no_controller = TextEditingController();
  TextEditingController monthcontroller = TextEditingController();
  TextEditingController yearcontroller = TextEditingController();

  Future addCard() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    FormData formData = FormData.fromMap({
      "name": namecontroller.text,
      "card_no": card_no_controller.text,
      "month": value1,
      "year": hintText,
    });

    try {
      Response response = await ApiClient().dio.post(Constant.addCard,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        print(response.data);

        addCardModel = AddCardModel.fromJson(response.data);

        if (addCardModel?.success == 1) {
          Fluttertoast.showToast(msg: '${addCardModel?.message}');

          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ListCard()))
              .then((value) {
            namecontroller.clear();
            card_no_controller.clear();
            setState(() {
              hintText = "Year";
            });

            setState(() {
              value1 = null;
            });
          });
        } else {
          Fluttertoast.showToast(msg: '${addCardModel?.message}');
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
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent.withOpacity(.7),
            body: SafeArea(
              child: Form(
                key: _formkey,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
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
                                    size: 30, color: CustomTheme.white)),
                          ],
                        ),
                        SizedBox(
                          height: Height / 5,
                        ),
                        TextFormField(
                          validator: (value) => validname(value!),
                          controller: namecontroller,
                          cursorColor: CustomTheme.primarycolor,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white)),

                            contentPadding: EdgeInsets.all(18),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Your Name',
                            hintStyle:
                                TextStyle(fontFamily: CustomTheme.fontFamily),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30)),

                            //  InputBorder.none,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) => validcardname(value!),
                          controller: card_no_controller,
                          cursorColor: CustomTheme.primarycolor,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white)),
                            contentPadding: EdgeInsets.all(18),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Card No.',
                            hintStyle:
                                TextStyle(fontFamily: CustomTheme.fontFamily),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(30)),

                            //  InputBorder.none,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FormField<String>(
                                      // validator: (value) {
                                      //   if (value == "") {
                                      //     setState(() {
                                      //       isMonthValidate = true;
                                      //     });
                                      //   } else {
                                      //     setState(() {
                                      //       isMonthValidate = false;
                                      //     });
                                      //   }
                                      // },
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent),
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            contentPadding: EdgeInsets.all(18),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Month',
                                          ),
                                          //isEmpty: false,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              hint: Text(
                                                'Month',
                                              ),
                                              value: value1,
                                              isDense: true,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  monthFilled = true;
                                                  value1 = newValue;
                                                  // state.didChange(newValue);
                                                });
                                              },
                                              items: item.map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Visibility(
                                        visible: isMonthValidate,
                                        child: Text("field is empty",
                                            style:
                                                TextStyle(color: Colors.red))),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      onTap: () {
                                        _showMyDialog();
                                      },
                                      readOnly: true,
                                      cursorColor: CustomTheme.primarycolor,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        contentPadding: EdgeInsets.all(18),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: hintText,
                                        hintStyle: TextStyle(
                                          fontFamily: CustomTheme.fontFamily,
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(30)),

                                        //  InputBorder.none,
                                      ),
                                    ),
                                    Visibility(
                                        visible: isYearValidate,
                                        child: Text("field is empty",
                                            style:
                                                TextStyle(color: Colors.red))),
                                  ],
                                ),

                                //     GestureDetector(
                                //   onTap: () {
                                //     _selectDate(context);
                                //   },
                                //   child: FormField<String>(
                                //       //initialValue: "Year",
                                //       //validator: (value) => validmonth(value ?? ""),
                                //       builder: (FormFieldState<String> state) {
                                //     return InputDecorator(
                                //       child: filled == false
                                //           ? Text(
                                //               'Year',
                                //               style: TextStyle(
                                //                 fontFamily: CustomTheme.fontFamily,
                                //                 fontSize: 16,
                                //               ),
                                //             )
                                //           : Text("${selectedDate.year}"),
                                //       decoration: InputDecoration(
                                //         border: OutlineInputBorder(
                                //             borderSide: BorderSide(
                                //                 color: Colors.transparent),
                                //             borderRadius:
                                //                 BorderRadius.circular(30)),
                                //         focusedBorder: OutlineInputBorder(
                                //             borderRadius: BorderRadius.circular(30),
                                //             borderSide:
                                //                 BorderSide(color: Colors.white)),
                                //         contentPadding: EdgeInsets.all(18),
                                //         filled: true,
                                //         fillColor: Colors.white,
                                //         hintText: 'Month',
                                //       ),
                                //     );
                                //   }),
                                // )
                              )
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: Height / 3.2,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextButton(
                            style: ButtonStyle(
                                // overlayColor: MaterialStateProperty.all(Colors.yellow),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.yellow),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ))),
                            onPressed: () async {
                              if (_formkey.currentState!.validate() ||
                                  filled == false ||
                                  monthFilled == false) {
                                if (filled == false) {
                                  setState(() {
                                    isYearValidate = true;
                                  });
                                } else {
                                  setState(() {
                                    isYearValidate = false;
                                  });
                                }

                                if (monthFilled == false) {
                                  setState(() {
                                    isMonthValidate = true;
                                  });
                                } else {
                                  setState(() {
                                    isMonthValidate = false;
                                  });
                                }

                                if (isYearValidate == false &&
                                    isMonthValidate == false) {
                                  setState(() {
                                    is_loading = true;
                                  });
                                  await addCard();
                                  setState(() {
                                    is_loading = false;
                                  });
                                }
                              }
                            },
                            child: Text("Add card", style: CustomTheme.body3),
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
        ],
      ),
    );
  }

  String? validname(String value) {
    if (value.isEmpty) {
      return "Please Enter your name";
    }
    return null;
  }

  String? validcardname(String value) {
    if (value.isEmpty) {
      return "Please Enter your card no";
    }
    if (value.length != 16) {
      return "Please Enter Valid Card Number";
    }
    return null;
  }

  String? validmonth(String monthvalid) {
    if (monthvalid.isEmpty) {
      return "Please enter month";
    }
    // if (value.length != 2) {
    //   return "enter valid format ";
    // }
    return null;
  }

  String? validyear(String value) {
    if (value.isEmpty) {
      return "Please enter year";
    }
    // if (value.length != 4) {
    //   return "enter valid format";
    // }
    return null;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.clear,
                      size: 35,
                    )),
              ],
            ),
            content: Scrollbar(
              child: Container(
                //color: Colors.green,
                width: MediaQuery.of(context).size.width,
                child: Theme(
                  data: ThemeData(
                    primaryColor: CustomTheme.primarycolor,
                    colorScheme:
                        ColorScheme.light(primary: CustomTheme.primarycolor),
                  ),
                  child: YearPicker(
                    // initialDate: ,
                    selectedDate: selecteddate,
                    firstDate: DateTime.now(),
                    //DateTime.now(),
                    lastDate: DateTime(2099),
                    onChanged: (val) {
                      setState(() {
                        selecteddate = val;
                        filled = true;
                        hintText = val
                            .toString()
                            .split(' ')[0]
                            .toString()
                            .split('-')
                            .toString()
                            .split(',')[0]
                            .toString()
                            .split('[')[1]
                            .toString();

                        // print(hinttext.toString().split('[')[1].toString());
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ));
      },
    );
  }
}
