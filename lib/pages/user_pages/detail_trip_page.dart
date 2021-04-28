import 'dart:ui';

import 'package:carsharing_app/pages/user_pages/trips_page.dart';
import 'package:carsharing_app/providers/reservation_provider.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/utils/divide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailTripPage extends StatefulWidget {
  final int id;
  const DetailTripPage({Key key, this.id}): super(key: key);

  @override
  _DetailTripPageState createState() => _DetailTripPageState();
}

class _DetailTripPageState extends State<DetailTripPage> {

  ReservationProvider _provider = ReservationProvider();
  ColorPalette _colorPalette = ColorPalette();
  Dividers _dividers = Dividers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: _provider.getReservation(widget.id),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Center(child: CircularProgressIndicator());
            } else{
              return Container(
                color: _colorPalette.gray_app,
                child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int i) {
                      return Column(
                        children: <Widget>[
                          Stack(
                            children: [
                              Column(
                                children: [
                                  Container(height: 32.0,color: _colorPalette.blue_app),
                                  Container(
                                    alignment: Alignment.center,
                                    color: _colorPalette.blue_app,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.arrow_back, color: Colors.white),
                                          onPressed: (){
                                            setState(() {
                                            });
                                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => TripPage()), (Route<dynamic> route) => false);
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 64.0),
                                          child: Column(
                                            children: [
                                              Text('Detalles del', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 24.0)),
                                              Text('viaje', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 24.0)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(height: 88.0,color: _colorPalette.blue_app),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 120.0, left: 8.0, right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(50.0))
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                          child: ListTile(
                                            title: Text('Direccion de Origen: ${snapshot.data.dirOrigen.toString()}',style: TextStyle(color: _colorPalette.dark_blue_app)),
                                            leading: Icon(Icons.trip_origin, color: _colorPalette.dark_blue_app),
                                          )
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                          child: ListTile(
                                            title: Text('Direccion de Destino: ${snapshot.data.dirDestino.toString()}',style: TextStyle(color: _colorPalette.dark_blue_app)),
                                            leading: Icon(Icons.trip_origin, color: _colorPalette.dark_blue_app),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                          _dividers.defDivider(16.0),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _colorPalette.green_app,
                                  borderRadius: BorderRadius.all(Radius.circular(30.0))
                              ),
                              child: ListTile(
                                title: Text('Costo: ', style: TextStyle(color: _colorPalette.dark_blue_app)),
                                leading: Icon(Icons.trip_origin, color: _colorPalette.dark_blue_app),
                                trailing: Text('S/.${snapshot.data.costo.toString()}', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
                              ),
                            )
                          ),
                          _dividers.defDivider(16.0),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(30.0))
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: ListTile(
                                    title: Text('Usted pago con ', style: TextStyle(color: _colorPalette.dark_blue_app)),
                                    leading: Icon(Icons.trip_origin, color: _colorPalette.dark_blue_app),
                                    trailing: snapshot.data.visa ? Text('Visa', style: TextStyle(color: _colorPalette.dark_blue_app,fontWeight: FontWeight.bold))
                                      : Text('Mastercard', style: TextStyle(color: _colorPalette.dark_blue_app,fontWeight: FontWeight.bold))
                                ),
                              ),
                            ),
                          ),
                          _dividers.defDivider(32.0),
                          //TODO: Sacar la foto del carro
                          Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(30.0))
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                        title: Center(child: Text('Datos de carro reservado ', style: TextStyle(color: _colorPalette.dark_blue_app, fontSize: 20.0, fontWeight: FontWeight.bold))),
                                    ),
                                    Divider(color: Colors.transparent),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: ListTile(
                                        title: Text('Placa:'),
                                        trailing: Text(' ${snapshot.data.auto.placa}'),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: ListTile(
                                        title: Text('Color:'),
                                        trailing: Text(' ${snapshot.data.auto.color}'),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: ListTile(
                                        title: Text('Marca:'),
                                        trailing: Text(' ${snapshot.data.auto.marca}'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ),
                        ],
                      );
                    }
                ),
              );
            }
          },
        ),
      ),
    );
  }
  void _createDetail(BuildContext context, AsyncSnapshot snapshot, int i) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text('Detalles del viaje'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/map.jpg',
                ),
                Divider(color: Colors.transparent),
                Text('Fecha: ${snapshot.data[i].fecha.toString()}', textAlign: TextAlign.left),
                Text('Hora: ${snapshot.data[i].hora.toString()}', textAlign: TextAlign.left),
                snapshot.data[i].visa ? Text('Metodo de pago: Visa') : Text('Metodo de pago: Mastercard'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.cyan),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
}
