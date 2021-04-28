import 'package:carsharing_app/pages/sign_in_pages/login_page.dart';
import 'package:carsharing_app/pages/user_pages/reservation_page.dart';

import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/widgets/user_drawer.dart';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {

  UserAppDrawer _userAppDrawer = new UserAppDrawer();
  ColorPalette _colorPalette = new ColorPalette();

  SharedPreferences sharedPreferences;

  String _nombres;
  String _correo;
  int _id;

  CameraPosition _initialPosition = CameraPosition(target: LatLng(0.0,0.0));
  GoogleMapController mapController;
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;

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
    }).catchError((e) {
      print(e);
    });
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }
    setState(() {
      _nombres =  sharedPreferences.getString("nombres");
      _correo = sharedPreferences.getString("correo");
      _id = sharedPreferences.getInt("id");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginStatus();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Builder(
        builder: (context){
          return InkWell(
            child: CircleAvatar(
              child: ClipOval(child: Image.asset('assets/easy_drive_drawer_logo.png', fit: BoxFit.scaleDown,)),
            ),
            onTap: (){
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              //TODO: Falta la interacción con el auto donde esté más cerca
              initialCameraPosition: _initialPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _currentPositionButton(),
                _bottomBox(),
              ],
            )
          ],
        ),
      ),
      drawer: _userAppDrawer.userAppDrawer(context, _nombres, _correo)
    );
  }

  Widget _auxButton(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      child: TextFormField(
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(

          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                  color: _colorPalette.green_app
              )
          ),
          hintText: 'Introduce un destino',
          labelStyle: TextStyle(
              color: Colors.black
          ),
        ),
        onTap: (){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => ReservationPage(id: _id)), (Route<dynamic> route) => true);
        },
        readOnly: true,
        showCursor: true,
      ),
    );
  }

  Widget _currentPositionButton() {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
          child: ClipOval(
            child: Material(
              color: _colorPalette.blue_app, // button color
              child: InkWell(
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

  Widget _bottomBox() {
    return  Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
            color: _colorPalette.blue_app
        ),
        height: 150.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                  child: Text(
                    '¡Hola, $_nombres !',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                    child: Icon(Icons.car_rental, color: Colors.white)
                )
              ],
            ),
            Divider(color: Colors.transparent, height: 5.0),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                '¿A dónde quieres ir?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
            Padding( padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),child: _auxButton()),
          ],
        ),
      ),
    );
  }
}
