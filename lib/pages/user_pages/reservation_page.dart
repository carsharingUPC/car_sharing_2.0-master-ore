import 'package:carsharing_app/pages/main_menus/user_home_page.dart';
import 'package:carsharing_app/pages/user_pages/on_use_car_page.dart';
import 'package:carsharing_app/providers/car_provider.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/widgets/alert.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_map_polyline/google_map_polyline.dart';

import 'dart:math' show cos, sqrt, asin;

class ReservationPage extends StatefulWidget {
  //TODO: HALLAR EL CARRO AUN NO ESTA IMPLEMENTADO
  final int id;
  const ReservationPage({Key key, this.id}): super(key: key);
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

enum pagos { visa, mastercard }
pagos _character = pagos.visa;

class _ReservationPageState extends State<ReservationPage> {

  ColorPalette _colorPalette = ColorPalette();
  CarProvider _carProvider = CarProvider();
  Alert _alert = Alert();

  // Aqui va lo relacionado al mapa  hasta el siguiente commentario en clase

  CameraPosition _initialPosition = CameraPosition(target: LatLng(0.0,0.0));
  GoogleMapController mapController;

  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
  String _currentAddress;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;

  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final Set<Polyline> polyline = {};
  GoogleMapPolyline googleMapPolyline =  new GoogleMapPolyline(apiKey: "AIzaSyDJ1lKBGhVhPdoTduuEtBZ3Rk83Rqd1ctw");
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }
  _getAddress() async {
    try {
      var p = await _geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      var place = p[0];
      setState(() {
        _currentAddress =
        "${place.name}, ${place.locality}, ${place.subLocality}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      List<Location> startPlacemark = await locationFromAddress(_startAddress);
      List<Location> destinationPlacemark = await locationFromAddress(_destinationAddress);

      if (startPlacemark != null && destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates = _startAddress == _currentAddress
            ? Position(latitude: _currentPosition.latitude, longitude: _currentPosition.longitude)
            : Position(
            latitude: startPlacemark[0].latitude, longitude: startPlacemark[0].longitude);
        Position destinationCoordinates = Position(
            latitude: destinationPlacemark[0].latitude,
            longitude: destinationPlacemark[0].longitude);

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: _startAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$destinationCoordinates'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);

        print('START COORDINATES: $startCoordinates');
        print('DESTINATION COORDINATES: $destinationCoordinates');

        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that the position relative
        // to the frame, and pan & zoom the camera accordingly.
        double miny = (startCoordinates.latitude <= destinationCoordinates.latitude)
            ? startCoordinates.latitude
            : destinationCoordinates.latitude;
        double minx = (startCoordinates.longitude <= destinationCoordinates.longitude)
            ? startCoordinates.longitude
            : destinationCoordinates.longitude;
        double maxy = (startCoordinates.latitude <= destinationCoordinates.latitude)
            ? destinationCoordinates.latitude
            : startCoordinates.latitude;
        double maxx = (startCoordinates.longitude <= destinationCoordinates.longitude)
            ? destinationCoordinates.longitude
            : startCoordinates.longitude;

        _southwestCoordinates = Position(latitude: miny, longitude: minx);
        _northeastCoordinates = Position(latitude: maxy, longitude: maxx);

        // Accommodate the two locations within the
        // camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates.latitude,
                _northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude,
              ),
            ),
            100.0,
          ),
        );

        // Calculating the distance between the start and the end positions
        // with a straight path, without considering any route
        // double distanceInMeters = await Geolocator().bearingBetween(
        //   startCoordinates.latitude,
        //   startCoordinates.longitude,
        //   destinationCoordinates.latitude,
        //   destinationCoordinates.longitude,
        // );

        await _createPolylines(startCoordinates, destinationCoordinates);

        double totalDistance = 0.0;
        double price = 0.0;

        // Calculating the total distance by adding the distance
        // between small segments
        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += _coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }

        setState(() {
          //Formulando la generación del precio a partir de la distancia pasandolo a tiempo x KM + un delay el cual sera entre 2 y 3
          price = (totalDistance*3)*0.4;
          _placeDistance = price.toStringAsFixed(2);
          print('Precio: S/. $_placeDistance');
        });

        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
  _createPolylines(Position start, Position destination) async {
    polylineCoordinates = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(start.latitude, start.longitude),
        destination: LatLng(destination.latitude, destination.longitude),
        mode: RouteMode.driving);
    polyline.add(Polyline(polylineId: PolylineId('poly'), visible: true,  points: polylineCoordinates, width: 4, color: Colors.red));
  }
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  //TODO =================================================================================================================================================
  String _fecha = '';
  String _hora = '';

  _setFecha() {
    DateTime ahora = new DateTime.now();
    String variable = ahora.toString();
    var aux = DateTime.parse(variable);
    print(variable);
    print(aux);
    print(aux.hour);
    print(aux.minute);
    print(aux.second);

    var formatDate;
    var hourFormat;

    if(aux.month < 10 || aux.day < 10) {
      if(aux.month < 10) {
        formatDate = "${aux.year}-0${aux.month}-${aux.day}";
      }
      if(aux.day < 10) {
        formatDate = "${aux.year}-${aux.month}-0${aux.day}";
      }
      if(aux.day < 10 && aux.month < 10) {
        formatDate = "${aux.year}-0${aux.month}-0${aux.day}";

      }
    } else{
      formatDate = "${aux.year}-${aux.month}-${aux.day}";
    }
    if(aux.hour < 10 || aux.minute < 10 || aux.second < 10) {
      if(aux.hour < 10) hourFormat = "${formatDate}T0${aux.hour}:${aux.minute}:${aux.second}";
      if(aux.minute < 10) hourFormat = "${formatDate}T${aux.hour}:0${aux.minute}:${aux.second}";
      if(aux.second < 10) hourFormat = "${formatDate}T${aux.hour}:${aux.minute}:0${aux.second}";

      if(aux.hour < 10 && aux.minute < 10) hourFormat = "${formatDate}T0${aux.hour}:0${aux.minute}:${aux.second}";
      if(aux.hour < 10 && aux.second < 10) hourFormat = "${formatDate}T0${aux.hour}:${aux.minute}:0${aux.second}";
      if(aux.minute < 10 && aux.second < 10) hourFormat = "${formatDate}T${aux.hour}:0${aux.minute}:0${aux.second}";

      if(aux.hour < 10 && aux.minute < 10 && aux.second < 10) hourFormat = "${formatDate}T0${aux.hour}:0${aux.minute}:0${aux.second}";
    }
    else{
      hourFormat = "${formatDate}T${aux.hour}:${aux.minute}:${aux.second}";
    }

    _fecha = formatDate;
    _hora = hourFormat;

  }


  bool _visa = true;
  bool _mastercard = false;
  double _estimado;

  //TODO ENDPOINTS =======================================================================================================================================
              //TODO: EL ID DEL CARRO

  int _id;

  _createReservation(String dirOrigen, String dirDestino, double costo, bool visa, bool mastercard, String fecha, String hora) async {
    Map data = {
      'dirOrigen'       : dirOrigen,
      'dirDestino'      : dirDestino,
      'costo'           : costo,
      'visa'            : visa,
      'mastercard'      : mastercard,
      'uso'             : false,
      'fecha'           : fecha,
      'hora'            : hora,
      'auto' : {
        'id' : 1
      },
      'usuario' : {
        'id': widget.id
      }
    };
    var bodyRequest = json.encode(data);
    var jsonData;
    var response = await http.post("http://192.168.0.16:8080/api/reservas", headers: {"Content-Type": "application/json" }, body: bodyRequest);
    print(widget.id);
    print(bodyRequest);
    print(response.statusCode);
    if(response.statusCode == 201) {
      jsonData = json.decode(response.body);
      if(jsonData != null){
        setState(() {

        });
        print(jsonData.toString());
        _id = jsonData['id'];
        print(_id);
        return _createAlertOfSuccess(context, 'Reserva exitosa', 'Se ha registrado exitosamente su reserva de auto');
      }

    }
  }

  //TODO: BUILD===============================================================================================================================================
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();

  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: _colorPalette.blue_app,
          centerTitle: true,
          title: Text('Nueva reserva'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              setState(() {

              });
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (BuildContext context) => UserHomePage()),
                      (Route<dynamic> route) => true);
            },
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              markers: markers != null ? Set<Marker>.from(markers) : null,
              initialCameraPosition: _initialPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: polyline,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                    children: [
                      _createOrigen(),
                      Divider(color: Colors.transparent,height: 5.0),
                      _createDestino(),
                      Divider(color: Colors.transparent, height: 3.0),
                      _radioButtons(),
                      Divider(color: Colors.transparent, height: 3.0),
                      Visibility(
                        visible: _placeDistance == null ? false : true,
                        child: Text(
                          'Precio: S/. $_placeDistance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(color: Colors.transparent, height: 3.0),
                      _calculateCost()
                    ],
                  ),
                ),
              ),
            ),
            _currentButton(),
          ],
        ),
        bottomNavigationBar: Container(
          color: _colorPalette.blue_app,
          height: 60.0,
          child: FutureBuilder(
            future: _carProvider.getCar(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else{
                return ListTile(
                  title: Text('Carro asignado: ${snapshot.data.placa}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  subtitle: Text('Color: ${snapshot.data.color} \nModelo: ${snapshot.data.marca}', style: TextStyle(color: Colors.white)),
                  trailing: IconButton(
                    icon: Icon(Icons.double_arrow_sharp, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        if(startAddressController.text.isEmpty || destinationAddressController.text.isEmpty) {
                          _alert.createAlert(context, 'Faltan datos', 'Usted no ha ingresado el destino o el origen');
                        } else {
                          _setFecha();
                          _createReservation(startAddressController.text, destinationAddressController.text, _estimado, _visa, _mastercard, _fecha, _hora);
                        }
                      });
                    },
                  ),
                );
              }
            },
          )
        ),
      ),
    );
  }


  //TODO: WIDGETS =============================================================================================================================
  Widget _currentButton() {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
          child: ClipOval(
            child: Material(
              color: _colorPalette.blue_app, // button color
              child: InkWell(
                splashColor: Colors.blue, // inkwell color
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.my_location, color: Colors.white),
                ),
                onTap: () {
                  mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                          _currentPosition.latitude,
                          _currentPosition.longitude,
                        ),
                        zoom: 18.0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createAlertOfSuccess(BuildContext context, String cabezera, String body) {
    showDialog(
        context: context,
        barrierDismissible: true,
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
                  style: TextStyle(color: _colorPalette.green_app),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => OnUseCarPage(id: _id)), (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        }
    );
  }

  Widget _createOrigen(){
    return TextFormField(
      controller: startAddressController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
                color: _colorPalette.dark_blue_app,
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
                color: _colorPalette.green_app
            )
        ),
        labelText: 'Origen',
        labelStyle: TextStyle(
            color:  _colorPalette.dark_blue_app
        ),
        suffixIcon: Icon(Icons.trip_origin, color:  _colorPalette.dark_blue_app),
      ),
      onChanged: (valor){
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      },
    );
  }
  Widget _createDestino(){
    return TextFormField(
      controller: destinationAddressController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
                color:_colorPalette.dark_blue_app,
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
                color:  _colorPalette.green_app
            )
        ),
        labelText: 'Destino',
        labelStyle: TextStyle(
            color: _colorPalette.dark_blue_app
        ),
        suffixIcon: Icon(Icons.trip_origin, color:  _colorPalette.dark_blue_app),
      ),
      onChanged: (valor){
        setState(() {
          _destinationAddress = valor;
        });
      },
    );
  }

  Widget _radioButtons(){
    return  Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio<pagos>(
            fillColor: MaterialStateColor.resolveWith((states) => _colorPalette.green_app),
            value: pagos.visa,
            groupValue: _character,
            onChanged: (pagos valor){
              setState(() {
                _character = valor;
                _visa = true;
                _mastercard = false;
              });
            },
          ),
          Text('Visa', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.bold)),
          Radio(
            fillColor: MaterialStateColor.resolveWith((states) => _colorPalette.green_app),
            value: pagos.mastercard,
            groupValue: _character,
            onChanged: (pagos valor){
              setState(() {
                _character = valor;
                _visa = false;
                _mastercard = true;
              });
            },
          ),
          Text('Mastercard', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _calculateCost(){
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: _colorPalette.green_app,
        ),
        child: Text('Calcular costo', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
        onPressed: (_startAddress != '' &&
            _destinationAddress != '') ? () async {
          setState(() {
            if (markers.isNotEmpty) markers.clear();
            if (polylines.isNotEmpty)
              polylines.clear();
            if (polylineCoordinates.isNotEmpty)
              polylineCoordinates.clear();
            _placeDistance = null;
          });
          _calculateDistance().then((isCalculated) {
            if (isCalculated) {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(
                      'Distance Calculated Sucessfully'),
                ),
              );
            } else {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(
                      'Error Calculating Distance'),
                ),
              );
            }
          });
        } : null,
      ),
    );
  }

}
