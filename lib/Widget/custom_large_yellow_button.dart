import 'package:flutter/material.dart';
import 'package:ipoint/Screen/decommission_second.dart';
import 'package:ipoint/global/custom_text_style.dart';

class CustomLargeButton extends StatelessWidget {
  Color? color;
  Widget child;
  void Function()? onPressed;
  CustomLargeButton({Key? key, this.color, required this.child, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              )),
              backgroundColor: MaterialStateProperty.all(color)),
          onPressed: () {
            // Navigator.push(
            //     context,
            //     PageRouteBuilder(
            //         opaque: false,
            //         fullscreenDialog: true,
            //         pageBuilder: (BuildContext context, _, __) =>
            //             DecommissionSecond()
            //     ));
          },
          child: child),
    );
  }
}
