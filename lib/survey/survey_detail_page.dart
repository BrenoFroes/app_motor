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
  var response;
  var is_visible = true;

  Future<Vehicle> fetchVehicle() async {
    print(
      "widget" + widget.survey.vehicle.toString(),
    );
    await vehicleBloc.getVehicles(widget.survey.vehicle.toString()).then(
          (value) => {
            response = value,
            setState(
              () {
                is_visible = false;
              },
            ),
          },
        );
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
          'Detalhes da vistoria',
          style: AppBarStyle,
        ),
        backgroundColor: PrimaryBlue3,
      ),
      body: (is_visible == false)
          ? Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "Local:",
                              style: TitleCard,
                            ),
                            subtitle: Text(
                              widget.survey.local,
                              style: SubitleCard,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "Data de Criação:",
                              style: TitleCard,
                            ),
                            subtitle: Text(
                              widget.survey.createdDate,
                              style: SubitleCard,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "Modelo do Veículo:",
                              style: TitleCard,
                            ),
                            subtitle: Text(
                              _vehicle.model,
                              style: SubitleCard,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "Placa do Veículo:",
                              style: TitleCard,
                            ),
                            subtitle: Text(
                              _vehicle.plate,
                              style: SubitleCard,
                            ),
                          ),
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ],
            )
          : ContentLoading(),
    );
  }
}

class ContentLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 150.0,
        width: 150.0,
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Gray5),
            strokeWidth: 10.0),
      ),
    );
  }
}
