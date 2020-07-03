import 'dart:convert';
import 'package:app_motor/survey/survey_register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:app_motor/vehicle/search_vehicle_page.dart';
import 'package:app_motor/vehicle/vehicle_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SingingCharacter { sim, nao }

class VehicleRegisterPage extends StatefulWidget {
  final String plate;
  const VehicleRegisterPage ({ Key key, this.plate }): super(key: key);
  @override
  _VehicleRegisterPageState createState() => _VehicleRegisterPageState();
}


class _VehicleRegisterPageState extends State<VehicleRegisterPage> {
  var texto = 'olá';
  var bloc = new VehicleBloc();
  var _fuel;
  String _date = "Não selecionado";
  final formattedDate = new DateFormat('yyyy');
  SingingCharacter _character = SingingCharacter.nao;
  int _value = 10;

  getToken() async {
    var prefs = await SharedPreferences.getInstance();
    texto = prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de veiculo"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.error),
            onPressed: () {


            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              controller: bloc.plateCtrl,
              decoration: InputDecoration(
                labelText: "Placa",
                hintText: widget.plate
              ),
              keyboardType: TextInputType.text,
              readOnly: true
            ),
          ),
          IconButton(icon:Icon(Icons.edit),
           onPressed:(){
             Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) => SearchVehicle()),
             );
           }),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 4.0,
              onPressed: () {
                DatePicker.showDatePicker(context,
                    theme: DatePickerTheme(
                      containerHeight: 210.0,
                    ),
                    showTitleActions: true,
                    minTime: DateTime(2000),
                    maxTime: DateTime(2022), onConfirm: (date) {
                      print('confirm $date');
                      _date = '${date.year}';
                      print('date ${_date}');
                      setState(() {});
                      var f = formattedDate.format(date);
                      var e = int.parse(f);
                      print("year:" + e.toString());
                      controller:
                      bloc.yearCtrl = e;
                      print('date ${bloc.yearCtrl}');
                    }, currentTime: DateTime(2012), locale: LocaleType.pt);
              },
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.date_range,
                                size: 18.0,
                                color: Colors.teal,
                              ),
                              Text(
                                " $_date",
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(
                      "  Mudar",
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              controller: bloc.modelCtrl,
              decoration: InputDecoration(
                labelText: "Modelo",
              ),
              keyboardType: TextInputType.text,
              validator:(String value){
                if(value.isEmpty)
                  return "Placa não valida";
                else
                  return null;
                } ,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: DropdownButton<String>(
              value: _fuel,
              hint: Text("Selecione o combustível"),
              items: <String>['Gasolina', 'Álcool', 'Gás', 'Flex', 'Diesel']
                  .map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String category) {
                setState(
                      () {
                    _fuel = category;
                    controller:
                    bloc.fuelCtrl = _fuel;
                    print("Selected: ${_fuel}");
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Turbo',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RadioListTile<SingingCharacter>(
                      title: const Text('Não'),
                      value: SingingCharacter.nao,
                      groupValue: _character,
                      onChanged: (SingingCharacter value) {
                        setState(
                              () {
                            _character = value;
                            controller:
                            bloc.turboCtrl = false;
                          },
                        );
                      },
                    ),
                    RadioListTile<SingingCharacter>(
                      title: const Text('Sim'),
                      value: SingingCharacter.sim,
                      groupValue: _character,
                      onChanged: (SingingCharacter value) {
                        setState(() {
                          _character = value;
                          controller:
                          bloc.turboCtrl = true;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Quilometragem',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.red[700],
                    inactiveTrackColor: Colors.red[100],
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 4.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    thumbColor: Colors.redAccent,
                    overlayColor: Colors.red.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    activeTickMarkColor: Colors.red[700],
                    inactiveTickMarkColor: Colors.red[100],
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: Colors.redAccent,
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child: Slider(
                    value: _value.toDouble(),
                    min: 10,
                    max: 200,
                    divisions: 19,
                    label: '$_value' + ' mil',
                    onChanged: (value) {
                      setState(
                            () {
                          _value = value.round();
                          controller:
                          bloc.mileageCtrl = _value;
                        },
                      );
                    },
                  ),
                ),
              ],
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
                  var vehicle = {};
                  vehicle["plate"] = widget.plate;
                  vehicle["year"] = bloc.yearCtrl;
                  vehicle["model"] = bloc.modelCtrl.text;
                  vehicle["mileage"] = bloc.mileageCtrl;
                  vehicle["fuelType"] = bloc.fuelCtrl;
                  vehicle["turbo"] = bloc.turboCtrl;
                  var body = jsonEncode(vehicle);
                  print("body" + body.toString());
                  var result = await bloc.registerVehicle(body);
                  print(result.body);
                  print(result.statusCode);
                  if (result.statusCode == 201) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SurveyPage(plate: widget.plate)),
                    );
                  } else {
                    final message =
                    SnackBar(content: Text(result.body));
                    Scaffold.of(context).showSnackBar(message);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
