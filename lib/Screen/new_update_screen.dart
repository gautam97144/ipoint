import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipoint/Screen/copy_link_screen.dart';
import 'package:ipoint/Screen/new_updateAppointment_screen.dart';
import 'package:ipoint/Screen/selected_date_screen.dart';
import 'package:ipoint/Screen/services_page.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';

import 'home_screen.dart';

class NewUpdateScreen extends StatefulWidget {
  const NewUpdateScreen({Key? key}) : super(key: key);

  @override
  _NewUpdateScreenState createState() => _NewUpdateScreenState();
}

class _NewUpdateScreenState extends State<NewUpdateScreen> {
  var _selectedIndex;
  bool value = false;

  List _imgList = [
    Images.carImage,
    Images.carImage,
    Images.carImage,
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> _list = [
      Car(),
      SizedBox(
        width: 20,
      ),
      Car(),
    ];
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
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
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Jane Doe',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Container(
                      height: Height / 17,
                      width: Width / 3,
                      decoration: BoxDecoration(
                        color: CustomTheme.primarycolor,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "30,560",
                            style: CustomTheme.subtitle,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 14),
                            child: Text(
                              "pts",
                              style: CustomTheme.body1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CircleAvatar(
                        //child: Text(),
                        radius: 35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Wong Che Lai Car Care",
                          style: CustomTheme.body3,
                        ),
                        SizedBox(height: 5),
                        Row(children: [
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
                            width: 7,
                          ),
                          SizedBox(
                            width: Width / 6,
                            height: Height / 25,
                            child: TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  backgroundColor: MaterialStateProperty.all(
                                      CustomTheme.yellow)),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Edit",
                                    style: CustomTheme.body1,
                                  ),
                                  Image.asset(Images.editIcon)
                                ],
                              ),
                            ),
                          )
                        ]),
                      ],
                    ),
                    Spacer(),
                    Container(
                      height: Height / 15,
                      width: Width / 8,
                      decoration: BoxDecoration(
                          color: CustomTheme.primarycolor,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 2.9,
                              spreadRadius: 1.0,
                              offset: Offset(4.0, 4.0),
                            ),
                          ]),
                      child: Image.asset(
                        Images.showroomIcon,
                        scale: 3,
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    Container(
                      height: Height / 20,
                      width: Width / 10,
                      decoration: BoxDecoration(
                          color: CustomTheme.grey,
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(
                        Icons.favorite_border,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                child: CarouselSlider(
                  items: _imgList
                      .map((item) => Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Image(
                              width: Width / 1,
                              image: AssetImage(item),
                            ),
                          ))
                      .toList(),
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
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    _imgList.length,
                    (index) => Indicator(
                        isActive: _selectedIndex == index ? true : false),
                  )
                ],
              ),

              // Row(children: [
              //   Container(
              //     padding: EdgeInsets.symmetric(horizontal: 12),
              //     height: Height / 8,
              //     width: Width,
              //     //decoration: BoxDecoration(color: CustomTheme.yellow),
              //     child: ListView.builder(
              //         itemCount: 4,
              //         scrollDirection: Axis.horizontal,
              //         itemBuilder: (context, index) {
              //           return Row(children: [
              //             Container(
              //               // child: Image.asset(
              //               //   Images.newUpdate,
              //               //   scale: 2,
              //               // ),
              //               width: 100,
              //               height: 100,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(25),
              //                   // color: Colors.red,
              //                   image: DecorationImage(
              //                       image: AssetImage(Images.newUpdate),
              //                       fit: BoxFit.cover)),
              //             ),
              //             SizedBox(
              //               width: 7,
              //             ),
              //           ]);
              //         }),
              //   ),
              //   Container(
              //     width: 100,
              //     height: 100,
              //     decoration: BoxDecoration(
              //         color: Colors.green,
              //         borderRadius: BorderRadius.circular(25)),
              //   )
              // ]),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text("Description", style: CustomTheme.body2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Enim nec dui nunc mattis enim ut tellus. Nulla facilisi nullam vehicula ipsum. Sed euismod nisi porta lorem mollis aliquam ut porttitor leo. Morbi quis commodo odio aenean sed adipiscing diam donec adipiscing. Porta lorem mollis aliquam ut porttitor leo. Iaculis nunc sed augue lacus. Porta non pulvinar neque laoreet suspendisse. Turpis tincidunt id aliquet risus feugiat. Non sodales neque sodales ut etiam sit amet nisl. Vitae ultricies leo integer malesuada nunc vel risus commodo viverra. Id venenatis a condimentum vitae sapien pellentesque. Ac tortor vitae purus faucibus ornare suspendisse sed nisi lacus. Feugiat pretium nibh ipsum consequat nisl vel pretium lectus quam. Diam in arcu cursus euismod quis. Condimentum vitae sapien pellentesque habitant morbi. A erat nam at lectus urna duis.",
                  style: CustomTheme.body1,
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text("The Services", style: CustomTheme.body2),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Wrap(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: Height / 30,
                        width: Width / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: CustomTheme.primarylightcolor),
                        child: Center(
                            child: Text(
                          "Repair/Services",
                          style: CustomTheme.body7,
                        )),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: Height / 30,
                        width: Width / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: CustomTheme.primarylightcolor),
                        child: Center(
                            child: Text(
                          "Battery Change",
                          style: CustomTheme.body7,
                        )),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: Height / 30,
                        width: Width / 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: CustomTheme.primarylightcolor),
                        child: Center(
                            child: Text(
                          "Tyre",
                          style: CustomTheme.body7,
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: Height / 30,
                          width: Width / 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: CustomTheme.primarylightcolor),
                          child: Center(
                              child: Text(
                            "Engine Overhaul",
                            style: CustomTheme.body7,
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: Height / 30,
                          width: Width / 3.6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: CustomTheme.primarylightcolor),
                          child: Center(
                              child: Text(
                            "Performance",
                            style: CustomTheme.body7,
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Height / 30),
              Visibility(
                visible: value,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: Height / 9.5,
                      width: Width / 1.4,
                      margin: EdgeInsets.only(right: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 2.5,
                            spreadRadius: 0.0,
                            offset: Offset(2.0, 4.0),
                          ),
                          BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                              offset: Offset(2.0, 5.0))
                        ],
                        color: CustomTheme.primarycolor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      opaque: false,
                                      fullscreenDialog: true,
                                      pageBuilder:
                                          (BuildContext context, _, __) =>
                                              CopyLinkScreen()));
                                },
                                child: Image.asset(Images.personImag)),
                            Image.asset(Images.whatsappImg),
                            Image.asset(Images.facebookImg),
                            Image.asset(Images.linkedinImg),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: Height / 15,
                  width: Width / 1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: CustomTheme.grey),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        child: Image.asset(
                          Images.retingBlack,
                          scale: 3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: VerticalDivider(
                          color: CustomTheme.black,
                        ),
                      ),
                      Text("2000", style: CustomTheme.body3),
                      Text("visits", style: CustomTheme.body1),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: VerticalDivider(
                          color: CustomTheme.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              value = !value;
                            });
                          },
                          child: Container(
                            height: Height / 10,
                            width: Width / 12,
                            decoration: BoxDecoration(
                                color: value
                                    ? CustomTheme.primarycolor
                                    : CustomTheme.grey,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                            child: Icon(Icons.share),
                          ),
                        ),
                      ),
                      Icon(Icons.mode_comment),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Height / 24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Current Booking",
                  style: CustomTheme.body2,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                      //color: Colors.white,
                      height: 200,
                      width: double.infinity,
                      child: ListView.builder(
                          itemCount: 3,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Row(children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                height: Height / 5,
                                width: Width / 2.7,
                                decoration: BoxDecoration(
                                    color: CustomTheme.yellow,
                                    borderRadius: BorderRadius.circular(40)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                                AssetImage(Images.agentProfile),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Chan Siang Jack",
                                              style: CustomTheme.body1
                                                  .copyWith(fontSize: 14),
                                            ),
                                          )
                                        ]),
                                    SizedBox(
                                      height: 33,
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewUpdateAppointment()));
                                        },
                                        child: Text(
                                          "Request Payment",
                                          style: CustomTheme.body1,
                                        ),
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            )),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    CustomTheme.primarycolor)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 7,
                              )
                            ]);
                          })

                      //   Row(children: [
                      //
                      //     Container(
                      //       height: Height / 5,
                      //       width: Width / 3,
                      //       decoration: BoxDecoration(
                      //           color: CustomTheme.yellow,
                      //           borderRadius: BorderRadius.circular(20)),
                      //     ),
                      //
                      //   ]),
                      // ),
                      )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                      //color: Colors.white,
                      height: 200,
                      width: double.infinity,
                      child: ListView.builder(
                          itemCount: 3,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Row(children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                height: Height / 5,
                                width: Width / 2.7,
                                decoration: BoxDecoration(
                                    color: CustomTheme.lightGrey,
                                    borderRadius: BorderRadius.circular(40)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                                AssetImage(Images.agentProfile),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Chan Siang Jack",
                                              style: CustomTheme.body1
                                                  .copyWith(fontSize: 14),
                                            ),
                                          )
                                        ]),
                                    SizedBox(
                                      height: 33,
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "More Detail",
                                          style: CustomTheme.body1,
                                        ),
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            )),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    CustomTheme.yellow)),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 13,
                                          child: Icon(
                                            Icons.clear,
                                            color: CustomTheme.white,
                                          ),
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.green,
                                          radius: 13,
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 7,
                              )
                            ]);
                          })

                      //   Row(children: [
                      //
                      //     Container(
                      //       height: Height / 5,
                      //       width: Width / 3,
                      //       decoration: BoxDecoration(
                      //           color: CustomTheme.yellow,
                      //           borderRadius: BorderRadius.circular(20)),
                      //     ),
                      //
                      //   ]),
                      // ),
                      ))
            ],
          ),
        ),
      ),
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

  Widget sharePopUp() {
    return Container();
  }
}
