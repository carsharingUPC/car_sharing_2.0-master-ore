import 'package:carsharing_app/pages/sign_in_pages/login_page.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/widgets/adm_drawer.dart';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AdmHomePage extends StatefulWidget {
  @override
  _AdmHomePageState createState() => _AdmHomePageState();
}

class _AdmHomePageState extends State<AdmHomePage> {

  ColorPalette _colorPalette = ColorPalette();
  AdmAppDrawer _appDrawer = AdmAppDrawer();

  SharedPreferences sharedPreferences;

  String _nombres;
  String _correo;

  checkLoginStatus() async {
    sharedPreferences =  await SharedPreferences.getInstance();
    if(sharedPreferences.getString('token') == null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }
    setState(() {
      _nombres =  sharedPreferences.getString("nombres");
      _correo = sharedPreferences.getString("correo");
    });
  }


 @override
  void initState() {
   super.initState();
   checkLoginStatus();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: Text('Bienvenido, $_nombres'),
       backgroundColor: _colorPalette.dark_blue_app,
     ),
      body: Container(
        color: _colorPalette.gray_app,
      ),
      drawer: _appDrawer.admAppDrawer(context, _nombres, _correo)
    );
  }
}
