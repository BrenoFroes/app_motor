import 'package:app_motor/home/home_page.dart';
import 'package:app_motor/vehicle/search_vehicle_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../style.dart';

class CurvedNavigation extends StatefulWidget {
  @override
  _CurvedNavigationState createState() => _CurvedNavigationState();
}

class _CurvedNavigationState extends State<CurvedNavigation> {
  int _page = 0;

  GlobalKey _bottomNavigationKey = GlobalKey();
  final homePage = HomePage();
  final listVehicles = SearchVehicle();

  Widget _showPage = new HomePage();

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: _page,
      color: PrimaryBlue3,
      backgroundColor: Gray6,
      height: 70,
      items: <Widget>[
        Icon(Icons.home,
            size: 30, color: (_page == 1) ? SecondaryBlue1 : Colors.white),
        Icon(Icons.audiotrack,
            size: 30, color: (_page == 2) ? SecondaryBlue1 : Colors.white),
        Icon(Icons.directions_car,
            size: 30, color: (_page == 3) ? SecondaryBlue1 : Colors.white),
        // Icon(Icons.account_circle, size: 30, color: Colors.white),
        // Icon(Icons.exit_to_app, size: 30, color: Colors.white),
      ],
      onTap: (int index) {
        setState(() {
          _showPage = changeScreen(index);
          print(_page);
        });
      },
    );
  }

  changeScreen(int index) {
    switch (_page) {
      case 0:
        return homePage;
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
}
