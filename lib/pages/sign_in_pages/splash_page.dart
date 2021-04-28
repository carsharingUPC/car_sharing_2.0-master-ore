import 'dart:async';

import 'package:carsharing_app/pages/sign_in_pages/login_page.dart';
import 'package:carsharing_app/pages/sign_in_pages/stay_page.dart';
import 'package:carsharing_app/pages/sign_in_pages/register_page.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/pages/user_pages/profile_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  var _colors = ColorPalette();

  @override
  Widget build(BuildContext context) {
    Timer( Duration(seconds: 3), () => Navigator.of(context).pushReplacement(MaterialPageRoute( builder: (BuildContext context) => LoginPage())));

    return Scaffold(
      body: Container(
        color: _colors.gray_app,
        child: Center( child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/easy_drive_logo.png', height: 150.0, width: 150.0, alignment: Alignment.center),
              CircularProgressIndicator(backgroundColor: _colors.green_app),
            ],
          ),
        ),
      ),
    );
  }
}
