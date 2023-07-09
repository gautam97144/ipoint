import 'package:flutter/material.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:ipoint/provider/internet_connectivity_provider.dart';
import 'package:provider/provider.dart';
import 'no_internet_screen.dart';

class ShowMoreScreen extends StatefulWidget {
  const ShowMoreScreen({Key? key}) : super(key: key);

  @override
  _ShowMoreScreenState createState() => _ShowMoreScreenState();
}

class _ShowMoreScreenState extends State<ShowMoreScreen> {
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 12),
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
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: CustomTheme.grey,
                          ),
                          //height: 60,
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
                        Spacer(),
                        Container(
                            padding: EdgeInsets.all(8),
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
                        Spacer(),
                        Container(
                            // height: 60,
                            // width: 55,
                            padding: EdgeInsets.all(8),
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
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Showing results 30 of 3600",
                          style: CustomTheme.body5,
                        ),
                      ],
                    ),
                    GridView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: 10,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 5,
                          crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            child: Stack(
                              children: [
                                Image.asset(
                                  Images.mercedes,
                                ),
                                Positioned(
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        Images.shadow,
                                      ),
                                      Positioned(
                                        top: 5,
                                        left: 75,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 24,
                                              width: 24,
                                              decoration: BoxDecoration(
                                                  color: CustomTheme.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Icon(
                                                Icons.favorite_border,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 60,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Service Name",
                                                style: CustomTheme.body6,
                                              ),
                                              Text(
                                                "10km",
                                                style: CustomTheme.body6,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
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
