import 'package:flutter/material.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:qr_code_scanner/src/types/barcode.dart';

class UniqueCodeScreen extends StatefulWidget {
  String? qrCode;
  UniqueCodeScreen({Key? key, this.qrCode}) : super(key: key);

  @override
  _UniqueCodeScreenState createState() => _UniqueCodeScreenState();
}

class _UniqueCodeScreenState extends State<UniqueCodeScreen> {
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
            onPressed: () {},
            child: Text(
              "copy unique code",
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
                  Text("Your Unique Code is",
                      style: CustomTheme.body1.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),

                  SizedBox(
                    height: height / 25,
                  ),

                  SizedBox(
                      height: height / 12,
                      width: double.infinity,
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(CustomTheme.yellow),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50)))),
                          onPressed: () {},
                          child: Text("#2!aBiPoint1234",
                              style:
                                  CustomTheme.body1.copyWith(fontSize: 16)))),
                  // Container(
                  //   alignment: Alignment.center,
                  //   padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  //   width: double.infinity,
                  //   height: height / 10,
                  //   decoration: BoxDecoration(
                  //     color: Colors.yellow,
                  //     borderRadius: BorderRadius.circular(50),
                  //   ),
                  //   child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         GestureDetector(
                  //           onTap: () {
                  //             //   Navigator.push(
                  //             //       context,
                  //             //       PageRouteBuilder(
                  //             //           opaque: false,
                  //             //           fullscreenDialog: true,
                  //             //           pageBuilder:
                  //             //               (BuildContext context, _, __) =>
                  //             //               UniqueCodeScreen()));
                  //           },
                  //           child: Text(
                  //             "#2!aBiPoint1234",
                  //             style: CustomTheme.body1.copyWith(fontSize: 17),
                  //           ),
                  //         ),
                  //       ]),
                  // ),
                ]),
          ),
        ),
      ),
    );
  }
}
