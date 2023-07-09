import 'package:flutter/material.dart';
import 'package:ipoint/main_loader/loader.dart';

class ScreenLoader extends StatefulWidget {
  Color? loaderColor;
  Color? bgColor;
  double? opacity;
  ScreenLoader({this.loaderColor, this.bgColor, this.opacity});
  @override
  _ScreenLoaderState createState() => _ScreenLoaderState();
}

class _ScreenLoaderState extends State<ScreenLoader> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Opacity(
        opacity: widget.opacity ?? 0.0,
        child: ModalBarrier(
            dismissible: false, color: widget.bgColor ?? Colors.black),
      ),
      Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Loader()],
        ),
      ),
    ]);
  }
}
