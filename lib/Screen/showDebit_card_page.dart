import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Screen/bottom_navigation.dart';
import 'package:ipoint/Screen/debitCard_update_page.dart';
import 'package:ipoint/Screen/list_of_card.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/card_list_model.dart';
import 'package:ipoint/model/delete_card_model.dart';
import 'package:ipoint/model/edit_card_model.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'no_internet_screen.dart';

class ShowDebitCardPage extends StatefulWidget {
  CardData? carddata;

  ShowDebitCardPage({Key? key, this.carddata}) : super(key: key);

  @override
  _ShowDebitCardPageState createState() => _ShowDebitCardPageState();
}

class _ShowDebitCardPageState extends State<ShowDebitCardPage> {
  EditCardModel? editCardModel;
  DeleteCard? deleteCard;
  bool is_loading = false;

  Future editcard() async {
    FormData formData = FormData.fromMap({
      "card_id": widget.carddata?.cardId,
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    try {
      Response response = await ApiClient().dio.post(Constant.editCard,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          data: formData);

      // setState(() {
      //   //cardListModel = CardListModel.fromJson(response.data);
      // });

      editCardModel = EditCardModel.fromJson(response.data);

      if (response.statusCode == 200) {
        print(response.data);

        if (editCardModel?.success == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DebitCardUpdate(editcard: editCardModel?.data)));
        }
      }
    } on DioError catch (e) {
      print(e.message);
      // Fluttertoast.showToast(msg: '${e.message}');
    }
  }

  Future deletecard() async {
    FormData formData = FormData.fromMap({
      "card_id": widget.carddata?.cardId,
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    try {
      Response response = await ApiClient().dio.post(Constant.deleteCard,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          data: formData);

      deleteCard = DeleteCard.fromJson(response.data);

      if (response.statusCode == 200) {
        print(response.data);

        if (deleteCard?.success == 1) {
          Fluttertoast.showToast(msg: "${deleteCard?.message}");

          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => Botto()),
          //     (route) => false);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ListCard()));
        } else {
          Fluttertoast.showToast(msg: "${deleteCard?.message}");
        }
      }
    } on DioError catch (e) {
      print(e.message);
      // Fluttertoast.showToast(msg: '${e.message}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                  Text("Payment Method",
                                      style: CustomTheme.title),
                                ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        "XXXX    XXXX   XXXX " +
                                            "${widget.carddata?.cardNo?.substring(12, 16)}",
                                        style: CustomTheme.body2,
                                      ),
                                      SizedBox(
                                        height: Height / 80,
                                      ),
                                      Text(
                                        "${widget.carddata?.name}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: CustomTheme.fontFamily,
                                            fontSize: 12),
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
                                                fontFamily:
                                                    CustomTheme.fontFamily,
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: Width / 40,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${widget.carddata?.month}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        CustomTheme.fontFamily,
                                                    fontSize: 14),
                                              ),
                                              Text("/"),
                                              Text(
                                                "${widget.carddata?.year?.substring(2, 4)}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        CustomTheme.fontFamily,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: Height / 17,
                                width: Width / 4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: CustomTheme.grey),
                                child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        is_loading = true;
                                      });
                                      await editcard();

                                      setState(() {
                                        is_loading = false;
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        "Update",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: CustomTheme.fontFamily,
                                            fontSize: 16),
                                      ),
                                    )),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showMyDialog();
                                },
                                child: Container(
                                  height: Height / 23,
                                  width: Width / 11,
                                  decoration: BoxDecoration(
                                    color: CustomTheme.red,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Image.asset(
                                    Images.deleteIcon,
                                    scale: 2,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Warning',
            style: CustomTheme.body4,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Are you Sure you want to Delete Your Card ?',
                    style: CustomTheme.textStyle.copyWith(fontSize: 15)),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'No',
                style: TextStyle(color: CustomTheme.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: CustomTheme.red),
              ),
              onPressed: () async {
                setState(() {
                  is_loading = true;
                  Navigator.pop(context);
                });
                await deletecard();

                setState(() {
                  is_loading = false;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
