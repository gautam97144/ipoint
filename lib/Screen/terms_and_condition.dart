import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TermsAndCondition extends StatefulWidget {
  TermsAndCondition({Key? key}) : super(key: key);

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  String data = "";

  fetchFileData() async {
    String responseText;

    responseText = await rootBundle.loadString("assets/text/iPoint 1.txt");

    setState(() {
      data = responseText;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [Text(data)],
        ),
      ),
    );
  }
}
