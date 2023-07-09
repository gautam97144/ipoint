import 'package:flutter/material.dart';
import 'package:ipoint/global/images.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        height: 70,
        width: 70,
        child: Lottie.asset(Images.root_loader_path),
      ),
    );
  }
}
