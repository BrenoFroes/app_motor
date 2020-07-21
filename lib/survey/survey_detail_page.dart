import 'package:app_motor/audio/recording_audio_bloc.dart';
import 'package:app_motor/models/survey_model.dart';
import 'package:app_motor/models/vehicle_model.dart';
import 'package:app_motor/vehicle/vehicle_bloc.dart';
import 'package:flutter/material.dart';
import 'package:app_motor/style.dart';
import 'package:http/http.dart' as http;

class SurveyDetailPage extends StatefulWidget {
  final Survey survey;

  const SurveyDetailPage({Key key, this.survey}) : super(key: key);

  @override
  _SurveyDetailPageState createState() => _SurveyDetailPageState();
}

class _SurveyDetailPageState extends State<SurveyDetailPage> {
  var vehicleBloc = new VehicleBloc();
  var _vehicle;

  Future<Vehicle> fetchVehicle() async {
    var response =
        await vehicleBloc.getVehicles(widget.survey.vehicle.toString());
    print('resp: $response');
    var teste = Vehicle.fromJson(response);
    print('car: ${teste.plate}');
    return teste;
  }

  @override
  void initState() {
    fetchVehicle().then((value) => {
          setState(() {
            _vehicle = value;
            print(_vehicle.fuelType);
          })
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes da Vistoria',
          style: AppBarStyle,
        ),
        backgroundColor: PrimaryBlue3,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Local",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      widget.survey.local,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Data de Criação",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      widget.survey.createdDate,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Modelo do Veículo:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _vehicle.model,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Placa do Veículo:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _vehicle.plate,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
