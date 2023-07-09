import 'package:flutter/material.dart';
import 'package:ipoint/Widget/custom_large_yellow_button.dart';
import 'package:ipoint/global/custom_text_style.dart';

class Commission extends StatefulWidget {
  const Commission({Key? key}) : super(key: key);

  @override
  _CommissionState createState() => _CommissionState();
}

class _CommissionState extends State<Commission> {
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
        //resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black.withOpacity(.7),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: CustomLargeButton(
            color: CustomTheme.yellow,
            child: Text(
              "Confirm Changes",
              style: CustomTheme.body2,
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
                      "Agent's current commission value",
                      style: CustomTheme.body1.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height / 25,
                    ),

                    Text(
                      "30 %",
                      style: CustomTheme.body1
                          .copyWith(color: CustomTheme.yellow, fontSize: 50),
                    ),
                    SizedBox(
                      height: height / 25,
                    ),

                    CustomLargeButton(
                        color: CustomTheme.primarycolor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "-",
                                style: CustomTheme.body2.copyWith(fontSize: 20),
                              ),
                              Text(
                                "30",
                                style: CustomTheme.body2.copyWith(fontSize: 20),
                              ),
                              Text(
                                "+",
                                style: CustomTheme.body2.copyWith(fontSize: 20),
                              )
                            ],
                          ),
                        )),
                    SizedBox(
                      height: height / 25,
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

                    //Expanded(child: SizedBox()),

                    // SizedBox(
                    //   height: 50,
                    //   width: double.infinity,
                    //   child: TextButton(
                    //     style: ButtonStyle(
                    //         shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(24.0),
                    //         )),
                    //         backgroundColor:
                    //             MaterialStateProperty.all(CustomTheme.yellow)),
                    //     onPressed: () {},
                    //     child: Text(
                    //       "Confirm Changes",
                    //       style: CustomTheme.body2,
                    //     ),
                    //   ),
                    // )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
