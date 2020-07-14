import 'dart:convert';

import 'package:app_motor/audio/recording_audio_page.dart';
import 'package:app_motor/style.dart';
import 'package:app_motor/survey/survey_bloc.dart';
import 'package:app_motor/vehicle/vehicle_bloc.dart';
import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  final String plate;

  const SurveyPage({Key key, this.plate}) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  var vehicle = new VehicleBloc();
  var survey = new SurveyBloc();
  var _local;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.plate,
          style: AppBarStyle,
        ),
        backgroundColor: PrimaryBlue3,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            child: Text(
              "Crie um novo veículo:",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: PrimaryBlue2,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: FontNameDefaultBody,
              ),
            ),
            padding: const EdgeInsets.only(top: 30, left: 25),
          ),
          // future: vehicle.getVehicles(),
          // builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          //   switch (snapshot.connectionState) {
          //     case ConnectionState.none:
          //       // TODO: Handle this case.
          //       break;
          //     case ConnectionState.waiting:
          //       return Center(child: CircularProgressIndicator());
          //       break;
          //     case ConnectionState.active:
          //       // TODO: Handle this case.
          //       break;
          //     case ConnectionState.done:
          //       return ListView(
          //         children: <Widget>[
          // ListTile(
          //   title: Text(snapshot.data["model"]),
          //   subtitle: Text(snapshot.data["plate"]),
          // ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              controller: survey.vehicleCtrl,
              decoration: InputDecoration(
                labelText: "Placa",
                hintText: widget.plate,
                hintColor: PrimaryBlue1,
              ),
              keyboardType: TextInputType.text,
              // onEditingComplete: () async {
              //   var result = await survey.getVehicles(survey.vehicleCtrl.text);
              //   survey.idVehicle = result["id"];
              //   print(result);
              //   print(result["id"]);
              // },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: DropdownButton<String>(
              value: _local,
              hint: Text("Selecione o local"),
              items: <String>[
                'Ponto de Venda',
                'Céu aberto',
                'Residência cliente',
                'Pátio de leilão',
                'Pátio de locadora',
                'Pátio de vistoria',
                'Revenda autorizada',
                'Lojista'
              ].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String category) {
                setState(
                  () {
                    _local = category;
                    controller:
                    survey.localCtrl = _local;
                    print("Selected: ${_local}");
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Builder(
              builder: (context) => FlatButton(
                color: Theme.of(context).primaryColor,
                child: Text("Enviar",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                onPressed: () async {
                  var resultVehicle = await survey.getVehicles(widget.plate);
                  print(resultVehicle);
                  print(resultVehicle["id"]);
                  var surveyBody = {};
                  //surveyBody["idVehicle"] = resultVehicle["id"];
                  String idVehicle = resultVehicle["id"].toString();
                  surveyBody["local"] = survey.localCtrl;
                  //print("idVehicle" + surveyBody["idVehicle"]);
                  print("local" + surveyBody["local"]);
                  // final String plateCtrl = bloc.plateCtrl.text;
                  // final String yearCtrl = bloc.yearCtrl;
                  // final String modelCtrl = bloc.modelCtrl.text;
                  // final String mileageCtrl = bloc.mileageCtrl.toString();
                  // final String fuelCtrl = bloc.fuelCtrl;
                  // final String turboCtrl = bloc.turboCtrl.toString();
                  // print("placa" + plateCtrl);
                  // print("ano" + yearCtrl);
                  // print("model" + modelCtrl);
                  // print("KM" + mileageCtrl.toString());
                  // print("fuel" + fuelCtrl);
                  // print("turbo" + turboCtrl.toString());
                  var body = jsonEncode(surveyBody);
                  print("body" + body.toString());
                  var result = await survey.postSurvey(body, idVehicle);
                  print(result.body);
                  print(result.statusCode);
                  if (result.statusCode == 201) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecordingAudioPage()),
                    );
                  } else {
                    final message =
                        SnackBar(content: Text("Erro de autenticação"));
                    Scaffold.of(context).showSnackBar(message);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      // break;
      //   }
      // },
      // ),
    );
  }
}
