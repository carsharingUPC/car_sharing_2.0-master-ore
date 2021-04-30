import 'package:carsharing_app/models/user.dart';
import 'package:carsharing_app/pages/main_menus/adm_home_page.dart';
import 'package:carsharing_app/pages/main_menus/user_home_page.dart';
import 'package:carsharing_app/pages/sign_in_pages/stay_page.dart';
import 'package:carsharing_app/pages/recovery_pages/resset_page.dart';
import 'package:carsharing_app/widgets/alert.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UsuarioProvider {

  Alert _alert = Alert();
  String _url = 'http://192.168.1.39:8080/api/usuarios/';

  //METODO POST PARA INGRESAR AL APP
  signIn(String email, String password, BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'correo'    : email,
      'password'  : password,
    };
    var bodyRequest = json.encode(data);
    var jsonData;
    var response = await http.post("${_url}log", headers: {"Content-Type": "application/json" }, body: bodyRequest);
    if(response.statusCode == 200){
      jsonData = json.decode(response.body);
      if(jsonData != null){
        sharedPreferences.setInt("id", jsonData['id']);
        sharedPreferences.setString("nombres", jsonData['nombres']);
        sharedPreferences.setString("correo", jsonData['correo']);
        sharedPreferences.setString("token", jsonData['password']);

        sharedPreferences.setBool("esAdm", jsonData['esAdm']);
        sharedPreferences.setBool("enable", jsonData['enable']);

        if(sharedPreferences.getBool("enable") == false) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => StayPage()), (Route<dynamic> route) => false);
        } else {
          if(sharedPreferences.getBool("esAdm") == true) {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => AdmHomePage()), (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => UserHomePage()), (Route<dynamic> route) => false);
          }
        }

      }
    }
    else{
      _alert.createAlert(context, 'Credenciales invalidas', 'El usuario o contraseña ingresados son incorrectos');
    }
  }

  //METODO POST PARA INGRESAR AL APP CON EMAIL
  signbyEmail(String correo, BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'correo'    : correo,
    };
    var bodyRequest = json.encode(data);
    var jsonData;
    var response = await http.post("${_url}logemail", headers: {"Content-Type": "application/json" }, body: bodyRequest);
    if(response.statusCode == 200){
      jsonData = json.decode(response.body);
      if(jsonData != null){
        sharedPreferences.setInt("id", jsonData['id']);
        sharedPreferences.setString("nombres", jsonData['nombres']);
        sharedPreferences.setString("correo", jsonData['correo']);
        sharedPreferences.setString("token", jsonData['password']);

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => RessetPage()), (Route<dynamic> route) => false);
      }
    }
    else{
      _alert.createAlert(context, 'Credenciales invalidas', 'El correo ingresado es incorrecto');
    }
  }


  //METODO PARA REGISTRAR UN USUARIO
  register(String nombres, String aPaterno, String aMaterno, String dni,
      String celular, String fechaNac, String correo, String password, String image, BuildContext context) async {

    Map data = {
      'apellidoMaterno': aMaterno,
      'apellidoPaterno': aPaterno,
      'celular'         : celular,
      'correo'          : correo,
      'dni'             : dni,
      'enable'          : null,
      'esAdm'           : false,
      'fechaNac'        : fechaNac,
      'licencia'        : image.toString(),
      'nombres'         : nombres,
      'password'        : password,
    };
    var bodyRequest = json.encode(data);

    var response = await http.post("$_url", headers: {"Content-Type": "application/json" }, body: bodyRequest);

    var jsonData;
    jsonData = json.decode(response.body);
    return jsonData;
  }
  //GET ALL USERS CUSTOMERS
  Future<List<Usuario>> getUsers() async {
    var data =  await http.get("${_url}customer");
    var jsonData = json.decode(data.body);

    List<Usuario> usuarios = [];
    for(var u in jsonData) {
      Usuario usuario  = Usuario(u["id"], u["apellidoMaterno"], u["apellidoPaterno"], u["celular"],
          u["correo"], u["dni"], u["enable"], u["esAdm"], u["fechaNac"], u["nombres"], u["password"]);

      usuarios.add(usuario);
    }
    return usuarios;
  }

  //GET ALL USERS CUSTOMERS ENABLED
  Future<List<Usuario>> getUsersEnabled() async {
    var data =  await http.get("${_url}customer/enabled");
    var jsonData = json.decode(data.body);

    List<Usuario> usuarios = [];
    for(var u in jsonData) {
      Usuario usuario  = Usuario(u["id"], u["apellidoMaterno"], u["apellidoPaterno"], u["celular"],
          u["correo"], u["dni"], u["enable"], u["esAdm"], u["fechaNac"], u["nombres"], u["password"]);

      usuarios.add(usuario);
    }
    return usuarios;
  }

  //GET ALL USERS CUSTOMERS DISABLED
  Future<List<Usuario>> getUsersDisabled() async {
    var data =  await http.get("${_url}customer/disabled");
    var jsonData = json.decode(data.body);

    List<Usuario> usuarios = [];
    for(var u in jsonData) {
      Usuario usuario  = Usuario(u["id"], u["apellidoMaterno"], u["apellidoPaterno"], u["celular"],
          u["correo"], u["dni"], u["enable"], u["esAdm"], u["fechaNac"], u["nombres"], u["password"]);

      usuarios.add(usuario);
    }
    return usuarios;
  }

  //DESHABILITAR USUARIO CUSTOMER
  disable(int id, BuildContext context) async {
    var data = await http.get("$_url$id/desactivate");
    if(data.statusCode == 200) {
      _alert.createAlertOnDisable(context, 'Usuario desactivado', 'El usuario seleccionado a sido desactivado exitosamente');
    }
  }

  //HABILITAR USUARIO CUSTOMER
  activate(int id, BuildContext context) async {
    var data = await http.get("$_url$id/activate");
    if(data.statusCode == 200) {
      _alert.createAlertOnDisable(context, 'Usuario activado', 'El usuario seleccionado a sido activado exitosamente');
    }
  }

  Future<Usuario> getUser(int id) async {
    var data =  await http.get("$_url$id");
    var jsonData = json.decode(data.body);

    Usuario usuario = Usuario(jsonData["id"],jsonData["apellidoMaterno"], jsonData["apellidoPaterno"], jsonData["celular"],
        jsonData["correo"], jsonData["dni"], jsonData["enable"], jsonData["esAdm"], jsonData["fechaNac"], jsonData["nombres"], jsonData["password"]);

    return usuario;
  }

  update(int id, String nombres, String aPaterno, String aMaterno, String dni,
      String celular, String fechaNac, String correo, String password, String imagen) async {

    Map data = {
      'id'              : id,
      'apellidoMaterno' : aMaterno,
      'apellidoPaterno' : aPaterno,
      'celular'         : celular,
      'correo'          : correo,
      'dni'             : dni,
      'enable'          : true,
      'esAdm'           : false,
      'fechaNac'        : fechaNac,
      'licencia'        : imagen.toString(),
      'nombres'         : nombres,
      'password'        : password,
    };
    var bodyRequest = json.encode(data);
    var jsonData;
    var response = await http.put("http://192.168.1.39:8080/api/usuarios/$id", headers: {"Content-Type": "application/json" }, body: bodyRequest);
    if(response.statusCode == 200) {
      jsonData = json.decode(response.body);
      return jsonData;
    }
  }

}