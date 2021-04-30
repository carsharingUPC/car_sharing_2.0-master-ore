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

class RessetPage extends StatefulWidget {
  @override
  _RessetPageState createState() => _RessetPageState();
}

class _RessetPageState extends State<RessetPage> {

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
  String _correo;

  TextEditingController nombresController= new TextEditingController();
  TextEditingController aPaternoController= new TextEditingController();
  TextEditingController aMaternoController = new TextEditingController();
  TextEditingController dniController = new TextEditingController();
  TextEditingController celularController = new TextEditingController();
  TextEditingController fechaNacController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordConfirmController = new TextEditingController();

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }
    setState(() {
      _correo =sharedPreferences.getString("correo");
    });
    _id = sharedPreferences.getInt("id");
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
        backgroundColor: _colorPalette.blue_app,
        title: Text('Actualización de Contraseña'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => ProfilePage()), (Route<dynamic> route) => false);
          },
        ),
      ),
      body: FutureBuilder(
        future: _usuarioProvider.getUser(_id),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {

            nombresController.text = snapshot.data.nombres;
            aPaternoController.text = snapshot.data.apellidoPaterno;
            aMaternoController.text = snapshot.data.apellidoMaterno;
            dniController.text = snapshot.data.dni;
            celularController.text = snapshot.data.celular;
            emailController.text = snapshot.data.correo;
            passwordController.text = snapshot.data.password;
            passwordConfirmController.text = snapshot.data.password;
            fechaNacController.text = snapshot.data.fechaNac;

            return ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int i){
                  return  Container(
                    child: Column(
                      children: <Widget>[
                        _dividers.defDivider(32.0),
                        Padding(
                          padding: EdgeInsets.only(right: 30.0, left: 30.0),
                          child: _inputText.defaultIText(
                              passwordController,
                              TextInputType.name,
                              TextCapitalization.none,
                              'Contraseña',
                              Icons.lock,
                              '',
                              true
                          ),
                        ),
                        _dividers.defDivider(32.0),
                        Padding(
                          padding: EdgeInsets.only(right: 30.0, left: 30.0),
                          child: _inputText.defaultIText(
                              passwordConfirmController,
                              TextInputType.name,
                              TextCapitalization.none,
                              'Valide su contraseña',
                              Icons.lock_open,
                              '',
                              true
                          ),
                        ),
                        _dividers.defDivider(32.0),
                        _createUpdateButton(context)
                      ],
                    ),
                  );
                }
            );
          }
        },
      ),
    );
  }

  Widget _createUpdateButton(BuildContext context){
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: _colorPalette.green_app,
        ),
        child: Text('Actualizar datos', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
        onPressed: (){
          setState(() {
                if(passwordController.text.length >= 8 && passwordController.text.length <= 20 && passwordController.text == passwordConfirmController.text){
                  jsonData = _usuarioProvider.update(_id, nombresController.text, aPaternoController.text, aMaternoController.text,
                      dniController.text, celularController.text, fechaNacController.text, emailController.text, passwordController.text, imageData);
                  if(jsonData != null){
                    return _createUpdateDialog(context, 'Actualización exitosa', 'Se ha actualizado su perfil exitosamente');
                  }
                } else {
                  _alert.createAlert(context, 'Verificar contraseñas', 'La contraseña es muy grande o no coincide');
                }
          });
        },
      ),
    );
  }

  void _createUpdateDialog(BuildContext context, String cabezera, String body) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            title: Text(cabezera, style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(body, style: TextStyle(color: _colorPalette.dark_blue_app)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color:_colorPalette.green_app, fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        }
    );
  }
}

