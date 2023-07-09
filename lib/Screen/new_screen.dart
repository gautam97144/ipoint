import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Screen/vendor_detail.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/search_model.dart';
import 'package:ipoint/model/service_like.dart';
import 'package:ipoint/model/service_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:numeral/numeral.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewScreen extends StatefulWidget {
  List<SearchData>? data;
  NewScreen({Key? key, this.data}) : super(key: key);

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  bool isloader = false;
  UserModel? userModel;
  ServiceLikeModel? serviceLikeModel;
  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());
    setState(() {
      userModel = UserModel.fromJson(jsondecode);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getModel();
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

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                Text('Services', style: CustomTheme.title),
                SizedBox(
                  height: Height / 30,
                ),
                Scrollbar(
                    child: widget.data?.length == 0 || widget.data == []
                        ? Center(
                            child: Text("No Service"),
                          )
                        : GridView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount:
                                widget.data != null ? widget.data?.length : 0,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 2,
                                    crossAxisCount: 3),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WongCheLaiCarCareScreen(
                                                        //   index:,
                                                        serviceid: widget
                                                            .data?[index]
                                                            .serviceId)))
                                        .then((value) async {});
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${widget.data?[index].image ?? ""}",
                                    placeholder: (context, url) => Container(
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: CustomTheme.grey,
                                        borderRadius: BorderRadius.circular(18),
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
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          Images.iPointsIcon,
                                          color: CustomTheme.darkGrey,
                                        ),
                                      ),
                                    ),
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: CachedNetworkImageProvider(
                                                "${widget.data?[index].image ?? ""}",
                                              )),
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
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 5),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              CustomTheme.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child:

                                                          // ValueListenableBuilder(
                                                          //   valueListenable:
                                                          //       notifylike,
                                                          //   builder: (BuildContext context,
                                                          //       value,
                                                          //       Widget? child) {
                                                          //     // notifylike = serviceModel as ValueNotifier<ServiceModel>;
                                                          //     return GestureDetector(
                                                          //         onTap: () async {
                                                          //           await likeDisLike(notifylike.value.data?[index].serviceId ?? "");
                                                          //
                                                          //           print(notifylike.value.data?[index].like);
                                                          //           if (notifylike.value.data?[index].like == 0) {
                                                          //             notifylike.value.data?[index].like = 1;
                                                          //           } else {
                                                          //             notifylike.value.data?[index].like = 0;
                                                          //           }
                                                          //           print(notifylike.value.data?[index].like);
                                                          //         },
                                                          //         child: Icon(Icons.favorite, size: 18, color: notifylike.value.data?[index].like == 1 ? Colors.red : Colors.black));
                                                          //   },
                                                          // )
                                                          GestureDetector(
                                                        onTap: () {
                                                          likeDisLike(widget
                                                                  .data?[index]
                                                                  .serviceId ??
                                                              "");
                                                          setState(() {
                                                            if (widget
                                                                    .data?[
                                                                        index]
                                                                    .like ==
                                                                0) {
                                                              widget
                                                                  .data?[index]
                                                                  .like = 1;
                                                            } else {
                                                              widget
                                                                  .data?[index]
                                                                  .like = 0;
                                                            }
                                                          });
                                                        },
                                                        child: Icon(
                                                            Icons.favorite,
                                                            size: 18,
                                                            color: widget
                                                                        .data?[
                                                                            index]
                                                                        .like ==
                                                                    1
                                                                ? Colors.red
                                                                : Colors.black),
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      '${widget.data?[index].serviceName ?? ""}',
                                                      style: CustomTheme.body1
                                                          .copyWith(
                                                              color: CustomTheme
                                                                  .white),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    constraints: BoxConstraints(
                                                        minWidth: 30),
                                                    // color: Colors.green,
                                                    width: 100,
                                                  ),
                                                  Text(
                                                    "10km",
                                                    style: CustomTheme.body1
                                                        .copyWith(
                                                            color: CustomTheme
                                                                .white),
                                                  ),
                                                  Row(
                                                    children: [
                                                      ...List.generate(
                                                          widget.data![index]
                                                                      .rateCount! >=
                                                                  1
                                                              ? 1
                                                              : 0,

                                                          //int.parse(serviceModel?.data?[index].rate == "" ? "0" : serviceModel?.data?[index].rate ?? ''),
                                                          (index) =>
                                                              Row(children: [
                                                                Image.asset(
                                                                  Images.stick,
                                                                  color:
                                                                      CustomTheme
                                                                          .yellow,
                                                                  scale: 4,
                                                                ),
                                                                SizedBox(
                                                                  width: 4,
                                                                )
                                                              ])),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      widget.data?[index]
                                                                      .rateCount ==
                                                                  0 ||
                                                              widget
                                                                      .data?[
                                                                          index]
                                                                      .rate ==
                                                                  ""
                                                          ? Text("")
                                                          : Text(
                                                              "(" +
                                                                  Numeral(int.parse(widget
                                                                              .data?[index]
                                                                              .rateCount
                                                                              .toString() ??
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
                          )),
              ]),
        ),
      ),
    );
  }
}
