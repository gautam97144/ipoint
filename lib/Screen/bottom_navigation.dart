import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ipoint/Screen/booking_page.dart';
import 'package:ipoint/Screen/menu_page.dart';
import 'package:ipoint/Screen/redeem.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/model/homepage_banner_model.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'new_service_screen.dart';

class BottomNavigation extends StatefulWidget {
  int? index;
  int? indexOne;
  BottomNavigation({Key? key, this.index, this.indexOne}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  int isSelected = 0;
  HomePageBannerModel? homePageBannerModel;
  final List = [
    HomePageScreen(),
    NewServiceScreen(),
    Redeem(),
    BookingPage(),
  ];

  get pages => List;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.indexOne == 1) {
      _selectedIndex = 2;
    } else if (widget.index == 2) {
      _selectedIndex = 1;
    } else if (widget.index == 3) {
      _selectedIndex = 3;
    } else {
      _selectedIndex = 0;
    }
    //  ?  :
    // widget.index == 2 ?  : _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _selectedIndex == 2 ? CustomTheme.primarycolor : Colors.white,
      body: List[_selectedIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              offset: const Offset(
                0.2,
                0.2,
              ),
              blurRadius: 10.0,
              // spreadRadius: 1.0,
            ), //BoxShadow
            const BoxShadow(
              color: Colors.white,
              offset: Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ), //BoxShadow
          ],
          // color: CustomTheme.grey,
          borderRadius: BorderRadius.circular(40),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            iconSize: 30,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
                var currentPage = pages[index];
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(Images.homeIcon),
                    color: _selectedIndex == 0
                        ? CustomTheme.primarycolor
                        : Colors.black,
                  ),
                  title: Text('Home',
                      style: CustomTheme.body3.copyWith(fontSize: 14))),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(Images.servicesIcon),
                    color: _selectedIndex == 1
                        ? CustomTheme.primarycolor
                        : Colors.black,
                  ),
                  title: Text('Service',
                      style: CustomTheme.body3.copyWith(fontSize: 14))),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(Images.iPointsIcon),
                    color: _selectedIndex == 2
                        ? CustomTheme.primarycolor
                        : Colors.black,
                  ),
                  title: Text('iPoint',
                      style: CustomTheme.body3.copyWith(fontSize: 14))),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(Images.bookingIcon),
                    color: _selectedIndex == 3
                        ? CustomTheme.primarycolor
                        : Colors.black,
                  ),
                  title: Text('Booking',
                      style: CustomTheme.body3.copyWith(fontSize: 14)))
            ],
          ),
        ),
      ),
    );
  }
}
