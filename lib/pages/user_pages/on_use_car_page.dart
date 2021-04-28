import 'package:carsharing_app/pages/user_pages/trip_on_use.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';


class OnUseCarPage extends StatefulWidget {
  final int id;
  const OnUseCarPage({Key key, this.id}): super(key: key);
  @override
  _OnUseCarPageState createState() => _OnUseCarPageState();
}

class _OnUseCarPageState extends State<OnUseCarPage> {

  ColorPalette _colorPalette = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPalette.blue_app,
        title: Text('Uso del auto', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //TODO: VALIDACION ESTA CERCA DEL AUTO
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: SwipingButton(
                    swipeButtonColor: Colors.blue,
                    swipePercentageNeeded: 0.6,
                    text: "\tDesbloquear Auto",
                    onSwipeCallback:(){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute
                        (builder: (BuildContext context) => TripOnUse(id: widget.id)),
                              (Route<dynamic> route) => false);
                    }),
              ),
            ),
            Divider(color: Colors.transparent),
            Divider(color: Colors.transparent)
          ],
        ),
      ),
    );
  }
}
