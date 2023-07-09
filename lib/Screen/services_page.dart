import 'package:flutter/material.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'no_internet_screen.dart';

class Services_page extends StatefulWidget {
  const Services_page({Key? key}) : super(key: key);

  @override
  _Services_pageState createState() => _Services_pageState();
}

class _Services_pageState extends State<Services_page> {
  var _selectedIndex;
  static List<menuitem> _menuitem = [
    menuitem(img: Images.showroomIcon, name: " Showroom"),
    menuitem(img: Images.cafeIcon, name: "Cafe"),
    menuitem(img: Images.LogisticIcon, name: "Logistic"),
    menuitem(img: Images.performanceIcon, name: "Performance"),
  ];

  List<ListOne> _listOne = [
    ListOne(
        img: Images.coffeImage,
        name: "Services Name",
        icon: Images.coffeCupIcon,
        rating: Images.ratingImage,
        title: "10km"),
    ListOne(
        img: Images.coffeImage,
        name: "Services Name",
        icon: Images.coffeCupIcon,
        rating: Images.ratingImage,
        title: "10km"),
    ListOne(
        img: Images.coffeImage,
        name: "Services Name",
        icon: Images.coffeCupIcon,
        rating: Images.ratingImage,
        title: "10km")
  ];

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    List<Widget> _list = [
      Car(),
      SizedBox(
        width: 20,
      ),
      Car(),
    ];
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Stack(
                          overflow: Overflow.visible,
                          children: [
                            CircleAvatar(
                              radius: 30,
                            ),
                            Positioned(
                              left: -8,
                              top: 15,
                              child: CircleAvatar(
                                backgroundColor: CustomTheme.red,
                                radius: 12,
                                child: Text("99"),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CustomTheme.primarycolor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 2.9,
                              spreadRadius: 2.0,
                              offset: Offset(4.0, 4.0),
                            ),
                            BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 5.0,
                                spreadRadius: 8.0,
                                offset: Offset(6.0, 6.0))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Available',
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                //images
                                Image.asset(
                                  Images.iponitImage,
                                  scale: 3,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '1,50',
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'pts',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                Spacer(),
                                Container(
                                  // height: Height / 20,
                                  //width: Width / 5,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.yellow,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Redeem',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      height: Height / 7,
                      child: Row(
                        children: [
                          Container(
                            height: Height / 6,
                            width: Width / 1.5,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Container(
                                              height: Height / 17,
                                              width: Width / 8,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          Colors.grey.shade300,
                                                      blurRadius: 2.9,
                                                      spreadRadius: 1.0,
                                                      offset: Offset(4.0, 4.0),
                                                    ),
                                                    BoxShadow(
                                                        color: Colors
                                                            .grey.shade200,
                                                        blurRadius: 5.0,
                                                        spreadRadius: 5.0,
                                                        offset:
                                                            Offset(6.0, 6.0))
                                                  ]),
                                              child: InkWell(
                                                onTap: () {},
                                                child: Image.asset(
                                                  _menuitem[index]
                                                      .img
                                                      .toString(),
                                                  scale: 3,
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${_menuitem[index].name}',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                              itemCount: _menuitem.length,
                            ),
                          ),
                          Spacer(),
                          Container(
                            //  color: Colors.black,
                            height: Height / 5,
                            child: Padding(
                              padding: EdgeInsets.only(top: 35),
                              child: Text(
                                "View All",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: CustomTheme.grey,
                          ),
                          height: 60,
                          width: 230,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 5),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            height: 60,
                            width: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: CustomTheme.yellow,
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                Images.searchIcon,
                                scale: 2.5,
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            height: 60,
                            width: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: CustomTheme.grey,
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                Images.ractangleIcon,
                                scale: 2.5,
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 160,
                    child: PageView.builder(
                        itemCount: _list.length,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Car();
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                        _list.length,
                        (index) => Indicator(
                            isActive: _selectedIndex == index ? true : false),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Services within 10km from you",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: CustomTheme.fontFamily),
                    ),
                  ),
                  CardsListOne(),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Top 20 services this April",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: CustomTheme.fontFamily),
                    ),
                  ),
                  CardsListOne(),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "People’s favourite",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: CustomTheme.fontFamily),
                    ),
                  ),
                  CardsListOne(),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
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

  Widget Car() {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              Images.carImage,
              fit: BoxFit.cover,
              height: 150,
              width: 400,
            ),
          ),
          Positioned(
            top: 10,
            right: 20,
            child: Stack(
              children: [
                Image.asset(
                  Images.coffeCupIcon,
                  scale: 2,
                ),
              ],
            ),
          ),
          Positioned(
            left: 8,
            top: 60,
            child: Stack(
              children: [
                Text(
                  'Service Name',
                  style: TextStyle(
                      color: CustomTheme.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: CustomTheme.fontFamily),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Positioned(
                top: 80,
                left: 8,
                child: Text(
                  '10km from you',
                  style: TextStyle(
                      color: CustomTheme.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: CustomTheme.fontFamily),
                ),
              )
            ],
          ),
          Stack(
            children: [
              Positioned(
                top: 100,
                left: 8,
                child: Text(
                  'Best Service for the\n month April',
                  style: TextStyle(
                      color: CustomTheme.yellow,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: CustomTheme.fontFamily),
                ),
              )
            ],
          ),
          Positioned(
            top: 100,
            right: 20,
            child: Stack(
              children: [
                Row(
                  children: [
                    Image.asset(
                      Images.ratingImage,
                      scale: 2,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "(425)",
                      style: TextStyle(
                          color: CustomTheme.yellow,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: CustomTheme.fontFamily),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget CardsListOne() {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            height: Height / 6,
            width: Width,
            child: Row(
              children: [
                Expanded(
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: _listOne.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              margin: EdgeInsets.all(5),
                              height: 120,
                              width: 110,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  // color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          _listOne[index].img.toString()))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset(
                                          _listOne[index].icon.toString()),
                                    ),
                                    alignment: Alignment.topRight,
                                  ),
                                  Spacer(),
                                  Text(
                                    '${_listOne[index].name.toString()}',
                                    style: TextStyle(color: CustomTheme.white),
                                  ),
                                  Text(
                                    '${_listOne[index].title.toString()}',
                                    style: TextStyle(color: CustomTheme.white),
                                  ),
                                  Container(
                                      height: 20,
                                      width: 60,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            _listOne[index].rating.toString(),
                                            scale: 3.5,
                                          ),
                                          Text(
                                            "(450)",
                                            style: TextStyle(
                                                color: CustomTheme.yellow),
                                          ),
                                        ],
                                      )),
                                ],
                              ));
                        })),
                Container(
                  child: Image.asset(
                    Images.showMoreImage,
                    scale: 3.5,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class menuitem {
  String? name;
  String? img;
  menuitem({required this.img, required this.name});
}

class ListOne {
  String? name;
  String? img;
  String? icon;
  String? rating;
  String? title;
  ListOne({
    required this.img,
    required this.name,
    required this.icon,
    required this.rating,
    required this.title,
  });
}

// class Indicator extends StatelessWidget {
//   final bool isActive;
//   const Indicator({
//     Key? key,
//     required this.isActive,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 350),
//       height: 8.0,
//       margin: const EdgeInsets.symmetric(horizontal: 3.0),
//       width: isActive ? 22.0 : 8.0,
//       decoration: BoxDecoration(
//         color: isActive ? CustomTheme.primarycolor : CustomTheme.black,
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//     );
//   }
// }
