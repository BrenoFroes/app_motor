import 'package:app_motor/style.dart';
import 'package:app_motor/survey/survey_register_page.dart';
import 'package:app_motor/vehicle/vehicle_bloc.dart';
import 'package:app_motor/vehicle/vehicle_register_page.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class SearchVehicle extends StatefulWidget {
  @override
  _SearchVehicleState createState() => _SearchVehicleState();
}

class _SearchVehicleState extends State<SearchVehicle> {
  var bloc = new VehicleBloc();
  var response;
  bool is_Visible = false;
  var _modelo = "";
  var _placa = "";
  bool _progressVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            keyboardType: TextInputType.text,
            controller: bloc.plateCtrl,
            decoration: InputDecoration(
              labelText: "Buscar placa:",
              labelStyle: TextStyle(
                color: Gray5,
                fontSize: 20.0,
                fontFamily: FontNameDefaultTitle,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: const TextStyle(
                color: Gray5,
                fontSize: 20.0,
                fontFamily: FontNameDefaultTitle,
                fontWeight: FontWeight.w600),
            validator: (String value) {
              if (value.length != 7)
                return "Placa inválida.";
              else if (value == null)
                return "Por favor, insira uma placa.";
              else
                return null;
            },
          ),
          backgroundColor: PrimaryBlue1,
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  setState(
                        () {
                      _progressVisible = true;
                    },
                  );
                  var plate = bloc.plateCtrl.text;
                  var response;
                  //response = await bloc.getVehicles(plate);
                  await bloc.getVehicles(plate).then((value) => {
                    response=value,
                    setState(
                      () {
                        _progressVisible = false;
                      },
                    ),
                  });
                  if (response == null) {
                    final message = SnackBar(
                      content: Text(
                          "Não foi possivel encontrar um veiculo com a placa $plate. Tente novamente"),
                    );
                    Scaffold.of(context).showSnackBar(message);
                    setState(
                      () {
                        is_Visible = true;
                      },
                    );
                  } else {
                    final message = SnackBar(
                      content: Text("Carro encontrado."),
                    );
                    Scaffold.of(context).showSnackBar(message);
                    setState(() {
                      is_Visible = false;
                      _modelo = response["model"];
                      _placa = response["plate"];
                    });
                  }
                },
              ),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Visibility(
              visible: !is_Visible,
              child: ListTile(
                title: Text(_modelo),
                subtitle: Text(_placa),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SurveyPage(plate: response["plate"])),
                  );
                },
              ),
            ),
            Visibility(
              visible: is_Visible,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text("Sem resultados."), 
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: Text("Cadastrar",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VehicleRegisterPage(
                                  plate: bloc.plateCtrl.text)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: is_Visible,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 200),
                child: Center(
                ),
              ),
            ),
            Visibility(
              visible: _progressVisible,
              child: CircularProgressIndicator(),
            )
          ],
        ));
  }
}
