import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/widgets/alert.dart';
import 'package:flutter/material.dart';

class DataPicker {
  String _fecha;
  var _colorPalette = new ColorPalette();
  var _alert = new Alert();

  selectDate(BuildContext context, TextEditingController controller) async {
    DateTime pick = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1960),
        lastDate: new DateTime(2050),
        locale: Locale('es', 'ES'),
        builder: (context, child){
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: _colorPalette.blue_app,
              ),
            ),
            child: child,
          );
        }
    );

    if(pick != null ) {
      if(calculateAge(pick) >= 18) {
          _fecha = pick.toString();
          var aux = DateTime.parse(_fecha);
          var formatDate;
          if(aux.month < 10 || aux.day < 10) {
            if(aux.month < 10) formatDate = "${aux.year}-0${aux.month}-${aux.day}";
            if(aux.day < 10) formatDate = "${aux.year}-${aux.month}-0${aux.day}";
            if(aux.day < 10 && aux.month < 10) formatDate = "${aux.year}-0${aux.month}-0${aux.day}";
          } else{
            formatDate = "${aux.year}-${aux.month}-${aux.day}";
          }
          controller.text = formatDate;
      } else {
        _alert.createAlert(context, 'Eres menor de edad', 'Debes tener más de 18 años para registrarte en el app');
      }

    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}