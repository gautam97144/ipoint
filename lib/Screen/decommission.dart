import 'package:flutter/material.dart';
import 'package:ipoint/Widget/custom_large_yellow_button.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';

import 'commission.dart';
import 'decommission_second.dart';

class Decommission extends StatefulWidget {
  const Decommission({Key? key}) : super(key: key);

  @override
  _DecommissionState createState() => _DecommissionState();
}

class _DecommissionState extends State<Decommission> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.7),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  )),
                  backgroundColor:
                      MaterialStateProperty.all(CustomTheme.yellow)),
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        opaque: false,
                        fullscreenDialog: true,
                        pageBuilder: (BuildContext context, _, __) =>
                            DecommissionSecond()));
              },
              child: Text(
                "Confirm Changes",
                style: CustomTheme.body2,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.clear,
                            size: 35,
                            color: CustomTheme.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height / 25,
                    ),
                    Text(
                      "Reason For Changes",
                      style: CustomTheme.body1.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height / 25,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 7),
                      width: double.infinity,
                      height: height / 6,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                      decoration: BoxDecoration(
                          // color: CustomTheme.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundImage: AssetImage(Images.agentProfile),
                            ),
                            SizedBox(width: width / 13),
                            Container(
                              //color: Colors.red,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Robert Wong Lee",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomTheme.body1.copyWith(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Agent since : ",
                                        style: CustomTheme.body1.copyWith(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                      Text(
                                        "20 Feb 2021",
                                        style: CustomTheme.body1.copyWith(
                                            color: Colors.white, fontSize: 13),
                                      )
                                    ],
                                  ),
                                  Row(children: [
                                    Text(
                                      "Sales Received : ",
                                      style: CustomTheme.body1.copyWith(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "RM 25000",
                                      style: CustomTheme.body1.copyWith(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                                ],
                              ),
                            ),

                            // Column(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Container(
                            //         decoration: BoxDecoration(
                            //             color: CustomTheme.yellow,
                            //             borderRadius: BorderRadius.circular(15)),
                            //         height: height / 18,
                            //         width: width / 5,
                            //         alignment: Alignment.center,
                            //         padding: EdgeInsets.all(5),
                            //         child: Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             children: [
                            //               Expanded(
                            //                 child: Text(
                            //                   "30",
                            //                   style: CustomTheme.body1,
                            //                 ),
                            //               ),
                            //               GestureDetector(
                            //                 onTap: () {
                            //                   Navigator.push(
                            //                       context,
                            //                       PageRouteBuilder(
                            //                           opaque: false,
                            //                           fullscreenDialog: true,
                            //                           pageBuilder:
                            //                               (BuildContext context,
                            //                                       _, __) =>
                            //                                   Commission()));
                            //                 },
                            //                 child: Image.asset(
                            //                   Images.editIcon,
                            //                   scale: 3,
                            //                 ),
                            //               )
                            //             ]),
                            //
                            //         // width: double.infinity,
                            //       ),
                            //       TextButton(
                            //         style: ButtonStyle(
                            //             shape: MaterialStateProperty.all(
                            //                 RoundedRectangleBorder(
                            //                     borderRadius:
                            //                         BorderRadius.circular(20))),
                            //             backgroundColor:
                            //                 MaterialStateProperty.all(
                            //                     CustomTheme.darkGrey)),
                            //         onPressed: () {
                            //           Navigator.push(
                            //               context,
                            //               PageRouteBuilder(
                            //                   opaque: false,
                            //                   fullscreenDialog: true,
                            //                   pageBuilder:
                            //                       (BuildContext context, _, __) =>
                            //                           Decommission()));
                            //         },
                            //         child: Text(
                            //           "Decommission",
                            //           style: CustomTheme.body1
                            //               .copyWith(color: CustomTheme.white),
                            //         ),
                            //       )
                            //     ])
                          ]),
                    ),
                    CustomLargeButton(
                      color: CustomTheme.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reason for Changes",
                                style: CustomTheme.body1
                                    .copyWith(color: Colors.grey),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              )
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: height / 25,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: CustomTheme.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        cursorColor: CustomTheme.primarycolor,
                        controller: textEditingController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Please Specify if Others',
                          hintStyle:
                              CustomTheme.body1.copyWith(color: Colors.grey),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
