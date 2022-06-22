import 'package:flutter/material.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';

class RoundedButton extends StatelessWidget {
  Color textColor;
  Function onTap;
  String textInButton;
  RoundedButton(
      {required this.textColor,
      required this.onTap,
      required this.textInButton});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: textColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () => onTap(),
          minWidth: 200.0,
          height: 42.0,
          child: Text(textInButton),
        ),
      ),
    );
  }
}
