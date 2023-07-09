import 'package:flutter/material.dart';
import 'package:ipoint/global/custom_text_style.dart';

class CustomBlueButton extends StatefulWidget {
  String title;
  Function()? onPressed;
  TextStyle? textStyle;
  bool? linearGradient;
  Color? backgroundColor;
  Color? textColor;

  CustomBlueButton({
    Key? key,
    required this.title,
    this.onPressed,
    this.textColor,
    this.linearGradient,
    this.backgroundColor,
    this.textStyle,
  }) : super(key: key);

  @override
  _CustomBlueButtonState createState() => _CustomBlueButtonState();
}

class _CustomBlueButtonState extends State<CustomBlueButton> {
  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 120),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          // shadowColor: Colors.transparent,
          primary: widget.backgroundColor ?? CustomTheme.primarycolor,
          // maximumSize: Size(double.infinity, 15),
          minimumSize: Size(double.infinity, 48),
          textStyle: widget.textStyle ??
              TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
              color: widget.textColor ?? CustomTheme.black,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
// ButtonStyle(
// backgroundColor:
// MaterialStateProperty.all(CustomTheme.primarycolor),
// foregroundColor: MaterialStateProperty.all(CustomTheme.black),
// shape: MaterialStateProperty.all(RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(15))),
// maximumSize:
// )
