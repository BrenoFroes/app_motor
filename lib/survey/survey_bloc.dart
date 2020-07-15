import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SurveyBloc {
  String localCtrl;
  TextEditingController vehicleCtrl = new TextEditingController();

  Future<http.Response> postSurvey(var body, var idVehicle) async {
    var prefs = await SharedPreferences.getInstance();
    var texto = prefs.getString('token');
    var response = await http.post(
      "https://appmotorbackend.herokuapp.com/api/survey/vehicle/" +
          idVehicle +
          "/",
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
    final String url =
      "https://appmotorbackend.herokuapp.com/api/vehicle/plate/" + plate;
    var prefs = await SharedPreferences.getInstance();
    var texto = prefs.getString('token');
    var res = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Token 15fa534faf921067f69b1086a63af9aeb1613e4b"
      },
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
  }
}
