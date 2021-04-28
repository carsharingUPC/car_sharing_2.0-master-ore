import 'file:///C:/Users/Miguel Angel/Desktop/Desarrollo Android/car_sharing_2.0-master/lib/pages/user_pages/profile_page.dart';
import 'package:carsharing_app/pages/sign_in_pages/login_page.dart';
import 'file:///C:/Users/Miguel Angel/Desktop/Desarrollo Android/car_sharing_2.0-master/lib/pages/user_pages/trips_page.dart';
import 'file:///C:/Users/Miguel Angel/Desktop/Desarrollo Android/car_sharing_2.0-master/lib/pages/main_menus/user_home_page.dart';
import 'package:carsharing_app/utils/color_palette.dart';

import 'package:flutter/material.dart';

class UserAppDrawer {

  var _colorPalette = new ColorPalette();

  Widget userAppDrawer(BuildContext context, String nombres, String correo) {
    return  SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  color: _colorPalette.dark_blue_app
              ),
              currentAccountPicture: CircleAvatar(
                child: Image.asset('assets/easy_drive_drawer_logo.png'),
              ),
              accountName: Text(nombres),
              accountEmail:Text(correo),
            ),
            ListTile(
              title: Text('Viaja!'),
              trailing: Icon(Icons.car_rental),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => UserHomePage()), (Route<dynamic> route) => true);
              },
            ),
            ListTile(
              title: Text('Mi perfil'),
              trailing: Icon(Icons.person),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => ProfilePage()), (Route<dynamic> route) => true);
              },
            ),
            ListTile(
              title: Text('Mis viajes'),
              trailing: Icon(Icons.trip_origin),
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => TripPage()), (Route<dynamic> route) => true);
              },
            ),
            ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.logout),
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
              },
            ),

          ],
        ),
      ),
    );
  }
}