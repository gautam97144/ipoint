import 'package:flutter/material.dart';
import 'package:ipoint/global/custom_text_style.dart';

class CustomeYellowGreyButton extends StatefulWidget {
  String title;
  bool linearGradient;
  Function()? onPressed;
  TextStyle? textStyle;
  Color? backgroundColor;
  Color? textColor;

  CustomeYellowGreyButton({
    Key? key,
    required this.title,
    this.onPressed,
    this.textColor,
    required this.linearGradient,
    this.backgroundColor,
    this.textStyle,
  }) : super(key: key);

  @override
  _CustomeYellowGreyButtonState createState() =>
      _CustomeYellowGreyButtonState();
}

class _CustomeYellowGreyButtonState extends State<CustomeYellowGreyButton> {
  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Container(
      height: Height / 14,
      width: Width * 0.40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35.0),
        gradient: widget.linearGradient
            ? LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                    CustomTheme.yellow,
                    CustomTheme.yellow,
                  ])
            : LinearGradient(
                colors: [CustomTheme.grey, CustomTheme.grey],
              ),
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
            primary: widget.backgroundColor ?? Colors.red,
            //maximumSize: Size(double.infinity, 38),
            // minimumSize: Size(double.infinity, 38),
            textStyle: widget.textStyle ??
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            )),
        child: Text(
          widget.title,
          style: TextStyle(
              color: widget.textColor ?? CustomTheme.black,
              fontWeight: FontWeight.w700,
              fontFamily: CustomTheme.fontFamily,
              fontSize: 18),
        ),
      ),
    );
  }
}
