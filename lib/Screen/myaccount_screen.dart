import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipoint/Screen/login_page.dart';
import 'package:ipoint/Screen/verification_screen.dart';
import 'package:ipoint/Widget/custom_profile_picture.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/main_loader/loader_layout.dart';
import 'package:ipoint/model/commonmodel.dart';
import 'package:ipoint/model/profile_picture_model.dart';
import 'package:ipoint/model/usermodel.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:ipoint/provider/location_provider.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'googlemap.dart';
import 'no_internet_screen.dart';
import 'package:sizer/sizer.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  File? image;
  ProfilePictureModel? profilePictureModel;
  //veriable
  bool isSelect = true;
  bool isSelect1 = true;
  bool isSelect2 = true;
  bool isImageValidate = true;

  bool isVisible = false;
  bool isVisible1 = true;
  bool isVisible2 = false;
  bool isVisible3 = true;
  bool isVisible4 = false;
  bool isVisible5 = true;
  bool isVisible6 = false;
  bool isVisible7 = true;
  bool? emailVisible;
  bool? updatedname;
  bool is_loc_selected = false;
  bool? is_map_open;
  bool isImageActive = false;

  bool nameerror = false;
  bool icnumbererror = false;
  bool emailerror = false;
  bool locationerror = false;
  bool is_loading = false;

  String? name, name1, name2, name3;
  String token = '';
  String? emailtext;
  String? updatename;

  bool isRead1 = true;
  bool isRead2 = true;
  bool isRead3 = true;
  bool isRead4 = true;

  String? currentlat;
  String? currentlong;
  String? address;
  String? proImage;
  var newImage;

  UserModel? userModel;
  CommonModel? commonModel;

  TextEditingController nameController = TextEditingController();
  TextEditingController icNumberContoller = TextEditingController();
  TextEditingController emailContoller = TextEditingController();
  TextEditingController addressContoller = TextEditingController();

  //formkey
  final _formkey = GlobalKey<FormState>();
  final _formkey1 = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  final _formkey3 = GlobalKey<FormState>();

  // function

  getModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mydata = (preferences.getString('abc').toString());
    var jsondecode = jsonDecode(mydata.toString());
    setState(() {
      userModel = UserModel.fromJson(jsondecode);
    });
    newImage = userModel?.data?.profile;
    print(userModel?.data?.location);
  }

  setmodel(value) async {
    String data = jsonEncode(value);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("abc", data);
  }

  clearSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('abc');
  }

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter valid email';
    else
      return null;
  }

  checkRealTime() {
    Provider.of<InternetConnectivityCheck>(context, listen: false)
        .checkRealTimeConnectivity();
  }

  Future uploadImage() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      FormData formData = FormData.fromMap(
          {"profile": await MultipartFile.fromFile(image!.path)});

      Response response = await ApiClient().dio.post(Constant.profileImage,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        print(response.data);

        setState(() {
          profilePictureModel = ProfilePictureModel.fromJson(response.data);
          UserModel? tempUserModel = userModel;
          tempUserModel!.data!.profile = profilePictureModel?.data?.profile;
          setmodel(tempUserModel);
        });

        if (profilePictureModel?.success == 1) {
          Fluttertoast.showToast(msg: '${profilePictureModel?.message}');
          // Navigator.pop(context);
        } else {
          Fluttertoast.showToast(msg: '${profilePictureModel?.message}');
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      print(image);
      if (image == null) return;

      final imagetemporary = File(image.path);
      setState(() {
        this.image = imagetemporary;
        Navigator.pop(context);
        isImageActive = true;
      });
      setState(() {
        is_loading = true;
      });
      await uploadImage();
      setState(() {
        is_loading = false;
      });
    } on PlatformException catch (e) {
      print('Failed to Pick Image $e');
    }
  }

  Future updateName() async {
    FormData formData =
        FormData.fromMap({"edit": "name", "name": nameController.text});

    try {
      Response response = await ApiClient().dio.post(Constant.updateName,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        print(response.data);
        userModel = UserModel.fromJson(response.data);

        setState(() {
          userModel?.data?.name = nameController.text;
        });

        if (userModel?.success == 1) {
          setmodel(userModel);
          Fluttertoast.showToast(msg: "${userModel?.message}");
        } else {
          Fluttertoast.showToast(msg: "${userModel?.message}");
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  Future updateICNumber() async {
    FormData formData = FormData.fromMap(
        {"edit": "ic_number", "ic_number": icNumberContoller.text});

    try {
      Response response = await ApiClient().dio.post(Constant.updateNumber,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        print(response.data);
        userModel = UserModel.fromJson(response.data);

        if (userModel?.success == 1) {
          setmodel(userModel);

          Fluttertoast.showToast(msg: "${userModel?.message}");
          return Navigator.push(context,
              MaterialPageRoute(builder: (context) => VerificationScreen()));
        } else {
          Fluttertoast.showToast(msg: "${userModel?.message}");
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  Future updateEmail() async {
    FormData formData =
        FormData.fromMap({"edit": "email", "email": emailContoller.text});

    try {
      Response response = await ApiClient().dio.post(Constant.updateEmail,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        print(response.data);
        userModel = UserModel.fromJson(response.data);

        setState(() {
          userModel?.data?.email = emailContoller.text;
        });

        if (userModel?.success == 1) {
          setmodel(userModel);
          Fluttertoast.showToast(msg: "${userModel?.message}");
        } else {
          Fluttertoast.showToast(msg: "${userModel?.message}");
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  Future updateAddress() async {
    FormData formData = FormData.fromMap({
      "edit": "address",
      "address": address.toString(),
      "latitude": currentlat.toString(),
      "longitude": currentlong.toString(),
    });

    try {
      Response response = await ApiClient().dio.post(Constant.updateAddress,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        userModel = UserModel.fromJson(response.data);

        print(response.data);

        setState(() {
          userModel?.data?.location = address;
        });

        if (userModel?.success == 1) {
          setmodel(userModel);
          Fluttertoast.showToast(msg: "${userModel?.message}");
        } else {
          Fluttertoast.showToast(msg: "${userModel?.message}");
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  gettoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    setState(() {
      this.token = token ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    checkRealTime();
    gettoken();
    getModel();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ],
                    ),
                    SizedBox(height: height / 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: CustomTheme.fontFamily),
                              ),
                              userModel?.data?.name == null
                                  ? Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ))
                                  : Text(
                                      '${userModel?.data?.name}',
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: CustomTheme.fontFamily),
                                    ),
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            _showMyDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: Container(
                              height: height / 13,
                              width: height / 13,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Colors.grey.shade300,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(Images.logoutImage, scale: 3),
                                    Text("Logout",
                                        style: CustomTheme.textStyle.copyWith(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        newImage == null
                            ? CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    AssetImage(Images.profileImage))
                            : CircleAvatar(
                                radius: 35,
                                backgroundImage: image == null
                                    ? CachedNetworkImageProvider(newImage)
                                    : Image.file(image!).image

                                // Image.file(
                                //   image!,
                                //   fit: BoxFit.cover,
                                // ).image
                                )

                        // CustomProfilePicture(
                        //     status: 1,
                        //     url: userModel?.data?.profile)
                      ],
                    ),
                    SizedBox(height: height / 40),
                    Text("My Account", style: CustomTheme.title),
                    SizedBox(height: height / 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Form(
                          key: _formkey,
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  width: width / 4,
                                  child: Text(
                                    "Name",
                                    style: CustomTheme.title4,
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            left: width / 23,
                                            right: width / 23),
                                        child: isSelect
                                            ? Text(
                                                userModel?.data?.name ?? "",
                                                style: CustomTheme.body1
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 15),
                                              )
                                            : Visibility(
                                                visible: true,
                                                child: TextFormField(
                                                  validator: (value) {
                                                    if (value == '') {
                                                      setState(() {
                                                        nameerror = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        nameerror = false;
                                                      });
                                                    }
                                                  },
                                                  controller: nameController,
                                                  readOnly: isRead1,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none),
                                                ),
                                              ))),
                                Visibility(
                                  visible: isVisible,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          height: height / 20,
                                          decoration: BoxDecoration(
                                              color: CustomTheme.primarycolor,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: TextButton(
                                              onPressed: () async {
                                                if (_formkey.currentState!
                                                    .validate()) {
                                                  if (nameerror == false) {
                                                    setState(() {
                                                      is_loading = true;
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    });
                                                    await updateName();
                                                    setState(() {
                                                      is_loading = false;
                                                      isVisible1 = true;
                                                      isVisible = false;
                                                      isRead1 = true;
                                                    });
                                                  }
                                                }
                                              },
                                              child: Text(
                                                'Update',
                                                style: CustomTheme.body2,
                                              ))),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              //    isUserName = !isUserName;
                                              isVisible1 = true;
                                              isVisible = false;
                                              isRead1 = true;
                                              nameerror = false;
                                              isSelect = true;
                                            });
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            color: CustomTheme.red,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: isVisible1,
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          isVisible = true;
                                          isVisible1 = false;
                                          isRead1 = false;
                                          isSelect = false;
                                        });
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  CustomTheme.grey),
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ))),
                                      child: Text("Edit",
                                          style: CustomTheme.body2)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: nameerror,
                          child: Text(
                            'please enter your name',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(height: height / 20),
                        Form(
                          key: _formkey1,
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  width: width / 4,
                                  child: Text(
                                    "IC No",
                                    style: CustomTheme.title4,
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            left: width / 23,
                                            right: width / 23),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == '') {
                                              setState(() {
                                                icnumbererror = true;
                                              });
                                            } else {
                                              setState(() {
                                                icnumbererror = false;
                                              });
                                            }
                                          },
                                          controller: icNumberContoller,
                                          readOnly: isRead2,
                                          decoration: InputDecoration(
                                              border: InputBorder.none),
                                        ))),
                                Visibility(
                                  visible: isVisible2,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          height: height / 20,
                                          decoration: BoxDecoration(
                                              color: CustomTheme.primarycolor,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: TextButton(
                                              onPressed: () {
                                                if (_formkey1.currentState!
                                                    .validate()) {
                                                  if (icnumbererror == false) {
                                                    updateICNumber();
                                                  }
                                                }
                                              },
                                              child: Text(
                                                'Update',
                                                style: CustomTheme.body2,
                                              ))),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isVisible3 = true;
                                              isVisible2 = false;
                                              isRead2 = true;
                                              icnumbererror = false;
                                            });
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            color: CustomTheme.red,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: isVisible3,
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          isVisible2 = true;
                                          isVisible3 = false;
                                          isRead2 = false;
                                        });
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  CustomTheme.grey),
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ))),
                                      child: Text("Edit",
                                          style: CustomTheme.body2)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: icnumbererror,
                          child: Text(
                            'please enter your IC number',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(height: height / 20),
                        Form(
                          key: _formkey2,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: width / 4,
                                  child: Text(
                                    "Email Address",
                                    style: CustomTheme.title4,
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            left: width / 23,
                                            right: width / 23),
                                        child: isSelect1
                                            ? Text(userModel?.data?.email ?? "",
                                                style: CustomTheme.body1
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 15))
                                            : Visibility(
                                                visible: true,
                                                child: TextFormField(
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  validator: (value) {
                                                    if (value == "") {
                                                      setState(() {
                                                        emailerror = true;
                                                        name3 =
                                                            "Please Enter your email";
                                                      });
                                                    } else if (validateEmail(
                                                            value!) !=
                                                        null) {
                                                      setState(() {
                                                        emailerror = true;
                                                        name3 =
                                                            "Enter Valid Email";
                                                      });
                                                    } else {
                                                      setState(() {
                                                        emailerror = false;
                                                        name3 = '';
                                                      });
                                                    }
                                                  },
                                                  controller: emailContoller,
                                                  readOnly: isRead3,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none),
                                                ),
                                              ))),
                                Visibility(
                                  visible: isVisible4,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          height: height / 20,
                                          decoration: BoxDecoration(
                                              color: CustomTheme.primarycolor,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: TextButton(
                                              onPressed: () async {
                                                if (_formkey2.currentState!
                                                    .validate()) {
                                                  if (emailerror == false) {
                                                    setState(() {
                                                      is_loading = true;
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    });
                                                    await updateEmail();
                                                    setState(() {
                                                      is_loading = false;
                                                      isVisible5 = true;
                                                      isVisible4 = false;
                                                      isRead3 = true;
                                                    });
                                                  }
                                                }
                                              },
                                              child: Text(
                                                'Update',
                                                style: CustomTheme.body2,
                                              ))),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isVisible5 = true;
                                              isVisible4 = false;
                                              isRead3 = true;
                                              emailerror = false;
                                              isSelect1 = true;
                                            });
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            color: CustomTheme.red,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: isVisible5,
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          isVisible4 = true;
                                          isVisible5 = false;
                                          isRead3 = false;
                                          isSelect1 = false;
                                        });
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  CustomTheme.grey),
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ))),
                                      child: Text("Edit",
                                          style: CustomTheme.body2)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: emailerror,
                          child: Text(
                            '$name3',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(height: height / 20),
                        Form(
                          key: _formkey3,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: width / 4,
                                  child: Text(
                                    "Address",
                                    style: CustomTheme.title4,
                                  ),
                                ),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    is_map_open == true
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Test())).then(
                                            (value) {
                                              setState(() {
                                                is_loc_selected = true;
                                                address = Provider.of<
                                                            LocationProvider>(
                                                        context,
                                                        listen: false)
                                                    .address;
                                                currentlat = Provider.of<
                                                            LocationProvider>(
                                                        context,
                                                        listen: false)
                                                    .lat;
                                                currentlong = Provider.of<
                                                            LocationProvider>(
                                                        context,
                                                        listen: false)
                                                    .long;

                                                userModel?.data?.location =
                                                    address;
                                              });
                                            },
                                          )
                                        : Text('');
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          left: width / 23, right: width / 23),
                                      child: Text(
                                        userModel?.data?.location ?? "",
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomTheme.body1.copyWith(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15),
                                      )),
                                )),
                                Visibility(
                                  visible: isVisible6,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          height: height / 20,
                                          decoration: BoxDecoration(
                                              color: CustomTheme.primarycolor,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: TextButton(
                                              onPressed: () async {
                                                if (address != null) {
                                                  setState(() {
                                                    is_loading = true;
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                  });
                                                  await updateAddress();
                                                  setState(() {
                                                    is_map_open = false;
                                                    is_loading = false;
                                                    isVisible7 = true;
                                                    isVisible6 = false;
                                                    isRead4 = true;
                                                  });
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "please select your location");
                                                }
                                              },
                                              child: Text(
                                                'Update',
                                                style: CustomTheme.body2,
                                              ))),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              is_map_open = false;
                                              isVisible7 = true;
                                              isVisible6 = false;
                                              isRead4 = true;
                                              locationerror = false;
                                              isSelect = true;
                                            });
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            color: CustomTheme.red,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: isVisible7,
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          is_map_open = true;
                                          isVisible6 = true;
                                          isVisible7 = false;
                                          isRead4 = false;
                                        });
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  CustomTheme.grey),
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ))),
                                      child: Text("Edit",
                                          style: CustomTheme.body2)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: locationerror,
                          child: Text(
                            'Please enter your location',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(height: height / 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: width / 4,
                              child: Text(
                                "Profile Picture",
                                style: CustomTheme.title4,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: TextButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                CustomTheme.grey)),
                                    onPressed: () {
                                      bottomSheet(context);
                                    },
                                    child: Text(
                                      'Choose Profile Picture',
                                      style: TextStyle(
                                        fontFamily: CustomTheme.fontFamily,
                                        color: CustomTheme.black,
                                      ),
                                    )),
                              ),
                            ),
                            // SizedBox(width: 5),
                            // TextButton(
                            //     onPressed: isImageActive == true
                            //         ? () async {
                            //             setState(() {
                            //               is_loading = true;
                            //             });
                            //
                            //             await uploadImage();
                            //
                            //             // setState(() {
                            //             //   is_map_open = true;
                            //             //   isVisible6 = true;
                            //             //   isVisible7 = false;
                            //             //   isRead4 = false;
                            //             // });
                            //             setState(() {
                            //               is_loading = false;
                            //             });
                            //           }
                            //         : null,
                            //     style: ButtonStyle(
                            //         backgroundColor: MaterialStateProperty.all(
                            //             CustomTheme.grey),
                            //         overlayColor: MaterialStateProperty.all(
                            //             Colors.transparent),
                            //         shape: MaterialStateProperty.all(
                            //             RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(30.0),
                            //         ))),
                            //     child: Text("Save", style: CustomTheme.body2)),
                          ],
                        ),
                      ],
                    ),
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
            'Logout',
            style: CustomTheme.body4,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Are you Sure you wont to Logout ?',
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
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                clearSharedPrefs();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Loginpage()),
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Future bottomSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),

        // Colors.white,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              height: 160,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.clear,
                        ),
                      )
                    ],
                  ),
                  Row(children: [
                    const Icon(Icons.image_outlined),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        permissionHandlerStorage();
                      },
                      child: Text(
                        "Gallery",
                        style: CustomTheme.body1.copyWith(color: Colors.black),
                      ),
                    ),
                  ]),
                  SizedBox(height: 20),
                  Row(children: [
                    const Icon(Icons.camera_alt_outlined),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        permissionHandlerCamera();
                      },
                      child: Text(
                        "Camera",
                        style: CustomTheme.body1.copyWith(color: Colors.black),
                      ),
                    ),
                  ]),
                ],
              ),
            );
          });
        });
  }

  Future<void> permissionHandlerCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await pickImage(ImageSource.camera);
      // Navigator.pop(context);
    } else {
      print("denied");
    }
  }

  Future<void> permissionHandlerStorage() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      await pickImage(ImageSource.gallery);
      // Navigator.pop(context);
    } else {
      print("denied");
    }
  }
}
