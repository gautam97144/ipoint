import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ipoint/Screen/pay_screen.dart';
import 'package:ipoint/Widget/custom_toast.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/model/qr_scan_model.dart';
import 'package:ipoint/service/apiclient.dart';
import 'package:ipoint/service/constant.dart';
import 'package:ipoint/service/exception.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final qrkey = GlobalKey(debugLabel: "Qr");
  String? qrCode;

  QRViewController? qrViewController;
  Barcode? barcode;
  QrScanData? qrScan;
  @override
  void reassemble() async {
    // TODO: implement reassemble
    super.reassemble();
    if (Platform.isAndroid) {
      await qrViewController?.pauseCamera();
    }
    qrViewController?.resumeCamera();
  }

  Future fetchTransaction(String qrData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    FormData data = FormData.fromMap({"ref_code": qrData});
    try {
      Response response = await ApiClient().dio.post(Constant.verifyQr,
          data: data,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.data != null) {
        if (response.statusCode == 200) {
          if (mounted) {
            qrScan = QrScanData.fromJson(response.data);
          }
          if (qrScan?.success == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PayScreen(
                          qrCode: qrScan?.data?.refCode,
                        ))).then((value) {
              setState(() {
                qrViewController?.resumeCamera();
              });
            });
          }
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      CustomToast.toast(errorMessage);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        //alignment: Alignment.center,
        children: [
          buildQrView(context),
          Positioned(
            top: 60,
            right: 30,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.clear,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrkey,
        onQRViewCreated: onQrViewCreated,
        overlay: QrScannerOverlayShape(
            borderRadius: 10,
            borderWidth: 10,
            borderColor: CustomTheme.primarycolor,
            cutOutSize: MediaQuery.of(context).size.width * 0.8),
      );

  void onQrViewCreated(QRViewController qrViewController) async {
    setState(() {
      this.qrViewController = qrViewController;
    });

    print("hello");
    qrViewController.scannedDataStream.listen((qrData) {
      qrViewController.pauseCamera();
      if (qrData.code != null) {
        print(qrData.code.toString() + "llllll");

        fetchTransaction(qrData.code!);

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => PayScreen()));
        //Navigator.pop(context);

      }
      // // setState(() {
      // //   this.barcode = barcode;
      // //   qrViewController.pauseCamera();
      // //   final String? qrCode = qrData.code;
      // //   //print(qrCode.toString() + "lllll");
      // //   //fetchTransaction(qrCode!);
      // //
      // //   Navigator.push(
      // //       context,
      // //       MaterialPageRoute(
      // //           builder: (context) => PayScreen(
      // //                 qrCode: '$qrCode',
      // //               ))).then((value) => qrViewController.resumeCamera());
      // });
    });
  }

  Widget buildView() {
    return Text(
      barcode != null ? "${barcode!.code}" : "Scan Qr code",
      style: CustomTheme.body1.copyWith(color: Colors.white),
    );
  }

  // Future<void> scanQr() async {
  //   try {
  //     final qrCode = await FlutterBarcodeScanner.scanBarcode(
  //         "0xff00F0FF", "cancel", true, ScanMode.QR);
  //
  //     if (mounted) return;
  //
  //     setState(() {
  //       this.qrCode = qrCode;
  //     });
  //   } on PlatformException {
  //     qrCode = "Failed to get platform version";
  //   }
  // }
}
