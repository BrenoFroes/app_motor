import 'package:app_motor/models/vehicle_model.dart';
import 'package:app_motor/survey/survey_register_page.dart';
import 'package:app_motor/widgets/card_body.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VehicleListPage extends StatefulWidget {
  VehicleListPage({Key key}) : super(key: key);

  @override
  _VehicleListPageState createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  List<Vehicle> _surveys = List<Vehicle>();

  Future<List<Vehicle>> fetchVehicle() async {
    var url = "https://appmotorbackend.herokuapp.com/api/vehicle";
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json;charset=utf-8",
        "Accept": "application/json",
        "Authorization": "Token 15fa534faf921067f69b1086a63af9aeb1613e4b"
      },
    );
    var listVehicles = List<Vehicle>();
    if (response.statusCode == 200) {
      var vehiclesDecode = utf8.decode(response.bodyBytes);
      var vehiclesJson = jsonDecode(vehiclesDecode);
      // print('response: ${response.bodyBytes}');

      for (var surveyJson in vehiclesJson) {
        listVehicles.add(Vehicle.fromJson(surveyJson));
      }
    }
    return listVehicles;
  }

  @override
  void initState() {
    fetchVehicle().then((value) {
      setState(() {
        _surveys.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          child: CardBody(_surveys[index].plate, _surveys[index].model),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SurveyPage(plate: _surveys[index].plate),
              ),
            );
          },
        );
      },
      itemCount: _surveys.length,
    );
  }
}
