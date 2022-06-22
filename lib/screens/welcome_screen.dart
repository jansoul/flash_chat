import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/myWidget.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value * 100,
                  ),
                ),
                AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      speed: const Duration(milliseconds: 450),
                      textStyle: const TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
                onTap: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                textColor: Colors.lightBlue,
                textInButton: 'Log In'),
            RoundedButton(
              onTap: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              textInButton: 'Register',
              textColor: Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }
}
