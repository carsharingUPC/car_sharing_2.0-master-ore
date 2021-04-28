import 'package:carsharing_app/pages/adm_pages/users_page.dart';
import 'file:///C:/Users/Miguel Angel/Desktop/Desarrollo Android/car_sharing_2.0-master/lib/pages/adm_pages/car_page.dart';
import 'package:carsharing_app/pages/main_menus/adm_home_page.dart';
import 'package:carsharing_app/pages/sign_in_pages/login_page.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:flutter/material.dart';

class AdmAppDrawer {

  ColorPalette _colorPalette = ColorPalette();

  Widget admAppDrawer(BuildContext context, String nombres, String correo) {
    return SafeArea(
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
                title: Text('Dashboard'),
                trailing: Icon(Icons.dashboard),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => AdmHomePage()), (Route<dynamic> route) => false);
                }
            ),
            ListTile(
              title: Text('Usuarios'),
              trailing: Icon(Icons.person),
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => UsersPage()), (Route<dynamic> route) => true);
              },
            ),
            ListTile(
              title: Text('Mis carros'),
              trailing: Icon(Icons.directions_car_outlined),
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => CarPage()), (Route<dynamic> route) => true);
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