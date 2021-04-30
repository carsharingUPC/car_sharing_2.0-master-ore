import 'package:carsharing_app/pages/sign_in_pages/login_page.dart';
import 'package:carsharing_app/pages/user_pages/profile_page.dart';
import 'package:carsharing_app/providers/user_provider.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/utils/divide.dart';
import 'package:carsharing_app/widgets/alert.dart';
import 'package:carsharing_app/widgets/data_picker.dart';
import 'package:carsharing_app/widgets/input_text.dart';

import 'dart:io'  as Io;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class RecoveryPage extends StatefulWidget {
  @override
  _RecoveryPageState createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {

  ColorPalette _colorPalette = ColorPalette();
  UsuarioProvider _usuarioProvider = UsuarioProvider();
  Alert _alert = Alert();
  DataPicker _dataPicker = DataPicker();
  InputText _inputText = InputText();
  Dividers _dividers = Dividers();

  SharedPreferences sharedPreferences;
  Io.File imageFile;
  String imageData;

  var jsonData;
  int _id;
  final TextEditingController emailController = new TextEditingController();

  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPalette.blue_app,
        title: Text('Recuperación de Contraseña'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Column(children: [

        _dividers.defDivider(32.0),
        Padding(padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child:  _inputText.defaultIText(
                emailController,
                TextInputType.emailAddress,
                TextCapitalization.none,
                'Email',
                Icons.alternate_email,
                _email, false
            )
        ),
        _dividers.defDivider(16.0),

        _dividers.defDivider(16.0),
        _ValidationButton(context),
        _dividers.defDivider(16.0),

      ]),

    );
  }

  Widget _ValidationButton(BuildContext context){
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: _colorPalette.green_app,
        ),
        child: Text('Validar Correo', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
        onPressed: (){
          setState(() {
            if(emailController.text.contains("@") && emailController.text.contains(".com")){
              _usuarioProvider.signbyEmail(emailController.text, context);
            } else {
              _alert.createAlert(context, 'Correo inválido', 'El correo ingresado es incorrecto');
            }
          });
        },
      ),
    );
  }

}

