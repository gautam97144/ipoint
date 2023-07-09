import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SwitchButton extends StatefulWidget {
  String? name;
  // Function onSubmit;
  TextStyle? textStyle;
  Color? innerColor;
  Color? outerColor;

  SwitchButton(
      {Key? key,
      required this.name,
      // required this.createPage,
      // required this.onSubmit,
      required this.textStyle,
      required this.innerColor,
      required this.outerColor})
      : super(key: key);

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height / 12.5,
      margin: EdgeInsets.only(left: 50, right: 50),
      child: SlideAction(
        elevation: 0,
        // onSubmit: () {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) {
        //     return widget.createPage();
        //   }));
        // },
        innerColor: widget.innerColor,
        outerColor: widget.outerColor,
        child: Padding(
          padding: EdgeInsets.only(left: 28),
          child: Text(
            widget.name.toString(),
            style: widget.textStyle,
          ),
        ),
      ),
    );
  }
}
