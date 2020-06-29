import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VehicleBloc {
  final String url = "http://10.0.2.2:8000/api/vehicle/4";
  TextEditingController plateCtrl = new TextEditingController();
  int yearCtrl;
  TextEditingController modelCtrl = new TextEditingController();
  int mileageCtrl;
  String fuelCtrl;
  bool turboCtrl;

  Future<http.Response> postLogin(var body) async {
    var prefs = await SharedPreferences.getInstance();
    var texto = prefs.getString('token');
    var response = await http.post(
      "http://10.0.2.2:8000/api/vehicle/",
      headers: {"Accept": "application/json", "Authorization": "Token $texto"},
      body: body,
    );
    return response;
  }

  Future<Map> getVehicles() async {
    var prefs = await SharedPreferences.getInstance();
    var texto = prefs.getString('token');
    var res = await http.get(
      url,
      headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Token $texto "},
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
  }
}
