import 'package:carsharing_app/models/car.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';

class CarProvider {
  String _url = 'http://192.168.1.39:8080/api/autos/';

  Future<List<Car>> getCars() async {
    var data =  await http.get("$_url");
    var jsonData = json.decode(data.body);

    List<Car> cars = [];
    for(var u in jsonData) {
      Car car = Car(u["id"], u["color"], u["modelo"], u["placa"]);
      cars.add(car);
    }
    return cars;
  }

  createCar(String placa, String color, String marca, String imagen) async {
    Map data = {
      'color' : color,
      'img'   : imagen.toString(),
      'modelo': marca,
      'placa' : placa
    };
    var bodyRequest = json.encode(data);
    var jsonData;
    var response = await http.post("$_url", headers: {"Content-Type": "application/json" }, body: bodyRequest);

    if(response.statusCode == 201) {
      jsonData = json.decode(response.body);
      return jsonData;
    }
  }
  Future<Car> getCar() async {
    var data = await http.get('http://192.168.0.16:8080/api/autos/1');
    var jsonData = json.decode(data.body);
    Car car = Car(jsonData["id"], jsonData["color"], jsonData["modelo"], jsonData["placa"]);
    return car;
  }
}