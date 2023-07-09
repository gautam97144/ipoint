import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipoint/Screen/debitCard_update_page.dart';
import 'package:ipoint/Screen/showDebit_card_page.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/card_list_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'no_internet_screen.dart';

class ListCard extends StatefulWidget {
  const ListCard({Key? key}) : super(key: key);

  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  CardListModel? cardListModel;
  String? number;
  UserModel? userModel;
  var start = '13';
  var end = 16;

  File? image;

  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());
    setState(() {
      userModel = UserModel.fromJson(jsondecode);
    });
  }

  Future<void> listOfCard() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    try {
      Response response = await ApiClient().dio.post(Constant.listCard,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      setState(() {
        cardListModel = CardListModel.fromJson(response.data);
      });

      if (response.statusCode == 200) {
        print(response.data);
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
    cardlist();
    getModel();
  }

  cardlist() {
    listOfCard();
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
              body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 120,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Welcome',
                                        style: CustomTheme.body3.copyWith(
                                            fontWeight: FontWeight.normal)),
                                    userModel?.data?.name == null
                                        ? Container(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                            ))
                                        : Text('${userModel?.data?.name}',
                                            maxLines: 2,
                                            style: CustomTheme.body3.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700)),
                                  ])),
                          CustomProfilePicture(
                              // onTap: (){
                              //   Navigator.push(context,MaterialPageRoute(builder: (context)=>MenuPage()));
                              // },
                              url: userModel?.data?.profile)
                        ],
                      ),
                      SizedBox(
                        height: Height / 50,
                      ),
                      Text("Payment Method", style: CustomTheme.title),
                      SizedBox(
                        height: Height / 20,
                      ),
                      Expanded(
                        child: cardListModel?.data == null
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: CustomTheme.primarycolor,
                                ),
                              )
                            : cardListModel?.data?.length == 0
                                ? Center(
                                    child: Text(
                                      'No Any Card',
                                      style: TextStyle(
                                          fontFamily: CustomTheme.fontFamily),
                                    ),
                                  )
                                : Scrollbar(
                                    child: ListView.builder(
                                        //physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: cardListModel?.data != [] ||
                                                cardListModel?.data != null
                                            ? cardListModel?.data?.length
                                            : 0,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ShowDebitCardPage(
                                                                  carddata: cardListModel
                                                                          ?.data?[
                                                                      index])));
                                                },
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        color: CustomTheme
                                                            .primarycolor),
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 18,
                                                                vertical: 18),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Image.asset(
                                                                  Images
                                                                      .debitCodeIcon,
                                                                  scale: 3,
                                                                ),
                                                                Image.asset(
                                                                  Images
                                                                      .debitCircleIcon,
                                                                  scale: 3,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  Height / 30,
                                                            ),
                                                            Text(
                                                              "xxxx xxxx xxxx " +
                                                                  "${cardListModel?.data?[index].cardNo!.substring(12, 16).toString()}",
                                                              style: CustomTheme
                                                                  .body2
                                                                  .copyWith(
                                                                      fontSize:
                                                                          18),
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  Height / 80,
                                                            ),
                                                            Text(
                                                              "${cardListModel?.data?[index].name}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      CustomTheme
                                                                          .fontFamily,
                                                                  fontSize: 12),
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  Height / 40,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "VALID THRU",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontFamily:
                                                                          CustomTheme
                                                                              .fontFamily,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                SizedBox(
                                                                  width: Width /
                                                                      40,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "${cardListModel?.data?[index].month}",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontFamily: CustomTheme
                                                                              .fontFamily,
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                    Text("/"),
                                                                    Text(
                                                                      "${cardListModel?.data?[index].year?.substring(2, 4)}",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontFamily: CustomTheme
                                                                              .fontFamily,
                                                                          fontSize:
                                                                              14),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ))),
                                              ),
                                              Divider(
                                                color: Colors.black38,
                                                thickness: 4,
                                              )
                                            ],
                                          );
                                        }),
                                  ),
                      ),
                      SizedBox(
                        height: Height / 30,
                      ),
                    ],
                  )),
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
}
