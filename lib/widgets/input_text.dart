import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/utils/upper_case_formater.dart';
import 'package:flutter/material.dart';

//Clase de inputs para el uso en la app
class InputText {

  ColorPalette _colorPalette = new ColorPalette();
  //Por default se usará este si solo se tiene que atrapar data
  Widget defaultIText(
      TextEditingController controller,
      TextInputType type,
      TextCapitalization textCap,
      String label,
      IconData icon,
      String submited,
      bool lock){
    return TextFormField(
      enableInteractiveSelection: false ,
      controller: controller,
      obscureText: lock,
      keyboardType: type, //TextInputType.emailAddress,
      textCapitalization: textCap,//TextCapitalization.none,
      style: TextStyle(
          color: _colorPalette.dark_blue_app
      ),
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
        labelText: label,
        labelStyle: TextStyle(
          color: _colorPalette.dark_blue_app,
        ),
        suffixIcon: Icon( icon /*Icons.alternate_email*/, color: _colorPalette.dark_blue_app),
      ),
      onChanged: (valor){
        submited = valor;
      },
    );
  }

  Widget inputUpperCased(
      TextEditingController controller,
      TextInputType type,
      TextCapitalization textCap,
      String label,
      IconData icon,
      String submited,
      bool lock) {
    return TextFormField(
      inputFormatters: [
        UpperCaseTextFormatter(),
      ],
      controller: controller,
      obscureText: lock,
      keyboardType:  type,
      textCapitalization: textCap,
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
        labelText: label,
        labelStyle: TextStyle(
          color: _colorPalette.dark_blue_app
        ),
        suffixIcon: Icon(icon, color: _colorPalette.dark_blue_app),
      ),

    );
  }
}