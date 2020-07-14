import 'package:app_motor/home/home_page.dart';
import 'package:app_motor/vehicle/vehicle_list_page.dart';
import 'package:app_motor/style.dart';
import 'package:flutter/material.dart';

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP-MOTOR',
      debugShowCheckedModeBanner: false,
      theme: _theme(),
      home: HomePage(),
    );
  }
  ThemeData _theme() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(headline6: AppBarTextStyle),
      ),
      textTheme: TextTheme(headline6: TitleTextStyle, bodyText2: Body1TextStyle),
    );
  }
}