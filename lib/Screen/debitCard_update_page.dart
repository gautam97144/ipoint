import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Screen/list_of_card.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/Widget/custom_yellow_grey_button.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/edit_card_model.dart';
import 'package:ipoint/model/update_card_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'no_internet_screen.dart';

class DebitCardUpdate extends StatefulWidget {
  EditCardData? editcard;

  DebitCardUpdate({
    Key? key,
    this.editcard,
  }) : super(key: key);

  @override
  _DebitCardUpdateState createState() => _DebitCardUpdateState();
}

class _DebitCardUpdateState extends State<DebitCardUpdate> {
  UserModel? userModel;
  UpdateCardModel? updateCardModel;
  bool is_loading = false;
  String? value1;
  bool monthFilled = false;
  bool filled = false;
  String? hintText;
  bool isYearValidate = false;
  bool isMonthValidate = false;

  var item = [
    '01',
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    '09',
    "10",
    "11",
    "12"
  ];

  TextEditingController namecontroller = TextEditingController();
  TextEditingController card_no_controller = TextEditingController();
  TextEditingController monthcontroller = TextEditingController();
  TextEditingController yearcontroller = TextEditingController();

  Future updatecard() async {
    FormData formData = FormData.fromMap({
      "card_id": widget.editcard?.cardId,
      "name": namecontroller.text,
      "card_no": card_no_controller.text,
      "month": value1,
      "year": hintText,
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    try {
      Response response = await ApiClient().dio.post(Constant.updateCard,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          data: formData);

      updateCardModel = UpdateCardModel.fromJson(response.data);

      if (response.statusCode == 200) {
        print(response.data);

        if (updateCardModel?.success == 1) {
          Fluttertoast.showToast(msg: "${updateCardModel?.message}");

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ListCard()));
        } else {
          Fluttertoast.showToast(msg: "${updateCardModel?.message}");
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getModel();
  }

  getModel() async {
    setState(() {
      namecontroller.text = widget.editcard?.name ?? "";
      card_no_controller.text = widget.editcard?.cardNo ?? "";
      value1 = widget.editcard?.month ?? "";
      hintText = widget.editcard?.year ?? "";
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    setState(() {});
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());
    userModel = UserModel.fromJson(jsondecode);
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
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
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
                        height: Height / 50,
                      ),
                      Text(
                        "Payment Method",
                        style: TextStyle(
                            fontFamily: CustomTheme.fontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Height / 20,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: CustomTheme.primarycolor),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18, vertical: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    Images.debitCodeIcon,
                                    scale: 3,
                                  ),
                                  Image.asset(
                                    Images.debitCircleIcon,
                                    scale: 3,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Height / 30,
                              ),
                              Text(
                                "XXXX    XXXX   XXXX   " +
                                    "${widget.editcard?.cardNo?.substring(12, 16)}",
                                style: CustomTheme.body2,
                              ),
                              SizedBox(
                                height: Height / 80,
                              ),
                              Text(
                                "${widget.editcard?.name}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: CustomTheme.fontFamily,
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: Height / 40,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "VALID THRU",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontFamily: CustomTheme.fontFamily,
                                        fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: Width / 40,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${widget.editcard?.month}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: CustomTheme.fontFamily,
                                            fontSize: 14),
                                      ),
                                      Text("/"),
                                      Text(
                                        "${widget.editcard?.year?.substring(2, 4)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: CustomTheme.fontFamily,
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ))),
                  SizedBox(
                    height: Height / 30,
                  ),
                  Container(
                    height: Height / 16,
                    width: Width / 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: CustomTheme.grey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        controller: namecontroller,
                        cursorColor: CustomTheme.primarycolor,
                        decoration: const InputDecoration(
                          hintText: 'Your Name',
                          hintStyle: TextStyle(
                              fontFamily: CustomTheme.fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Height / 40,
                  ),
                  Container(
                    height: Height / 16,
                    width: Width / 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: CustomTheme.grey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        controller: card_no_controller,
                        cursorColor: CustomTheme.primarycolor,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Card No.',
                          hintStyle: TextStyle(
                              fontFamily: CustomTheme.fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Height / 40,
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
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(.1),
                                              width: 0.0)),
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      contentPadding: EdgeInsets.all(11),
                                      filled: true,
                                      fillColor: CustomTheme.grey,
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
                                      style: TextStyle(color: Colors.red))),
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
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(.1),
                                          width: 0.0)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(.1),
                                          width: 0.0)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30)),
                                  contentPadding: EdgeInsets.all(11),
                                  filled: true,
                                  fillColor: CustomTheme.grey,
                                  hintText: hintText,
                                  hintStyle: TextStyle(
                                      fontFamily: CustomTheme.fontFamily),

                                  //  InputBorder.none,
                                ),
                              ),
                              Visibility(
                                  visible: isYearValidate,
                                  child: Text("field is empty",
                                      style: TextStyle(color: Colors.red))),
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
                  Expanded(child: SizedBox(height: Height / 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Width / 4,
                        height: Height / 17,
                        child: TextButton(
                          style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.yellow),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ))),
                          onPressed: () async {
                            setState(() {
                              is_loading = true;
                            });
                            await updatecard();
                            setState(() {
                              is_loading = false;
                            });
                          },
                          child: Text("Update", style: CustomTheme.body3),
                        ),
                      ),
                      SizedBox(width: Width / 10),
                      SizedBox(
                        width: Width / 4,
                        height: Height / 17,
                        child: TextButton(
                          style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.grey.shade300),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel", style: CustomTheme.body3),
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 10),
                ],
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
                    child: Icon(Icons.clear)),
              ],
            ),
            content: Container(
              //color: Colors.green,
              width: MediaQuery.of(context).size.width,
              child: YearPicker(
                selectedDate: DateTime(2022),
                firstDate: DateTime.now(),
                lastDate: DateTime(2099),
                onChanged: (val) {
                  setState(() {
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
            ));
      },
    );
  }
}
