import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;
  // const StyledTest(String text , {super.key}): text = text  // old style

  const StyledText(this.text, {super.key}); // this will assign the text filed instace variable with value passed to tis constructor

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 28, color: Colors.white),
    );
  }
}
