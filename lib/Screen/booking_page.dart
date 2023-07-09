import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ipoint/Screen/payment_screen.dart';
import 'package:ipoint/Screen/update_booking_screen.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/appointmant_detaile_model.dart';
import 'package:ipoint/model/delete_appoinment_model.dart';
import 'package:ipoint/model/get_appoitment_model.dart';
import 'package:ipoint/model/user_data_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/model/vendor_model.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'car_description_page.dart';
import 'menu_page.dart';
import 'no_internet_screen.dart';

class BookingPage extends StatefulWidget {
  String? deleteid;
  BookingPage({Key? key, this.deleteid}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with SingleTickerProviderStateMixin {
  var newDate;
  TabController? _tabController;
  int selected = 0;
  GetAppointmentsModel? getAppointmentsModel;
  bool? isSelected;
  UserModel? userModel;
  VendorDetailModel? vendorDetailModel;
  DeleteAppointmentModel? deleteAppointmentModel;
  AppointmentDetailModel? appointmentDetailModel;
  bool? screenBlank = false;
  File? image;
  var formatter = NumberFormat('#,##,000');
  UserData? userData;

  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    setState(() {});
    var mydata = (preferences.getString('abc'));
    var jsondecode = jsonDecode(mydata.toString());
    setState(() {
      userModel = UserModel.fromJson(jsondecode);
    });
  }

  Future fetchUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    try {
      Response response = await ApiClient().dio.post(Constant.userData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (mounted) {
        setState(() {
          userData = UserData.fromJson(response.data);
        });
      }
      if (response.statusCode == 200) {
        print("gautam gohil" + response.data.toString() + "gautam gohil");
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
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
          screenBlank = false;
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

  Future deleteAppointment(String appoinmentId) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData = FormData.fromMap({"appointment_id": appoinmentId});

      Response response = await ApiClient().dio.post(Constant.appointmentDelete,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      deleteAppointmentModel = DeleteAppointmentModel.fromJson(response.data);

      if (response.statusCode == 200) {
        print(response.data);
        Fluttertoast.showToast(msg: '${deleteAppointmentModel?.message}');
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  getFormatedDate(date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('d MMM y');
    newDate = outputFormat.format(inputDate);
    return newDate;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    alluserdata();
    getModel();
    getAppointment(3);
  }

  alluserdata() {
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Stack(children: [
      SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(Height / 2.8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    //color: CustomTheme.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Height / 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //crossAxisAlignment: CrossAxisAlignment.,
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
                                      : Text("${userModel?.data?.name}",
                                          // "${Provider.of<UsernameProvider>(context, listen: false).userModel?.data?.name}",

                                          maxLines: 2,
                                          style: CustomTheme.body3.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            //Spacer(),
                            Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(minHeight: 50),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              //height: Height / 17,
                              width: Width / 3,
                              decoration: BoxDecoration(
                                color: CustomTheme.primarycolor,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: IntrinsicWidth(
                                      child: Container(
                                        alignment: Alignment.center,
                                        // color: Colors.green,
                                        child: Text(
                                            Numeral(double.parse(
                                                    "${userModel?.data?.ipointWallet ?? "0"}"))
                                                .value(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: CustomTheme.body3.copyWith(
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    // color: Colors.green,
                                    child: Text(
                                      " pts",
                                      style: CustomTheme.body1,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: 10,
                            ),
                            //Spacer(),
                            CustomProfilePicture(
                                // onTap: (){
                                //   Navigator.push(context,MaterialPageRoute(builder: (context)=>MenuPage()));
                                // },
                                url: userModel?.data?.profile)
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Height / 60,
                  ),
                  Text("Bookings",
                      style: CustomTheme.body7.copyWith(fontSize: 18)),
                  SizedBox(
                    height: Height / 50,
                  ),
                  Expanded(
                    child: TabBar(
                      //padding: EdgeInsets.symmetric(horizontal: 5),
                      isScrollable: true,
                      onTap: (value) {
                        setState(() {
                          selected = value;
                        });
                      },
                      indicatorColor: Colors.transparent,
                      controller: _tabController,
                      tabs: [
                        SizedBox(
                          //width: 120,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                screenBlank = true;
                                selected = 0;
                                getAppointment(3);
                              });
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                backgroundColor: selected == 0
                                    ? MaterialStateProperty.all(Colors.yellow)
                                    : MaterialStateProperty.all(
                                        Colors.grey.withOpacity(.2))),
                            child: Text("Pending",
                                style: TextStyle(
                                    fontSize: 9.5,
                                    fontFamily: CustomTheme.fontFamily,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              screenBlank = true;
                              selected = 1;
                              getAppointment(1);
                            });
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              backgroundColor: selected == 1
                                  ? MaterialStateProperty.all(
                                      CustomTheme.primarycolor)
                                  : MaterialStateProperty.all(
                                      Colors.grey.withOpacity(.2))),
                          child: Text("Booked",
                              style: TextStyle(
                                  fontSize: 9.5,
                                  fontFamily: CustomTheme.fontFamily,
                                  fontWeight: FontWeight.bold)),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              screenBlank = true;
                              selected = 2;
                              getAppointment(2);
                            });
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              backgroundColor: selected == 2
                                  ? MaterialStateProperty.all(Colors.red)
                                  : MaterialStateProperty.all(
                                      Colors.grey.withOpacity(.2))),
                          child: Text("Rejected",
                              style: TextStyle(
                                  fontSize: 8,
                                  color: selected == 2
                                      ? CustomTheme.white
                                      : CustomTheme.black,
                                  fontFamily: CustomTheme.fontFamily,
                                  fontWeight: FontWeight.bold)),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              screenBlank = true;
                              selected = 3;
                              getAppointment(4);
                            });
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              backgroundColor: selected == 3
                                  ? MaterialStateProperty.all(Colors.black)
                                  : MaterialStateProperty.all(
                                      Colors.grey.withOpacity(.2))),
                          child: Text("Done",
                              style: TextStyle(
                                  fontSize: 9.5,
                                  color: selected == 3
                                      ? CustomTheme.white
                                      : CustomTheme.black,
                                  fontFamily: CustomTheme.fontFamily,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      if (selected == 0) ...[
                        screenBlank == true
                            ? Container(
                                child: Center(
                                  child: Text("Loading..."),
                                ),
                              )
                            : getAppointmentsModel?.data == null
                                ? Container(
                                    child: Center(
                                        child: CircularProgressIndicator(
                                    color: CustomTheme.primarycolor,
                                  )))
                                : getAppointmentsModel?.data?.length == 0
                                    ? Center(
                                        child: Text(
                                        "No any Appointment",
                                        style: TextStyle(
                                            fontFamily: CustomTheme.fontFamily),
                                      ))
                                    : Scrollbar(
                                        child: ListView.builder(
                                            itemCount:
                                                getAppointmentsModel != null
                                                    ? getAppointmentsModel!
                                                        .data!.length
                                                    : 0,
                                            itemBuilder: (context, index) {
                                              getFormatedDate(
                                                  getAppointmentsModel
                                                      ?.data?[index]
                                                      .appointmentDate);
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AppointmentDetail(
                                                                      appoitmantId: getAppointmentsModel
                                                                          ?.data?[
                                                                              index]
                                                                          .appointmentId)));
                                                    },
                                                    child: Container(
                                                        width: double.infinity,
                                                        margin: EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                        // height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      .2),
                                                              blurRadius: 2.9,
                                                              spreadRadius: 1.0,
                                                              offset: Offset(
                                                                  4.0, 4.0),
                                                            ),
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .shade200,
                                                              blurRadius: 5.0,
                                                              spreadRadius: 2.0,
                                                              offset: Offset(
                                                                  6.0, 6.0),
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 10),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Container(
                                                                      height:
                                                                          55,
                                                                      width: 50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: CustomTheme
                                                                            .grey,
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child: Image
                                                                            .asset(
                                                                          Images
                                                                              .iPointsIcon,
                                                                          color:
                                                                              CustomTheme.darkGrey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Container(
                                                                      height:
                                                                          55,
                                                                      width: 50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: CustomTheme
                                                                            .grey,
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child: Image
                                                                            .asset(
                                                                          Images
                                                                              .iPointsIcon,
                                                                          color:
                                                                              CustomTheme.darkGrey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    imageUrl:
                                                                        "${getAppointmentsModel?.data?[index].servicesImages}",
                                                                    imageBuilder:
                                                                        (context,
                                                                            imageProvider) {
                                                                      return Container(
                                                                        height:
                                                                            55,
                                                                        width:
                                                                            50,
                                                                        decoration: BoxDecoration(
                                                                            // color: Colors.green,
                                                                            borderRadius: BorderRadius.circular(16),
                                                                            image: DecorationImage(fit: BoxFit.fill, image: imageProvider)),
                                                                      );
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "${getAppointmentsModel?.data?[index].vendorName}",
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: CustomTheme.fontFamily,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              12,
                                                                        ),
                                                                        Text(
                                                                          newDate,
                                                                          //"${getAppointmentsModel?.data?[index].appointmentDate}",
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              fontFamily: CustomTheme.fontFamily,
                                                                              fontWeight: FontWeight.normal),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  // Spacer(),
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(6),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      image: DecorationImage(
                                                                          scale:
                                                                              4,
                                                                          image:
                                                                              CachedNetworkImageProvider("${getAppointmentsModel?.data?[index].catImage}")),
                                                                      color: CustomTheme
                                                                          .primarycolor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    width: 25,
                                                                    height: 25,
                                                                  ),

                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  TextButton(
                                                                      style:
                                                                          ButtonStyle(
                                                                              backgroundColor: MaterialStateProperty.all(CustomTheme
                                                                                  .grey),
                                                                              overlayColor: MaterialStateProperty.all(Colors
                                                                                  .transparent),
                                                                              shape: MaterialStateProperty.all(
                                                                                  RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(30.0),
                                                                              ))),
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.of(context)
                                                                            .push(PageRouteBuilder(
                                                                                opaque: false,
                                                                                fullscreenDialog: true,
                                                                                pageBuilder: (BuildContext context, _, __) => UpdateBookingScreen(
                                                                                      appointmentData: getAppointmentsModel?.data?[index],
                                                                                    )))
                                                                            .then((value) async {
                                                                          await getAppointment(
                                                                              3);
                                                                        });
                                                                      },
                                                                      child: Text(
                                                                          "Edit",
                                                                          style:
                                                                              CustomTheme.body2)),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showDialog<
                                                                          void>(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false, // user must tap button!
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text(
                                                                              'Delete',
                                                                              style: CustomTheme.body4,
                                                                            ),
                                                                            content:
                                                                                SingleChildScrollView(
                                                                              child: ListBody(
                                                                                children: [
                                                                                  Text('Are you Sure you want to delete appointment ?', style: TextStyle(fontFamily: CustomTheme.fontFamily, fontSize: 15)),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            actions: [
                                                                              TextButton(
                                                                                child: Text('No', style: CustomTheme.body1),
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                              ),
                                                                              TextButton(
                                                                                child: Text('Delete', style: CustomTheme.body1.copyWith(color: CustomTheme.red)),
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    deleteAppointment("${getAppointmentsModel?.data?[index].appointmentId}");
                                                                                    getAppointmentsModel?.data?.removeAt(index);
                                                                                  });
                                                                                  Navigator.pop(context);
                                                                                },
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          Height /
                                                                              22,
                                                                      width:
                                                                          Width /
                                                                              12,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              6),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: CustomTheme
                                                                            .red,
                                                                        borderRadius:
                                                                            BorderRadius.circular(14),
                                                                      ),
                                                                      child: Image
                                                                          .asset(
                                                                        Images
                                                                            .deleteIcon,
                                                                        scale:
                                                                            2.5,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              );
                                            }),
                                      ),
                      ] else if (selected == 1) ...[
                        screenBlank == true
                            ? Container(
                                child: Center(
                                  child: Text("Loading..."),
                                ),
                              )
                            : getAppointmentsModel?.data == null
                                ? Container(
                                    child: Center(
                                        child: CircularProgressIndicator(
                                    color: CustomTheme.primarycolor,
                                  )))
                                : getAppointmentsModel?.data?.length == 0
                                    ? Center(
                                        child: Text(
                                        "No any Appointment",
                                        style: TextStyle(
                                            fontFamily: CustomTheme.fontFamily),
                                      ))
                                    : Scrollbar(
                                        child: ListView.builder(
                                            itemCount:
                                                getAppointmentsModel != null
                                                    ? getAppointmentsModel!
                                                        .data!.length
                                                    : 0,
                                            itemBuilder: (context, index) {
                                              getFormatedDate(
                                                  getAppointmentsModel
                                                      ?.data?[index]
                                                      .appointmentDate);

                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                        width: double.infinity,
                                                        margin: EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                        // height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      .2),
                                                              blurRadius: 2.9,
                                                              spreadRadius: 1.0,
                                                              offset: Offset(
                                                                  4.0, 4.0),
                                                            ),
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .shade200,
                                                              blurRadius: 5.0,
                                                              spreadRadius: 2.0,
                                                              offset: Offset(
                                                                  6.0, 6.0),
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 10),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Container(
                                                                      height:
                                                                          55,
                                                                      width: 50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: CustomTheme
                                                                            .grey,
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child: Image
                                                                            .asset(
                                                                          Images
                                                                              .iPointsIcon,
                                                                          color:
                                                                              CustomTheme.darkGrey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Container(
                                                                      height:
                                                                          55,
                                                                      width: 50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: CustomTheme
                                                                            .grey,
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child: Image
                                                                            .asset(
                                                                          Images
                                                                              .iPointsIcon,
                                                                          color:
                                                                              CustomTheme.darkGrey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    imageUrl:
                                                                        "${getAppointmentsModel?.data?[index].servicesImages}",
                                                                    imageBuilder:
                                                                        (context,
                                                                            imageProvider) {
                                                                      return Container(
                                                                        height:
                                                                            55,
                                                                        width:
                                                                            50,
                                                                        decoration: BoxDecoration(
                                                                            // color: Colors.green,
                                                                            borderRadius: BorderRadius.circular(16),
                                                                            image: DecorationImage(fit: BoxFit.fill, image: imageProvider)),
                                                                      );
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "${getAppointmentsModel?.data?[index].vendorName}",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: CustomTheme.fontFamily,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              12,
                                                                        ),
                                                                        Text(
                                                                          newDate,
                                                                          // "${getAppointmentsModel?.data?[index].appointmentDate}",
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              fontFamily: CustomTheme.fontFamily,
                                                                              fontWeight: FontWeight.normal),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(6),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      image: DecorationImage(
                                                                          scale:
                                                                              4,
                                                                          image:
                                                                              CachedNetworkImageProvider("${getAppointmentsModel?.data?[index].catImage}")),
                                                                      color: CustomTheme
                                                                          .primarycolor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    width: 25,
                                                                    height: 25,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              );
                                            }),
                                      ),
                      ] else if (selected == 2) ...[
                        screenBlank == true
                            ? Container(
                                child: Center(
                                  child: Text("Loading..."),
                                ),
                              )
                            : getAppointmentsModel == null
                                ? Container(
                                    child: Center(
                                        child: CircularProgressIndicator(
                                    color: CustomTheme.primarycolor,
                                  )))
                                : getAppointmentsModel?.data?.length == 0
                                    ? Center(
                                        child: Text(
                                        "No any Appointment",
                                        style: TextStyle(
                                            fontFamily: CustomTheme.fontFamily),
                                      ))
                                    : Scrollbar(
                                        child: ListView.builder(
                                            itemCount:
                                                getAppointmentsModel != null
                                                    ? getAppointmentsModel!
                                                        .data!.length
                                                    : 0,
                                            itemBuilder: (context, index) {
                                              getFormatedDate(
                                                  getAppointmentsModel
                                                      ?.data?[index]
                                                      .appointmentDate);
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                        width: double.infinity,
                                                        margin: EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                        // height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      .2),
                                                              blurRadius: 2.9,
                                                              spreadRadius: 1.0,
                                                              offset: Offset(
                                                                  4.0, 4.0),
                                                            ),
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .shade200,
                                                              blurRadius: 5.0,
                                                              spreadRadius: 2.0,
                                                              offset: Offset(
                                                                  6.0, 6.0),
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 10),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Container(
                                                                      height:
                                                                          55,
                                                                      width: 50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: CustomTheme
                                                                            .grey,
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child: Image
                                                                            .asset(
                                                                          Images
                                                                              .iPointsIcon,
                                                                          color:
                                                                              CustomTheme.darkGrey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Container(
                                                                      height:
                                                                          55,
                                                                      width: 50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: CustomTheme
                                                                            .grey,
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child: Image
                                                                            .asset(
                                                                          Images
                                                                              .iPointsIcon,
                                                                          color:
                                                                              CustomTheme.darkGrey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    imageUrl:
                                                                        "${getAppointmentsModel?.data?[index].servicesImages}",
                                                                    imageBuilder:
                                                                        (context,
                                                                            imageProvider) {
                                                                      return Container(
                                                                        height:
                                                                            55,
                                                                        width:
                                                                            50,
                                                                        decoration: BoxDecoration(
                                                                            // color: Colors.green,
                                                                            borderRadius: BorderRadius.circular(16),
                                                                            image: DecorationImage(fit: BoxFit.fill, image: imageProvider)),
                                                                      );
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "${getAppointmentsModel?.data?[index].vendorName}",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: CustomTheme.fontFamily,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              12,
                                                                        ),
                                                                        Text(
                                                                          newDate,
                                                                          //"${getAppointmentsModel?.data?[index].appointmentDate}",
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              fontFamily: CustomTheme.fontFamily,
                                                                              fontWeight: FontWeight.normal),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  // Spacer(),
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(6),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      image: DecorationImage(
                                                                          scale:
                                                                              4,
                                                                          image:
                                                                              CachedNetworkImageProvider("${getAppointmentsModel?.data?[index].catImage}")),
                                                                      color: CustomTheme
                                                                          .primarycolor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    width: 25,
                                                                    height: 25,
                                                                  ),

                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              );
                                            }),
                                      ),
                      ] else ...[
                        screenBlank == true
                            ? Container(
                                child: Center(
                                  child: Text("Loading..."),
                                ),
                              )
                            : getAppointmentsModel == null
                                ? Container(
                                    child: Center(
                                        child: CircularProgressIndicator(
                                    color: CustomTheme.primarycolor,
                                  )))
                                : getAppointmentsModel?.data?.length == 0
                                    ? Center(
                                        child: Text(
                                        "No any Appointment",
                                        style: TextStyle(
                                            fontFamily: CustomTheme.fontFamily),
                                      ))
                                    : Scrollbar(
                                        isAlwaysShown: true,
                                        child: ListView.builder(
                                          itemCount:
                                              getAppointmentsModel != null
                                                  ? getAppointmentsModel!
                                                      .data!.length
                                                  : 0,
                                          itemBuilder: (context, index) {
                                            getFormatedDate(getAppointmentsModel
                                                ?.data?[index].appointmentDate);
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                      width: double.infinity,
                                                      margin: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      // height: 100,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    .2),
                                                            blurRadius: 2.9,
                                                            spreadRadius: 1.0,
                                                            offset: Offset(
                                                                4.0, 4.0),
                                                          ),
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey.shade200,
                                                            blurRadius: 5.0,
                                                            spreadRadius: 2.0,
                                                            offset: Offset(
                                                                6.0, 6.0),
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                CachedNetworkImage(
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Container(
                                                                    height: 55,
                                                                    width: 50,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: CustomTheme
                                                                          .grey,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child: Image
                                                                          .asset(
                                                                        Images
                                                                            .iPointsIcon,
                                                                        color: CustomTheme
                                                                            .darkGrey,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Container(
                                                                    height: 55,
                                                                    width: 50,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: CustomTheme
                                                                          .grey,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child: Image
                                                                          .asset(
                                                                        Images
                                                                            .iPointsIcon,
                                                                        color: CustomTheme
                                                                            .darkGrey,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  imageUrl:
                                                                      "${getAppointmentsModel?.data?[index].servicesImages}",
                                                                  imageBuilder:
                                                                      (context,
                                                                          imageProvider) {
                                                                    return Container(
                                                                      height:
                                                                          55,
                                                                      width: 50,
                                                                      decoration: BoxDecoration(
                                                                          // color: Colors.green,
                                                                          borderRadius: BorderRadius.circular(16),
                                                                          image: DecorationImage(fit: BoxFit.fill, image: imageProvider)),
                                                                    );
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "${getAppointmentsModel?.data?[index].vendorName}",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                CustomTheme.fontFamily,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            12,
                                                                      ),
                                                                      Text(
                                                                        newDate,
                                                                        //"${getAppointmentsModel?.data?[index].appointmentDate}",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            fontFamily:
                                                                                CustomTheme.fontFamily,
                                                                            fontWeight: FontWeight.normal),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                // Spacer(),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              6),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image: DecorationImage(
                                                                        scale:
                                                                            4,
                                                                        image: CachedNetworkImageProvider(
                                                                            "${getAppointmentsModel?.data?[index].catImage}")),
                                                                    color: CustomTheme
                                                                        .primarycolor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  width: 25,
                                                                  height: 25,
                                                                ),

                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                TextButton(
                                                                    style:
                                                                        ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all(CustomTheme
                                                                                .grey),
                                                                            overlayColor: MaterialStateProperty.all(Colors
                                                                                .transparent),
                                                                            shape: MaterialStateProperty.all(
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(30.0),
                                                                            ))),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => PaymentScreen(getAppointmentsModel: getAppointmentsModel?.data?[index])));
                                                                    },
                                                                    child: Text(
                                                                        "View",
                                                                        style: CustomTheme
                                                                            .body2)),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                      ],
                      Container(),
                      Container(),
                      Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Provider.of<InternetConnectivityCheck>(context, listen: true).isNoInternet
          ? NoInterNetScreen()
          : SizedBox.shrink()
    ]);
  }
}
