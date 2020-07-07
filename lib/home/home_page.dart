import 'package:app_motor/style.dart';
import 'package:app_motor/survey/survey_list_page.dart';
import 'package:app_motor/vehicle/search_vehicle_page.dart';
import 'package:app_motor/vehicle/vehicle_register_page.dart';
import 'package:app_motor/survey/survey_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var survey = new SurveyBloc();
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Motor"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // FloatingActionButton(
              //   color: Theme.of(context).primaryColor,
              //   child: Text(
              //     'Nova Vistoria',
              //     style: TextStyle(
              //         color: PrimaryRed3,
              //         fontFamily: FontNameDefaultBody,
              //         fontWeight: FontWeight.w800),
              //   ),
              //   onPressed: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => SearchVehicle()));
              //   },
              // ),
              FlatButton(
                color: Theme.of(context).primaryColor,
                child: Text('Visualizar Vistorias',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SurveyListPage()));
                },
              ),
            ]),
      ),
      // body: Container(
      //   color: Colors.white,
      //   child: Center(
      //     child: Column(
      //       children: <Widget>[
      //         Text(_page.toString(), textScaleFactor: 10.0),
      //         RaisedButton(
      //           child: Text('Go To Page of index 1'),
      //           onPressed: () {
      //             //Page change using state does the same as clicking index 1 navigation button
      //             final CurvedNavigationBarState navBarState =
      //                 _bottomNavigationKey.currentState;
      //             navBarState.setPage(1);
      //           },
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      bottomNavigationBar: CurvedNavigationBar(
        color: PrimaryBlue3,
        backgroundColor: Colors.white,
        height: 70,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.audiotrack, size: 30, color: Colors.white),
          Icon(Icons.directions_car, size: 30, color: Colors.white),
          Icon(Icons.account_circle, size: 30, color: Colors.white),
          Icon(Icons.exit_to_app, size: 30, color: Colors.white),
        ],
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          debugPrint("Current index is $index");
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchVehicle()));
        },
        label: Text(
          'Nova vistoria',
          style: TextStyle(color: Gray2),
        ),
        icon: Icon(
          Icons.add,
          color: Gray2,
        ),
        backgroundColor: Gray6,
      ),
    );
  }
}
