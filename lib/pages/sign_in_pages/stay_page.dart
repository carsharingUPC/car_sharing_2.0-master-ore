import 'package:carsharing_app/pages/sign_in_pages/register_page.dart';
import 'package:carsharing_app/providers/user_provider.dart';
import 'package:carsharing_app/pages/sign_in_pages/login_page.dart';

import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/utils/divide.dart';
import 'package:carsharing_app/widgets/alert.dart';
import 'package:carsharing_app/widgets/input_text.dart';

import 'package:flutter/material.dart';

class StayPage extends StatefulWidget {
  @override
  _StayPageState createState() => _StayPageState();
}

class _StayPageState extends State<StayPage> {

  var _colorPalette =  ColorPalette();
  var _dividers =  Dividers();
  var _alert =  Alert();
  var _inputText =  InputText();
  var _usuarioProvider =  UsuarioProvider();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPalette.blue_app,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _dividers.defDivider(32.0),
            Image.asset(
              'assets/easy_drive_logo.png',
              height: 200.0,
              width: 200.0,
              alignment: Alignment.center,
            ),

            _dividers.defDivider(16.0),

            Padding(
              padding: const EdgeInsets.only(left: 60, right:60),
              child: Text("¡ GRACIAS POR REGISTRARTE EN EASY DRIVE !", textAlign: TextAlign.center, style: TextStyle(fontSize: 25.0, color: _colorPalette.dark_blue_app, fontWeight: FontWeight.bold), ),
            ),

            _dividers.defDivider(16.0),

            Padding(
              padding: const EdgeInsets.only(left: 50, right:50),
              child: Text('Tu usuario está siendo validado por tu seguridad y la de los demás.'
                  'En breve podrás tener acceso a la experiencia EasyDrive', textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0, color: _colorPalette.dark_blue_app, fontWeight: FontWeight.bold), ),
            ),

            Image.asset(
              'assets/easy_drive_stay.png',
              height: 200.0,
              width: 200.0,
              alignment: Alignment.center,
            ),

          ],
        ),
      ),
    );
  }

}