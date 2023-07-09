import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/services_page.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/appointmant_detaile_model.dart';
import 'package:ipoint/model/payment_history_model.dart';
import 'package:ipoint/model/service_like_model.dart';
import 'package:ipoint/model/vendor_model.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'no_internet_screen.dart';

class AppointmentDetail extends StatefulWidget {
  String? appoitmantId;
  int? payment_mode;
  PaymentData? payment_date;
  AppointmentDetail({
    Key? key,
    this.appoitmantId,
    this.payment_mode,
    this.payment_date,
  }) : super(key: key);

  @override
  _AppointmentDetailState createState() => _AppointmentDetailState();
}

class _AppointmentDetailState extends State<AppointmentDetail> {
  var _selectedIndex;
  int intialindex = 0;
  bool value = false;

  AppointmentDetailModel? appointmentDetaileModel;
  VendorDetailModel? vendorDetailModel;
  ServiceRatingModel? serviceRatingModel;
  String newDate = "mm-dd";

  getFormatedDate(date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('d MMM y');
    newDate = outputFormat.format(inputDate);
    return newDate;
  }

  Future appoitmanDetails() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData =
          FormData.fromMap({"appointment_id": widget.appoitmantId});

      Response response = await ApiClient().dio.post(Constant.appointmentDetail,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          appointmentDetaileModel =
              AppointmentDetailModel.fromJson(response.data);
        });
        getFormatedDate(appointmentDetaileModel?.data?.appointmentDate);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    appoitmanDetails();
    print(widget.payment_mode);
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            body: appointmentDetaileModel?.data == null
                ? Center(
                    child: CircularProgressIndicator(
                    color: CustomTheme.primarycolor,
                  ))
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    child: SingleChildScrollView(
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
                          Text("Bookings", style: CustomTheme.title),
                          SizedBox(height: Height / 30),
                          Row(
                            children: [
                              Text(
                                "Booked on",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: CustomTheme.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: CustomTheme.fontFamily),
                              ),
                              SizedBox(width: 8),
                              Text(
                                newDate,
                                //"${appointmentDetaileModel?.data?.appointmentDate}",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: CustomTheme.darkblue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: CustomTheme.fontFamily),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Height / 100,
                          ),
                          widget.payment_mode == 1
                              ? Visibility(
                                  visible: true,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Paid with  ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: CustomTheme.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: CustomTheme.fontFamily),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "ipoint"
                                        // "${widget.payment_date?.payCreatedAt}"

                                        ,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: CustomTheme.darkblue,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: CustomTheme.fontFamily),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                          SizedBox(height: Height / 30),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${appointmentDetaileModel?.data?.vendorName}",
                                  style: CustomTheme.body3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 5),
                              Spacer(),
                              Container(
                                width: 45,
                                height: Height / 18,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        scale: 3,
                                        image: CachedNetworkImageProvider(
                                            "${appointmentDetaileModel?.data?.catImage}")),
                                    color: CustomTheme.primarycolor,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 2.9,
                                        spreadRadius: 1.0,
                                        offset: Offset(4.0, 4.0),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                                text: '10km',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline),
                                children: [
                                  TextSpan(
                                    text: 'away',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: Height / 70,
                          ),
                          CarouselSlider(
                            items: [
                              for (int i = 0;
                                  i <
                                      (appointmentDetaileModel != null
                                          ? appointmentDetaileModel!
                                              .data!.banner!.length
                                          : 0);
                                  i++)
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        width: Width / 1,
                                        color: CustomTheme.grey,
                                        child: Center(
                                          child: Image.asset(
                                            Images.iPointsIcon,
                                            color: CustomTheme.darkGrey,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                              width: Width / 1,
                                              color: CustomTheme.grey,
                                              child: Center(
                                                child: Image.asset(
                                                  Images.iPointsIcon,
                                                  color: CustomTheme.darkGrey,
                                                ),
                                              )),
                                      imageUrl:
                                          '${appointmentDetaileModel?.data?.banner?[i].image}',
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          width: Width / 1,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: imageProvider)),
                                        );
                                      },
                                    )

                                    //   Image(
                                    //       width: Width / 1,
                                    //       fit: BoxFit.fill,
                                    //       image: CachedNetworkImageProvider(
                                    //           "${appointmentDetaileModel?.data?.banner?[i].image}")),
                                    ),
                            ],
                            options: CarouselOptions(
                              onPageChanged: (index, _) {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              autoPlay: true,
                              viewportFraction: 1,
                              aspectRatio: 2.7,
                              enlargeCenterPage: true,
                              reverse: false,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                          SizedBox(height: Height / 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(
                                appointmentDetaileModel?.data?.banner?.length ??
                                    0,
                                (index) => Indicator(
                                    isActive:
                                        _selectedIndex == index ? true : false),
                              )
                            ],
                          ),
                          SizedBox(height: Height / 30),
                          Text("Description", style: CustomTheme.body2),
                          SizedBox(height: Height / 90),
                          Container(
                            //constraints: BoxConstraints(minHeight: 70),
                            child: Text(
                              "${appointmentDetaileModel?.data?.description}",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: CustomTheme.fontFamily),
                            ),
                          ),
                          SizedBox(height: Height / 34),
                          Text("The services you booked for",
                              style: CustomTheme.body2),
                          SizedBox(height: Height / 50),
                          Wrap(
                            runSpacing: 13,
                            spacing: 10,
                            children: [
                              for (int i = 0;
                                  i <
                                      (appointmentDetaileModel
                                              ?.data?.services?.length ??
                                          0);
                                  i++)
                                ...List.generate(
                                    appointmentDetaileModel!
                                            .data!.services![i].isSelected ??
                                        0, (index) {
                                  return IntrinsicWidth(
                                    child: Wrap(
                                      children: [
                                        Container(
                                          //height: 40,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 5),
                                          constraints:
                                              BoxConstraints(minHeight: 40),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: CustomTheme
                                                  .primarylightcolor),
                                          child: Wrap(
                                            children: [
                                              Text(
                                                "${appointmentDetaileModel?.data?.services?[i].serviceName}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: CustomTheme.body7
                                                    .copyWith(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            ],
                          ),
                          SizedBox(height: Height / 30),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        Provider.of<InternetConnectivityCheck>(context, listen: true)
                .isNoInternet
            ? NoInterNetScreen()
            : SizedBox.shrink()
      ],
    );
  }

  Widget Car() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          Images.carImage,
          fit: BoxFit.cover,
          height: 150,
          width: 400,
        ),
      ),
    );
  }
}

class IndicatorSelected extends StatelessWidget {
  final bool isActive;
  const IndicatorSelected({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      width: isActive ? 22.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? CustomTheme.primarycolor : CustomTheme.black,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
