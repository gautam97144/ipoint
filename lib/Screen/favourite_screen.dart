import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Screen/vendor_detail.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/like_list_model.dart';
import 'package:ipoint/model/service_like.dart';
import 'package:ipoint/model/service_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'no_internet_screen.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  int selected = 0;
  bool? value = false;
  bool isvisible = false;
  LikeListModel? likeListModel;
  ServiceModel? serviceModel;
  ServiceLikeModel? serviceLikeModel;
  UserModel? userModel;
  File? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    like();
    getModel();
  }

  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());
    setState(() {
      userModel = UserModel.fromJson(jsondecode);
    });
  }

  like() {
    likeList();
  }

  Future likeDisLike(String id) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData = FormData.fromMap({"service_id": id});

      Response response = await ApiClient().dio.post(Constant.addServiceLike,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      setState(() {
        serviceLikeModel = ServiceLikeModel.fromJson(response.data);
      });

      if (response.statusCode == 200) {
        print(response.data);

        if (serviceLikeModel?.success == 1) {
          Fluttertoast.showToast(msg: "${serviceLikeModel?.message}");
        } else {
          Fluttertoast.showToast(msg: "${serviceLikeModel?.message}");
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  Future likeList() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      Response response = await ApiClient().dio.post(Constant.likeList,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          likeListModel = LikeListModel.fromJson(response.data);
        });
      }

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
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    //var Width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Column(
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
                                style: CustomTheme.body3
                                    .copyWith(fontWeight: FontWeight.normal)),
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
                          ],
                        ),
                      ),
                      CustomProfilePicture(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             MenuPage()));
                          },
                          url: userModel?.data?.profile)
                    ],
                  ),
                  SizedBox(
                    height: Height / 50,
                  ),
                  Text('Favourite', style: CustomTheme.title),
                  SizedBox(
                    height: Height / 30,
                  ),
                  Container(height: Height / 20, child: Text("")),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: likeListModel?.data == null
                        ? Center(
                            heightFactor: 20,
                            child: CircularProgressIndicator(
                              color: CustomTheme.primarycolor,
                            ),
                          )
                        : likeListModel?.data?.length == 0 ||
                                likeListModel?.data == []
                            ? Center(
                                child: Text('No Any Favourite Services',
                                    style: TextStyle(
                                        fontFamily: CustomTheme.fontFamily)),
                              )
                            : Scrollbar(
                                child: GridView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: likeListModel?.data != null
                                      ? likeListModel?.data?.length
                                      : 0,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 2,
                                          crossAxisCount: 3),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                        onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WongCheLaiCarCareScreen(
                                                            serviceid: likeListModel
                                                                ?.data?[index]
                                                                .serviceId))).then(
                                                (value) async {
                                              await likeList();
                                            }),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              color: CustomTheme.grey,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                Images.iPointsIcon,
                                                color: CustomTheme.darkGrey,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              color: CustomTheme.grey,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                Images.iPointsIcon,
                                                color: CustomTheme.darkGrey,
                                              ),
                                            ),
                                          ),
                                          imageUrl:
                                              "${likeListModel?.data?[index].image}",
                                          imageBuilder:
                                              (context, imageProvider) {
                                            return Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              // padding: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: imageProvider),
                                              ),

                                              child: Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              Images.shadow),
                                                          fit: BoxFit.fill),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 5),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    3),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    CustomTheme
                                                                        .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                likeDisLike(likeListModel
                                                                        ?.data?[
                                                                            index]
                                                                        .serviceId ??
                                                                    "");
                                                                setState(() {
                                                                  if (likeListModel
                                                                          ?.data?[
                                                                              index]
                                                                          .like ==
                                                                      0) {
                                                                    likeListModel
                                                                        ?.data?[
                                                                            index]
                                                                        .like = 1;
                                                                  } else {
                                                                    likeListModel
                                                                        ?.data?[
                                                                            index]
                                                                        .like = 0;
                                                                  }
                                                                  likeListModel
                                                                      ?.data
                                                                      ?.removeAt(
                                                                          index);
                                                                });
                                                              },
                                                              child: Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  size: 18,
                                                                  color: likeListModel
                                                                              ?.data?[
                                                                                  index]
                                                                              .like ==
                                                                          1
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            '${likeListModel?.data?[index].serviceName}',
                                                            style: CustomTheme
                                                                .body1
                                                                .copyWith(
                                                                    color: CustomTheme
                                                                        .white),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          constraints:
                                                              BoxConstraints(
                                                                  minWidth: 30),
                                                          // color: Colors.green,
                                                          width: 100,
                                                        ),
                                                        Text(
                                                          "10km",
                                                          style: CustomTheme
                                                              .body1
                                                              .copyWith(
                                                                  color:
                                                                      CustomTheme
                                                                          .white),
                                                        ),
                                                        Row(
                                                          children: [
                                                            ...List.generate(
                                                                likeListModel
                                                                            ?.data?[
                                                                                index]
                                                                            .rate ==
                                                                        ""
                                                                    ? 0
                                                                    : 1,

                                                                // likeListModel!
                                                                //             .data![
                                                                //                 index]
                                                                //             .rateCount! >=
                                                                //         1
                                                                //     ? 1
                                                                //     : 0,
                                                                (index) => Row(
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            Images.stick,
                                                                            color:
                                                                                CustomTheme.yellow,
                                                                            scale:
                                                                                4,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                4,
                                                                          )
                                                                        ])),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              "${likeListModel?.data?[index].rate ?? ""}",
                                                              style: TextStyle(
                                                                  color: CustomTheme
                                                                      .yellow),
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            likeListModel
                                                                            ?.data?[
                                                                                index]
                                                                            .rateCount ==
                                                                        0 ||
                                                                    likeListModel
                                                                            ?.data?[index]
                                                                            .rate ==
                                                                        ""
                                                                ? Text("")
                                                                : Text(
                                                                    "(" +
                                                                        Numeral(int.parse(likeListModel?.data?[index].rateCount.toString() ??
                                                                                ""))
                                                                            .value() +
                                                                        ")",
                                                                    style: TextStyle(
                                                                        color: CustomTheme
                                                                            .yellow),
                                                                  ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ));
                                  },
                                ),
                              ),
                  )
                ],
              ),
            ),
          ),
        ),
        Provider.of<InternetConnectivityCheck>(context, listen: true)
                .isNoInternet
            ? NoInterNetScreen()
            : SizedBox.shrink(),
      ],
    );
  }
}

class selectionbutton {
  String? name;
  bool isselected;
  selectionbutton({required this.name, required this.isselected});
}

class Listcards {
  String? name;
  String? img;
  String? icon;
  String? rating;
  String? title;
  bool checked;
  bool selectedchecked;
  Listcards({
    required this.img,
    required this.name,
    required this.icon,
    required this.rating,
    required this.title,
    required this.checked,
    required this.selectedchecked,
  });
}
