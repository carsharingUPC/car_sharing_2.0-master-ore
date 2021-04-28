import 'package:carsharing_app/models/user.dart';
import 'package:carsharing_app/pages/sign_in_pages/login_page.dart';
import 'package:carsharing_app/providers/user_provider.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/widgets/adm_drawer.dart';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  SharedPreferences sharedPreferences;

  ColorPalette _colorPalette = ColorPalette();
  AdmAppDrawer _appDrawer = AdmAppDrawer();
  UsuarioProvider _usuarioProvider = UsuarioProvider();

  String _nombres;
  String _correo;

  checkLoginStatus() async {
    sharedPreferences =  await SharedPreferences.getInstance();
    if(sharedPreferences.getString('token') == null){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (Route<dynamic> route) => false);
    }
    setState(() {
      _nombres =  sharedPreferences.getString("nombres");
      _correo = sharedPreferences.getString("correo");
    });
  }

  List<Usuario> userDetails;
  List<Usuario> _searchResult = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginStatus();
    _usuarioProvider.getUsers().then((users){
      userDetails = users;
    });
    print(userDetails);
  }

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: _colorPalette.dark_blue_app,
          title: _isSearching ? _buildSearchField() : Text('Mis usuarios'),
          actions: _buildActions(),
        ),

        body: Column(children: [

          Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, right:30),
            child: Text("Usuarios Activos", textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0, color: _colorPalette.dark_blue_app, fontWeight: FontWeight.bold), ),
          ),

          Expanded(
            child: FutureBuilder(
              future: _usuarioProvider.getUsersEnabled(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return _isSearching ?
                ListView.builder(
                  itemCount: _searchResult.length,
                  itemBuilder: (BuildContext context, int i){
                    return Column(
                        children:[
                          Text('Usuarios Activos', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
                          Divider(color: Colors.transparent),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text('${_searchResult[i].nombres.toString()} ${_searchResult[i].apellidoPaterno.toString()} ${_searchResult[i].apellidoMaterno.toString()}'),
                              subtitle: Text('Correo: ${_searchResult[i].correo.toString()} Celular: ${_searchResult[i].celular.toString()}'),
                              trailing: _searchResult[i].enable ? Icon(Icons.check, color: Colors.black) : Icon(Icons.clear, color: Colors.black),
                              onTap: () {
                                //TODO: DESHABILITAR USUARIO
                                _createDetailSearched(context, _searchResult, i);
                              },
                            ),
                          ),
                        ]
                    );
                  },
                )
                    : ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int i){
                        return Column(
                          children:[
                          Divider(color: Colors.transparent),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text('${snapshot.data[i].nombres.toString()} ${snapshot.data[i].apellidoPaterno.toString()} ${snapshot.data[i].apellidoMaterno.toString()}'),
                              subtitle: Text('Correo: ${snapshot.data[i].correo.toString()} Celular: ${snapshot.data[i].celular.toString()}'),
                              trailing: snapshot.data[i].enable ? Icon(Icons.check, color: Colors.black) : Icon(Icons.clear, color: Colors.black),
                              onTap: () {
                                //TODO: DESHABILITAR USUARIO
                                _createDetail(context, snapshot, i);
                              },
                            ),
                          ),
                        ]
                    );
                  },
                );
              }
            },
          ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 30, right:30),
            child: Text("Usuarios Inactivos", textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0, color: _colorPalette.dark_blue_app, fontWeight: FontWeight.bold), ),
          ),

          Expanded(
            child: FutureBuilder(
              future: _usuarioProvider.getUsersDisabled(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return _isSearching ?
                  ListView.builder(
                    itemCount: _searchResult.length,
                    itemBuilder: (BuildContext context, int i){
                      return Column(
                          children:[
                            Divider(color: Colors.transparent),
                            Padding(
                              padding: EdgeInsets.only(right: 10.0, left: 10.0),
                              child: ListTile(
                                leading: Icon(Icons.person),
                                title: Text('${_searchResult[i].nombres.toString()} ${_searchResult[i].apellidoPaterno.toString()} ${_searchResult[i].apellidoMaterno.toString()}'),
                                subtitle: Text('Correo: ${_searchResult[i].correo.toString()} Celular: ${_searchResult[i].celular.toString()}'),
                                trailing: _searchResult[i].enable ? Icon(Icons.check, color: Colors.black) : Icon(Icons.clear, color: Colors.black),
                                onTap: () {
                                  //TODO: DESHABILITAR USUARIO
                                  _createDetailSearched(context, _searchResult, i);
                                },
                              ),
                            ),
                          ]
                      );
                    },
                  )
                      : ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int i){
                      return Column(
                          children:[
                            Divider(color: Colors.transparent),
                            Padding(
                              padding: EdgeInsets.only(right: 10.0, left: 10.0),
                              child: ListTile(
                                leading: Icon(Icons.person),
                                title: Text('${snapshot.data[i].nombres.toString()} ${snapshot.data[i].apellidoPaterno.toString()} ${snapshot.data[i].apellidoMaterno.toString()}'),
                                subtitle: Text('Correo: ${snapshot.data[i].correo.toString()} Celular: ${snapshot.data[i].celular.toString()}'),
                                trailing: snapshot.data[i].enable ? Icon(Icons.check, color: Colors.black) : Icon(Icons.clear, color: Colors.black),
                                onTap: () {
                                  //TODO: DESHABILITAR USUARIO
                                  _createDetail(context, snapshot, i);
                                },
                              ),
                            ),
                          ]
                      );
                    },
                  );
                }
              },
            ),
          ),
        ]),
        drawer: _appDrawer.admAppDrawer(context, _nombres, _correo)
    );
  }

  void _createDetailSearched(BuildContext context, List<Usuario> searching, int i) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text('Detalles del usuario'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                  child: Text(
                    'Volver',
                    style: TextStyle(color: Colors.cyan),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Center(child: CircleAvatar(child: Icon(Icons.person))),
                Divider(color: Colors.transparent),
                Text('Nombre: \n${searching[i].nombres.toString()} ${searching[i].apellidoPaterno.toString()} ${searching[i].apellidoMaterno.toString()}', textAlign: TextAlign.left),
                Divider(color: Colors.transparent),
                Text('Correo: \n${searching[i].correo.toString()}', textAlign: TextAlign.left),
                Divider(color: Colors.transparent),
                Text('Celular: \n${searching[i].celular.toString()}', textAlign: TextAlign.left),
                Divider(color: Colors.transparent),
                Text('Fecha de Nacimiento: \n${searching[i].fechaNac.toString()}', textAlign: TextAlign.left),
              ],
            ),
            actions: <Widget>[
              searching[i].enable ?
              TextButton(
                child: Text(
                  'Desactivar usuario',
                  style: TextStyle(color: Colors.cyan),
                ),
                onPressed: () {
                  _usuarioProvider.disable(searching[i].id, context);
                },
              ) :
              TextButton(
                child: Text(
                  'Activar usuario',
                  style: TextStyle(color: Colors.cyan),
                ),
                onPressed: () {
                  _usuarioProvider.activate(searching[i].id, context);
                },
              )
            ],
          );
        }
    );
  }
  void _createDetail(BuildContext context, AsyncSnapshot snapshot, int i) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text('Detalles del usuario'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                  child: Text(
                    'Volver',
                    style: TextStyle(color: _colorPalette.green_app, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Center(child: CircleAvatar(child: Icon(Icons.person))),
                Divider(color: Colors.transparent),
                Text('Nombre: \n${snapshot.data[i].nombres.toString()} ${snapshot.data[i].apellidoPaterno.toString()} ${snapshot.data[i].apellidoMaterno.toString()}', textAlign: TextAlign.left),
                Divider(color: Colors.transparent),
                Text('Correo: \n${snapshot.data[i].correo.toString()}', textAlign: TextAlign.left),
                Divider(color: Colors.transparent),
                Text('Celular: \n${snapshot.data[i].celular.toString()}', textAlign: TextAlign.left),
                Divider(color: Colors.transparent),
                Text('Fecha de Nacimiento: \n${snapshot.data[i].fechaNac.toString()}', textAlign: TextAlign.left),
              ],
            ),
            actions: <Widget>[
              snapshot.data[i].enable ?
              TextButton(
                  child: Text(
                    'Desactivar usuario',
                    style: TextStyle(color:_colorPalette.green_app, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    _usuarioProvider.disable(snapshot.data[i].id, context);
                  },
              ) :
              TextButton(
                child: Text(
                  'Activar usuario',
                  style: TextStyle(color:_colorPalette.green_app, fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  _usuarioProvider.activate(snapshot.data[i].id, context);
                },
              )
            ],
          );
        }
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }
  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }
  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }
  void updateSearchQuery(String text) async {
    _searchResult.clear();
    if(text.isEmpty) {
      setState(() {
      });
      return;
    }
    userDetails.forEach((userDetail) {
      if(userDetail.correo.contains(text)) _searchResult.add(userDetail);
    });
    setState(() {});
  }
  void _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }
  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }
}
