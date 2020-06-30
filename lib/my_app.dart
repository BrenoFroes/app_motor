import 'package:app_motor/vehicle/vehicle_register_page.dart';
import 'package:flutter/material.dart';


class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP-MOTOR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: VehicleRegisterWidget(),
    );
  }
}