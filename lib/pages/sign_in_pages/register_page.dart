import 'dart:convert';
import 'dart:io'  as Io;
import 'package:carsharing_app/pages/sign_in_pages/login_page.dart';
import 'package:carsharing_app/providers/user_provider.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/widgets/alert.dart';
import 'package:carsharing_app/widgets/data_picker.dart';
import 'package:carsharing_app/utils/divide.dart';
import 'package:carsharing_app/widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  ColorPalette _colorPalette = new ColorPalette();
  Dividers _dividers = Dividers();
  InputText _inputText = InputText();
  DataPicker _dataPicker = DataPicker();
  Alert _alert = Alert();

  var jsonData;

  UsuarioProvider _usuarioProvider = UsuarioProvider();

  Io.File imageFile;
  String imageData;

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = Io.File(picture.path);
    });
    imageData = base64Encode(imageFile.readAsBytesSync());
    Navigator.of(context).pop();
    return imageData;
  }
  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = Io.File(picture.path);
    });
    imageData = base64Encode(imageFile.readAsBytesSync());
    Navigator.of(context).pop();
    return imageData;
  }
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Elija una opción"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              GestureDetector(
                child: Text('Galeria'),
                onTap: (){
                  _openGallery(context);
                },
              ),
              Divider(color: Colors.transparent),
              GestureDetector(
                child: Text('Camera'),
                onTap: (){
                  _openCamera(context);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  TextEditingController nombresController = new TextEditingController();
  TextEditingController aPaternoController = new TextEditingController();
  TextEditingController aMaternoController = new TextEditingController();
  TextEditingController dniController = new TextEditingController();
  TextEditingController celularController = new TextEditingController();
  TextEditingController fechaNacController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordConfirmController = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorPalette.gray_app,
      appBar: AppBar(
        backgroundColor: _colorPalette.blue_app,
        title: Text('Registrate!', style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(bottom: 40.0),
          children: <Widget>[
            _dividers.defDivider(32.0),
            Padding(
                padding: EdgeInsets.only(right: 30.0, left: 30.0),
                child: _inputText.defaultIText(
                    nombresController,
                    TextInputType.name,
                    TextCapitalization.words,
                    'Nombres',
                    Icons.accessibility,
                    '',
                    false
                ),
            ),
            _dividers.defDivider(32.0),
            Padding(
                padding: EdgeInsets.only(right: 30.0, left: 30.0),
                child: _inputText.defaultIText(
                    aPaternoController,
                    TextInputType.name,
                    TextCapitalization.words,
                    'Apellido Paterno',
                    Icons.person,
                    '',
                    false
                ),
            ),
            _dividers.defDivider(32.0),
            Padding(
                padding: EdgeInsets.only(right: 30.0, left: 30.0),
                child: _inputText.defaultIText(
                    aMaternoController,
                    TextInputType.name,
                    TextCapitalization.words,
                    'Apellido Materno',
                    Icons.person,
                    '',
                    false
                ),
            ),
            _dividers.defDivider(32.0),
            Padding(
                padding: EdgeInsets.only(right: 30.0, left: 30.0),
                child: _inputText.defaultIText(
                    dniController ,
                    TextInputType.number,
                    TextCapitalization.none,
                    'DNI',
                    Icons.credit_card_sharp,
                    '',
                    false
                ),
            ),
            _dividers.defDivider(32.0),
            Padding(
                padding: EdgeInsets.only(right: 30.0, left: 30.0),
                child: _inputText.defaultIText(
                    celularController,
                    TextInputType.number,
                    TextCapitalization.none,
                    'Celular',
                    Icons.phone,
                    '',
                    false
                ),
            ),
            _dividers.defDivider(32.0),
            Padding(
                padding: EdgeInsets.only(right: 30.0, left: 30.0),
                child: _createFechaNac(context),
            ),
            _dividers.defDivider(32.0),
            _standardImageView(),
            _dividers.defDivider(16.0),
            _createLicencia(context),
            _dividers.defDivider(32.0),
            Padding(
                padding: EdgeInsets.only(right: 30.0, left: 30.0),
                child: _inputText.defaultIText(
                    emailController,
                    TextInputType.emailAddress,
                    TextCapitalization.none,
                    'Correo electronico',
                    Icons.email,
                    '',
                    false
                ),
            ),
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
            _registerButton(context)
          ],
        ),
      ),
    );
  }

  Widget _createFechaNac( BuildContext context){
    return TextFormField(
      controller: fechaNacController,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
                color:  _colorPalette.dark_blue_app
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
                color: _colorPalette.green_app
            )
        ),
        labelText: 'Fecha de nacimiento',
        labelStyle: TextStyle(
            color: _colorPalette.dark_blue_app
        ),
        suffixIcon: Icon(Icons.calendar_today, color: _colorPalette.dark_blue_app),
      ),
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
        _dataPicker.selectDate(context, fechaNacController);
      },
    );
  }

  Widget _registerButton(BuildContext context){
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: _colorPalette.green_app,
        ),
        child: Text('Registrar', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
        onPressed: (){
          setState(() {
            //TODO: Mejorar esta validación
            if(emailController.text.contains("@") && emailController.text.contains(".com")){
              if(dniController.text.length == 8){
                if(celularController.text.length == 9){
                  if(passwordController.text.length >= 8 && passwordController.text.length <= 20 && passwordController.text == passwordConfirmController.text){

                     jsonData = _usuarioProvider.register(nombresController.text, aPaternoController.text, aMaternoController.text,
                        dniController.text, celularController.text, fechaNacController.text, emailController.text, passwordController.text, imageData, context);

                     if(jsonData != null){
                       return createAlertOnSignIn(context, 'Registro exitoso', 'Se ha registrado exitosamente');
                     }

                  } else {
                    _alert.createAlert(context, 'Verificar contraseñas', 'La contraseña es muy grande o no coincide');
                  }
                } else {
                  _alert.createAlert(context, 'Verificar celular', 'El celular ingresado no es correcto');
                }
              } else {
                _alert.createAlert(context, 'Verificar DNI', 'El DNI ingresado no es correcto');
              }
            } else {
              _alert.createAlert(context, 'Correo invalido', 'El correo ingresado es incorrecto');
            }
          });
        },
      ),
    );
  }

  Widget _createLicencia(BuildContext context){
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: _colorPalette.green_app,
        ),
        child: Text('Subir licencia', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
        onPressed: (){
          _showChoiceDialog(context);
        },
      ),
    );
  }
  Widget _standardImageView() {
    if(imageFile == null){
      return Center(child: Text('Imagen no seleccionada'));
    } else {
      return Image.file(imageFile,width: 400.0, height: 400.0);
    }
  }

  void createAlertOnSignIn(BuildContext context, String cabezera, String body) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            title: Text(cabezera),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(body),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.cyan),
                ),
                onPressed: () {
                  _usuarioProvider.signIn(emailController.text, passwordController.text, context);
                },
              ),
            ],
          );
        }
    );
  }
}