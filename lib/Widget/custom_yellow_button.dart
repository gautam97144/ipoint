import 'package:flutter/material.dart';
import 'package:ipoint/global/custom_text_style.dart';

class CustomYellowButton extends StatefulWidget {
  String title;
  Function()? onPressed;
  TextStyle? textStyle;
  Color? backgroundColor;
  Color? textColor;

  CustomYellowButton({
    Key? key,
    required this.title,
    this.onPressed,
    this.textColor,
    this.backgroundColor,
    this.textStyle,
  }) : super(key: key);

  @override
  _CustomYellowButtonState createState() => _CustomYellowButtonState();
}

class _CustomYellowButtonState extends State<CustomYellowButton> {
  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Container(
      height: Height * 0.06,
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35.0),
        color: CustomTheme.yellow,
        // color: CustomTheme.yellow,
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
            // shadowColor: Colors.transparent,
            primary: widget.backgroundColor ?? Colors.yellow,
            //maximumSize: Size(double.infinity, 38),
            minimumSize: Size(double.infinity, 38),
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
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
