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
              "Registre sua vistoria:",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: PrimaryBlue2,
                fontSize: 18,
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
              keyboardType: TextInputType.text,
              readOnly: true,
              decoration: new InputDecoration(
                labelText: "Placa",
                hintText: widget.plate,
                hintStyle: TextStyle(
                  color: Gray3,
                  fontFamily: FontNameDefaultBody,
                  fontWeight: FontWeight.w400,
                ),
                labelStyle: TextStyle(
                    color: Gray3,
                    fontFamily: FontNameDefaultBody,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: PrimaryBlue1, width: 1.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Gray4, width: 1.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: Icon(
                  Icons.lock,
                  color: Gray4,
                ),
              ),
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
            child: DropdownButtonFormField<String>(
              autovalidate: true,
              value: _local,
              // hint: Text("Selecione o local"),
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
              decoration: new InputDecoration(
                labelText: "Selecione o local:",
                hintStyle: TextStyle(
                  color: PrimaryBlue1,
                  fontFamily: FontNameDefaultBody,
                  fontWeight: FontWeight.w400,
                ),
                labelStyle: TextStyle(
                    color: Gray3,
                    fontFamily: FontNameDefaultBody,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: PrimaryBlue1, width: 1.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Gray3, width: 1.5),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return 'Escolha um local';
              //   }
              //   return null;
              // },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 10,
                child: LinearProgressIndicator(
                  value: 0.35, // percent filled
                  valueColor: AlwaysStoppedAnimation<Color>(SecondaryBlue1),
                  backgroundColor: SecondaryBlue3,
                ),
              ),
            ),
            // child: LinearProgressIndicator(
            //   value: 0.2,
            //   backgroundColor: SecondaryBlue3,
            //   valueColor: new AlwaysStoppedAnimation<Color>(SecondaryBlue1),
            // ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Builder(
                  builder: (context) => FlatButton(
                    color: PrimaryBlue3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Continuar ",
                              style: TextStyle(
                                  color: Gray6,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: FontNameDefaultBody,
                                  fontSize: 18),
                            ),
                            WidgetSpan(
                              child: Icon(
                                Icons.arrow_forward,
                                size: 18,
                                color: Gray6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onPressed: () async {
                      var resultVehicle =
                          await survey.getVehicles(widget.plate);
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
          )
        ],
      ),
      // break;
      //   }
      // },
      // ),
    );
  }
}
