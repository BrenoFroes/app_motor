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
  final surveyListPage = SurveyListPage();
  final listVehicles = SearchVehicle();

  Widget _showPage = new SurveyListPage();

  Widget changeScreen(int index) {
    switch (index) {
      case 0:
        return surveyListPage;
        break;
      case 1:
        return listVehicles;
        break;
      case 2:
        return listVehicles;
        break;
      default:
        return new Container(
          child: Center(
            child: Text(
              "Page not found.",
              style: TextStyle(fontFamily: FontNameDefaultTitle),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.vertical(
      //       bottom: Radius.circular(15.0),
      //     ),
      //   ),
      //   backgroundColor: PrimaryBlue1,
      //   title: Padding(
      //     child: Text(
      //       "Suas vistorias:",
      //       textAlign: TextAlign.start,
      //       style: TextStyle(
      //         color: Gray6,
      //         fontSize: 22,
      //         fontWeight: FontWeight.w600,
      //         fontFamily: FontNameDefaultBody,
      //       ),
      //     ),
      //     padding: const EdgeInsets.only(top: 20, left: 25, bottom: 15),
      //   ),
      // ),
      body: Container(child: _showPage),
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
        index: _page,
        color: PrimaryBlue2,
        backgroundColor: Gray6,
        height: 70,
        items: <Widget>[
          Icon(Icons.home,
              size: 30, color: (_page == 0) ? SecondaryBlue1 : Colors.white),
          Icon(Icons.audiotrack,
              size: 30, color: (_page == 1) ? SecondaryBlue1 : Colors.white),
          Icon(Icons.directions_car,
              size: 30, color: (_page == 2) ? SecondaryBlue1 : Colors.white),
          // Icon(Icons.account_circle, size: 30, color: Colors.white),
          // Icon(Icons.exit_to_app, size: 30, color: Colors.white),
        ],
        onTap: (int index) {
          setState(() {
            _showPage = changeScreen(index);
            _page = index;
          });
        },
      ),
      floatingActionButton: (_page == 0)
          ? Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchVehicle(),
                    ),
                  );
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
            )
          : SizedBox(),
    );
  }
}
