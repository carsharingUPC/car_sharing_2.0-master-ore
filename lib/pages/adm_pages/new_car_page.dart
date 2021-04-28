import 'package:carsharing_app/pages/adm_pages/car_page.dart';
import 'package:carsharing_app/providers/car_provider.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/utils/divide.dart';
import 'package:carsharing_app/widgets/alert.dart';
import 'package:carsharing_app/widgets/input_text.dart';
import 'package:flutter/services.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io' as Io;
import 'package:image_picker/image_picker.dart';


class NewCarPage extends StatefulWidget {
  @override
  _NewCarPageState createState() => _NewCarPageState();
}

class _NewCarPageState extends State<NewCarPage> {

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Dividers _dividers = Dividers();
  Alert _alert = Alert();
  CarProvider _carProvider = CarProvider();

  var jsonData;

  Io.File imageFile;
  String imageData;
  TextEditingController _placaController = new TextEditingController();

  List<String> _colores =["rojo", "azul", "amarillo", "morado"];

  List<String> _marcas = ['Audi', 'BMW', 'Cadillac', 'Chevrolet', 'Citroen', 'Ferrari', 'Ford', 'Honda',
                          'Jaguar', 'Jeep', 'Kia', 'Lamborghini', 'Lexus', 'Lotus', 'Maserati', 'Mazda',
                          'Mercedes-Benz', 'Mini', 'Mitsubishi', 'Nissan', 'Peugeot', 'Porsche', 'Renault',
                          'Subaru', 'Suzuki', 'Tesla', 'Toyota', 'Volkswagen', 'Volvo'];
  String _marca;
  String _color;

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
                  setState(() {

                  });
                  _openGallery(context);
                },
              ),
              Divider(color: Colors.transparent),
              GestureDetector(
                child: Text('Camera'),
                onTap: (){
                  setState(() {

                  });
                  _openCamera(context);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: _colorPalette.dark_blue_app,
        title: Text('Registro de nuevo carro'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => CarPage()), (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
           _dividers.defDivider(16.0),
            Padding(
                padding: EdgeInsets.only(right: 30.0, left: 30.0),
                child: _inputText.inputUpperCased(
                    _placaController,
                    TextInputType.emailAddress,
                    TextCapitalization.none,
                    'Placa',
                    Icons.folder_open,
                    '',
                    false
                ),
            ),
            _dividers.defDivider(16.0),
            _standardImageView(),
            _dividers.defDivider(16.0),
            _createButtonImage(context),
            _dividers.defDivider(16.0),
            Padding(child: _createMarca(), padding: EdgeInsets.only(right: 30.0, left: 30.0)),
            _dividers.defDivider(16.0),
            Padding(child: _createColor(), padding: EdgeInsets.only(right: 30.0, left: 30.0)),
            _dividers.defDivider(16.0),
            _createButton(context),
            _dividers.defDivider(16.0),
          ],
        ),
      ),
    );
  }

  Widget _createColor() {
    return DropdownButtonFormField(
      style: TextStyle(
          color: _colorPalette.dark_blue_app
      ),
      items: _colores.map((String color) {
        return new DropdownMenuItem(
            value: color,
            child: Text(color)
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() => _color = newValue);
      },
      value: _color,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
                color: _colorPalette.dark_blue_app
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
                color: _colorPalette.green_app
            )
        ),
        labelText: 'Color',
        labelStyle: TextStyle(
          color: _colorPalette.dark_blue_app,
        ),
      ),
    );
  }

  Widget _createMarca() {
    return DropdownButtonFormField(
      style: TextStyle(
          color:  _colorPalette.dark_blue_app
      ),
      items: _marcas.map((String marca) {
        return new DropdownMenuItem(
            value: marca,
            child: Text(marca)
        );
      }).toList(),
      onChanged: (newValue) {
        // do other stuff with _category
        setState(() => _marca = newValue);
      },
      value: _marca,
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
                color:  _colorPalette.green_app
            )
        ),
        labelText: 'Marca',
        labelStyle: TextStyle(
          color:  _colorPalette.dark_blue_app,
        ),
      ),
    );
  }

  Widget _createButton(BuildContext context){
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: _colorPalette.green_app,
        ),
        child: Text('Registrar auto',style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
        onPressed: (){
          setState(() {
            if(_placaController.text.length == 7 && _placaController.text.contains("-", 3)) {
              jsonData = _carProvider.createCar(_placaController.text, _color, _marca, imageData);
              if(jsonData != null){
                return _createAlertOnCarCreated(context, 'Registro exitoso', 'El auto ha sido registrado exitosamente');
              }

            } else {
              _alert.createAlert(context, 'La placa no es valida', 'La placa ingresada no coincide con el formato');
            }
          });
        },
      ),
    );
  }


  Widget _createButtonImage(BuildContext context){
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: _colorPalette.green_app,
        ),
        child: Text('Subir foto',style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
        onPressed: (){
          setState(() {

          });
          _showChoiceDialog(context);
        },
      ),
    );
  }
  Widget _standardImageView() {
    if(imageFile == null){
      return Center(child: Text('Imagen no seleccionada'));
    } else {
      return Image.file(imageFile,width: 200.0, height: 200.0);
    }
  }

  void _createAlertOnCarCreated(BuildContext context, String cabezera, String body) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            title: Text(cabezera,style: TextStyle(color: _colorPalette.dark_blue_app)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(body,style: TextStyle(color: _colorPalette.dark_blue_app)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color: _colorPalette.green_app, fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => CarPage()), (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        }
    );
  }
}