import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ipoint/Screen/invoice_screen.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

import 'no_internet_screen.dart';

class SwipePayScreen extends StatefulWidget {
  const SwipePayScreen({Key? key}) : super(key: key);

  @override
  _SwipePayScreenState createState() => _SwipePayScreenState();
}

class _SwipePayScreenState extends State<SwipePayScreen> {

  bool value = false;

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "<Back",
                          style: CustomTheme.body3,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome',
                                style: CustomTheme.body3
                                    .copyWith(fontWeight: FontWeight.normal)),
                            Text(
                              'Jane Doe',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: CustomTheme.fontFamily),
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
                              Text("30,560",
                                  style: CustomTheme.body3
                                      .copyWith(fontWeight: FontWeight.w700)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 12),
                                child: Text("pts", style: CustomTheme.body1),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CircleAvatar(
                            child: Text('TK'),
                            radius: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Height / 34,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.shade200,
                          ),
                          //height: 60,
                          width: 230,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                                hintStyle: CustomTheme.body1.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                            // height: 60,
                            // width: 55,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: CustomTheme.yellow,
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                Images.searchIcon,
                                scale: 3,
                              ),
                            )),
                        Spacer(),
                        Container(
                            // height: 60,
                            // width: 55,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: CustomTheme.grey,
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                Images.ractangleIcon,
                                scale: 3,
                              ),
                            ))
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
                          width: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(height: Height / 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text("Description", style: CustomTheme.body2),
                  ),
                  SizedBox(height: Height / 100),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Enim nec dui nunc mattis enim ut tellus. Nulla facilisi nullam vehicula ipsum. Sed euismod nisi porta lorem mollis aliquam ut porttitor leo. Morbi quis commodo odio aenean sed adipiscing diam donec adipiscing. Porta lorem mollis aliquam ut porttitor leo. Iaculis nunc sed augue lacus. Porta non pulvinar neque laoreet suspendisse. Turpis tincidunt id aliquet risus feugiat. Non sodales neque sodales ut etiam sit amet nisl. Vitae ultricies leo integer malesuada nunc vel risus commodo viverra. Id venenatis a condimentum vitae sapien pellentesque. Ac tortor vitae purus faucibus ornare suspendisse sed nisi lacus. Feugiat pretium nibh ipsum consequat nisl vel pretium lectus quam. Diam in arcu cursus euismod quis. Condimentum vitae sapien pellentesque habitant morbi. A erat nam at lectus urna duis.",
                      style: TextStyle(fontSize: 12),
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
                          Text("visits", style: TextStyle(fontSize: 12)),
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

                              },
                              child: Container(
                                height: Height / 10,
                                width: Width / 12,
                                child: Icon(Icons.share),
                              ),
                            ),
                          ),
                          Icon(Icons.mode_comment),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Builder(
                    builder: (context) {
                      final GlobalKey<SlideActionState> _key = GlobalKey();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: SlideAction(
                          elevation: 0,
                          sliderButtonIconSize: 16,
                          height: 60,
                          text: "Swipe to pay",
                          textStyle: CustomTheme.body2,
                          key: _key,
                          onSubmit: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return InVoiceScreen();
                            }));
                            Future.delayed(
                              Duration(seconds: 2),
                              () => _key.currentState?.reset(),
                            );
                          },
                          innerColor: CustomTheme.black,
                          outerColor: CustomTheme.yellow,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Height / 35),
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
