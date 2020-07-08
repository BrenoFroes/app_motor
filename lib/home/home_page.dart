import 'package:app_motor/style.dart';
import 'package:app_motor/survey/survey_list_page.dart';
import 'package:app_motor/vehicle/search_vehicle_page.dart';
import 'package:app_motor/vehicle/vehicle_register_page.dart';
import 'package:app_motor/survey/survey_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class SurveyList extends StatelessWidget {
  var surveyListPageState = new SurveyListPage();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: surveyListPageState,
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var survey = new SurveyBloc();
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  var surveyListPageState = new SurveyListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15.0),
          ),
        ),
        backgroundColor: PrimaryBlue1,
        title: Padding(
          child: Text(
            "Suas vistorias:",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Gray6,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              fontFamily: FontNameDefaultBody,
            ),
          ),
          padding: const EdgeInsets.only(top: 20, left: 25, bottom: 15),
        ),
      ),
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: SurveyListPage()),
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
        backgroundColor: Gray6,
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchVehicle()));
          },
          label: Text(
            'Nova vistoria',
            style: TextStyle(color: Gray2, fontSize: 16),
          ),
          icon: Icon(
            Icons.add,
            color: Gray2,
          ),
          backgroundColor: Gray6,
        ),
      ),
    );
  }
}
