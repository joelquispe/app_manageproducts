
import 'package:flutter/material.dart';
import 'package:modalcrud/pages/login.dart';
import 'package:modalcrud/pages/register.dart';

class Authentication extends StatefulWidget {
  Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool isToogle = false;
  void toggleScreen() {
    setState(() {
      isToogle = !isToogle;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isToogle) {
      return Register(toggleScreen: toggleScreen);
    } else {
      return Login(toggleScreen: toggleScreen);
    }
  }
}
