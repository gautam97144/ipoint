import 'package:flutter/material.dart';
import 'package:ipoint/Screen/sign_up_page.dart';
import 'package:ipoint/Widget/custom_text_field.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';
import 'package:slide_to_act/slide_to_act.dart';

import 'bottom_navigation.dart';

class UserLogInPage extends StatefulWidget {
  const UserLogInPage({Key? key}) : super(key: key);

  @override
  _UserLogInPageState createState() => _UserLogInPageState();
}

class _UserLogInPageState extends State<UserLogInPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "User",
                      style: CustomTheme.body2,
                    ),
                    width: width / 5,
                    height: height / 30,
                    decoration: BoxDecoration(
                        color: CustomTheme.primarycolor,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ],
              ),
              SizedBox(
                height: height / 16,
              ),
              Container(
                  width: width / 3,
                  height: height / 4,
                  child: Image.asset(Images.logo)),
              SizedBox(height: height / 30),
              CoustomInPutField(
                autofocus: false,
                cursorHeight: height / 34,
                cursorcolor: CustomTheme.primarycolor,
                hint: "Username",
                fieldName: '',
                hintStyle: CustomTheme.inputFieldHintStyle,
              ),
              SizedBox(
                height: height / 39,
              ),
              CoustomInPutField(
                autofocus: false,
                obscureText: true,
                cursorHeight: height / 34,
                cursorcolor: CustomTheme.primarycolor,
                hint: "Password",
                hintStyle: CustomTheme.inputFieldHintStyle,
                maxLines: 1,
              ),
              SizedBox(
                height: height / 30,
              ),
              Center(
                child: Text(
                  'Forgot Password?',
                ),
              ),
              SizedBox(
                height: height / 20,
              ),
              Container(
                height: height / 12.5,
                margin: EdgeInsets.only(left: 50, right: 50),
                child: SlideAction(
                  elevation: 0,
                  onSubmit: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return BottomNavigation();
                    }));
                  },
                  innerColor: CustomTheme.white,
                  outerColor: CustomTheme.yellow,
                  child: Padding(
                    padding: EdgeInsets.only(left: 28),
                    child: Text(
                      'Swipe to Login',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: CustomTheme.fontFamily),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height / 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // SizedBox(width: 130),
                  Text(
                    'New User?',
                    style: CustomTheme.body2,
                  ),
                  SizedBox(
                    width: width / 20,
                  ),
                  Container(
                      alignment: Alignment.center,
                      height: height / 19.8,
                      width: width / 4,
                      decoration: BoxDecoration(
                          color: CustomTheme.yellow,
                          borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text(
                            'Sign Up',
                            style: CustomTheme.body2,
                          ))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
