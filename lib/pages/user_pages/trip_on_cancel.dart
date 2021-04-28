import 'package:carsharing_app/models/reservation.dart';
import 'package:carsharing_app/pages/main_menus/user_home_page.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swipebuttonflutter/swipebuttonflutter.dart';

class TripOnCancel extends StatefulWidget {
  final int id;
  const TripOnCancel({Key key, this.id}): super(key: key);
  @override
  _TripOnCancelState createState() => _TripOnCancelState();
}

class _TripOnCancelState extends State<TripOnCancel> {

  ColorPalette _colorPalette = ColorPalette();

  Future<Reservation>_desactivate(int id) async {
    var data = await http.get("http://192.168.0.16:8080/api/reservas/$id/desactivate");
    if(data.statusCode == 200) {
      _createAlertOfSuccess(context, 'Viaje finalizado', 'El viaje ha sido finalizado con exito');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPalette.blue_app,
        title: Text('En ruta!'),
        centerTitle: true,
      ),
      body: Container(
        color: _colorPalette.gray_app,
        padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: SwipingButton(
                    swipeButtonColor: Colors.red,
                    swipePercentageNeeded: 0.6,
                    text: "Cancelar viaje",
                    onSwipeCallback:(){
                      print(widget.id);
                      _desactivate(widget.id);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _createAlertOfSuccess(BuildContext context, String cabezera, String body) {
    showDialog(
        context: context,
        barrierDismissible: false,
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
                  style: TextStyle(color: _colorPalette.green_app, fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute
                    (builder: (BuildContext context) => UserHomePage()),
                          (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        }
    );
  }
}
