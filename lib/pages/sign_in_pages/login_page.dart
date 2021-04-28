import 'package:carsharing_app/pages/sign_in_pages/register_page.dart';
import 'package:carsharing_app/providers/user_provider.dart';
import 'package:carsharing_app/pages/recovery_pages/recovery_page.dart';

import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/utils/divide.dart';
import 'package:carsharing_app/widgets/alert.dart';
import 'package:carsharing_app/widgets/input_text.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
      body: Container(
        child: ListView(
          children: <Widget>[
            _dividers.defDivider(64.0),
            Image.asset(
              'assets/easy_drive_logo.png',
              height: 200.0,
              width: 200.0,
              alignment: Alignment.center,
            ),
            _dividers.defDivider(32.0),
            Padding(padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: _inputText.defaultIText(
                    emailController,
                    TextInputType.emailAddress,
                    TextCapitalization.none,
                    'Correo electronico',
                    Icons.alternate_email,
                    _email,
                    false
                ),
            ),
            _dividers.defDivider(16.0),
            Padding(padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child:  _inputText.defaultIText(
                    passwordController,
                    TextInputType.text,
                    TextCapitalization.none,
                    'Contraseña',
                    Icons.lock,
                    _password, true
                )
            ),
            TextButton(
              child: Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  color: _colorPalette.dark_blue_app,
                ),
              ),
                onPressed: (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => RecoveryPage()), (Route<dynamic> route) => true);
                  },
            ),
            _dividers.defDivider(16.0),
            _LoginButton(context),
            _dividers.defDivider(16.0),
            TextButton(
              child: Text('¿No tienes cuenta? Registrate aquí', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.bold)),
              onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => RegisterPage()), (Route<dynamic> route) => true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _LoginButton(BuildContext context){
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: _colorPalette.green_app,
        ),
        child: Text('Iniciar sesión', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
        onPressed: (){
            setState(() {
              if(emailController.text.contains("@") && emailController.text.contains(".com")){
                _usuarioProvider.signIn(emailController.text, passwordController.text, context);
              } else {
                _alert.createAlert(context, 'Correo invalido', 'El correo ingresado es incorrecto');
              }
            });
            },
      ),
    );
  }

}
