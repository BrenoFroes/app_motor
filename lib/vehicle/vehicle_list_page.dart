import 'package:app_motor/models/vehicle_model.dart';
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

  Future<List<Vehicle>>fetchVehicle() async {
    var url = "https://appmotorbackend.herokuapp.com/api/vehicle";
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json;charset=utf-8", "Accept": "application/json", "Authorization": "Token 15fa534faf921067f69b1086a63af9aeb1613e4b"},
    );
    var listVehicles = List<Vehicle>();
    if (response.statusCode == 200) {

      var vehiclesJson = json.decode(response.body);
      print('response: ${response.body}');
      print(vehiclesJson[0]["fuelType"]);
      for (var surveyJson in vehiclesJson) {
        surveyJson["fuelType"]= utf8.encode(surveyJson["fuelType"]);
        print(surveyJson["fuelType"]);
        surveyJson["fuelType"]= utf8.decode(surveyJson["fuelType"]);
        print(surveyJson["fuelType"]);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de veiculos'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_surveys[index].model, style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                  Text(_surveys[index].fuelType, style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),)
                ],
              ),
            ),
          );
        },
        itemCount: _surveys.length,
      ),
    );
  }
}
