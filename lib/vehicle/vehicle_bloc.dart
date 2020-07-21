import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VehicleBloc {
  final String url = "https://appmotorbackend.herokuapp.com/api/vehicle/";
  TextEditingController plateCtrl = new TextEditingController();
  TextEditingController modelCtrl = new TextEditingController();
  int yearCtrl;
  int mileageCtrl;
  String fuelCtrl;
  bool turboCtrl;

  Future<http.Response> registerVehicle(var body) async {
    var prefs = await SharedPreferences.getInstance();
    var texto = prefs.getString('token');
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Token 15fa534faf921067f69b1086a63af9aeb1613e4b"
      },
      body: body,
    );
    return response;
  }

  Future<Map> getVehicles(String plate) async {
    var prefs = await SharedPreferences.getInstance();
    var texto = prefs.getString('token');
    var res = await http.get(
      url + plate,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Token 15fa534faf921067f69b1086a63af9aeb1613e4b"
      },
      //headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Token 10b8a69fa60b23bc528dc8857e2e68de105806e4 "},
    );
    print(res.statusCode);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return null;
    }
  }

  Future<Map> getVehiclesByPlate(String plate) async {
    var prefs = await SharedPreferences.getInstance();
    var texto = prefs.getString('token');
    var res = await http.get(
      url + "plate/" + plate,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Token 15fa534faf921067f69b1086a63af9aeb1613e4b "
      },
      //headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Token 10b8a69fa60b23bc528dc8857e2e68de105806e4 "},
    );
    print(res.statusCode);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return null;
    }
  }
}
