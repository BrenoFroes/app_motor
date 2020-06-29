import 'dart:convert';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VehicleHttp {
  final String url = "http://10.0.2.2:8000/api/vehicle/7";
  var plateCtrl = new MaskedTextController(mask: 'AAA 0000');

  Future<Map> getVehicles() async {
    var prefs = await SharedPreferences.getInstance();
    var texto = prefs.getString('token');
    var res = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Token $texto "},
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
  }
}