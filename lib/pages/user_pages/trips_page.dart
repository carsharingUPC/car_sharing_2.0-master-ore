
import 'package:carsharing_app/pages/sign_in_pages/login_page.dart';
import 'package:carsharing_app/pages/user_pages/detail_trip_page.dart';
import 'package:carsharing_app/providers/reservation_provider.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/widgets/user_drawer.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TripPage extends StatefulWidget {
  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  SharedPreferences sharedPreferences;

  UserAppDrawer _appDrawer = UserAppDrawer();
  ColorPalette _colorPalette = ColorPalette();
  ReservationProvider _provider = ReservationProvider();
  String _nombres;
  String _correo;
  int _id;

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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  _colorPalette.blue_app,
        title: Text('Mis viajes'),
      ),
      body: Container(
        color: _colorPalette.gray_app,
        child: FutureBuilder(
          future: _provider.getReservations(_id),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Center(child: CircularProgressIndicator());
            } else{
              return Container(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int i){
                      return Column(
                          children:[
                            Divider(color: Colors.transparent),
                            Padding(
                              padding: EdgeInsets.only(right: 30.0, left: 30.0),
                              child: ListTile(

                                leading: Icon(Icons.trip_origin_outlined, color: _colorPalette.green_app),
                                title: Text('Origen: ${snapshot.data[i].dirOrigen}',style: TextStyle(color:_colorPalette.dark_blue_app)),
                                subtitle: Text('Destino: ${snapshot.data[i].dirDestino}',style: TextStyle(color:_colorPalette.dark_blue_app)),
                                trailing: Text('S/.${snapshot.data[i].costo.toString()}',style: TextStyle(color:_colorPalette.dark_blue_app, fontWeight: FontWeight.bold)),
                                onTap: (){
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DetailTripPage(id: snapshot.data[i].id)), (Route<dynamic> route) => true);
                                },
                              ),
                            ),
                          ]
                      );
                    }
                ),
              );
            }
          },
        ),
      ),
      drawer: _appDrawer.userAppDrawer(context, _nombres, _correo),
    );
  }
}
