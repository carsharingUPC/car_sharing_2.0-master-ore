import 'package:carsharing_app/pages/adm_pages/new_car_page.dart';
import 'package:carsharing_app/providers/car_provider.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/widgets/adm_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:carsharing_app/pages/sign_in_pages/login_page.dart';

class CarPage extends StatefulWidget {
  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {

  ColorPalette _colorPalette = ColorPalette();
  AdmAppDrawer _appDrawer = AdmAppDrawer();
  CarProvider _carProvider = CarProvider();

  SharedPreferences sharedPreferences;
  String _nombres;
  String _correo;

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (
          Route<dynamic> route) => false);
    }
    setState(() {
      _nombres = sharedPreferences.getString("nombres");
      _correo = sharedPreferences.getString("correo");
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
        title: Text('Mis carros'),
        backgroundColor: _colorPalette.dark_blue_app,
      ),
      body: Container(
        color: _colorPalette.gray_app,
        child: FutureBuilder(
          future: _carProvider.getCars(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Center(child: CircularProgressIndicator(backgroundColor: _colorPalette.green_app,));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i){
                    return Column(
                      children:[
                        Divider(color: Colors.transparent),
                        Padding(
                          padding: EdgeInsets.only(right: 30.0, left: 30.0),
                          child: ListTile(

                            leading: Icon(Icons.directions_car_outlined),
                            title: Text(snapshot.data[i].marca.toString()),
                            subtitle: Text('${snapshot.data[i].placa.toString()} (${snapshot.data[i].color.toString()})'),
                          ),
                        ),
                      ]
                    );
                  }
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _colorPalette.dark_blue_app,
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {});
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => NewCarPage()), (Route<dynamic> route) => false);
        },
      ),
      drawer: _appDrawer.admAppDrawer(context, _nombres, _correo),
    );
  }
}