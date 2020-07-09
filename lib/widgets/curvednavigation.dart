import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../style.dart';

class CurvedNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
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
      // animationDuration: Duration(milliseconds: 200),
      // animationCurve: Curves.bounceInOut,
      onTap: (index) {
        debugPrint("Current index is $index");
      },
    );
  }
}
