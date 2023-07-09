import 'package:flutter/material.dart';
import 'package:ipoint/Widget/custom_large_yellow_button.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';

class DecommissionSecond extends StatefulWidget {
  const DecommissionSecond({Key? key}) : super(key: key);

  @override
  _DecommissionSecondState createState() => _DecommissionSecondState();
}

class _DecommissionSecondState extends State<DecommissionSecond> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                backgroundColor: MaterialStateProperty.all(CustomTheme.yellow)),
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
              "Continue",
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
                    "Decommission request sent for",
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
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
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
                        ]),
                  ),
                  SizedBox(
                    height: height / 25,
                  ),
                  Text(
                    "The decommission of the agent above will take in affect in 24 hours time.",
                    textAlign: TextAlign.center,
                    style: CustomTheme.body2
                        .copyWith(color: CustomTheme.white, fontSize: 16),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
