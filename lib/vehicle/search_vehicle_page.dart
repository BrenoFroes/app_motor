import 'package:app_motor/style.dart';
import 'package:app_motor/vehicle/vehicle_bloc.dart';
import 'package:app_motor/survey/survey_register_page.dart';
import 'package:app_motor/widgets/card_body.dart';
import 'package:app_motor/widgets/curved_navigation.dart';
import 'package:app_motor/vehicle/vehicle_register_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class SearchVehicle extends StatefulWidget {
  @override
  _SearchVehicleState createState() => _SearchVehicleState();
}

class _SearchVehicleState extends State<SearchVehicle> {
  var bloc = new VehicleBloc();
  var response;
  bool is_visible = false;
  var _modelo = "";
  var _placa = "";

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
                var plate = bloc.plateCtrl.text;
                var response;
                response = await bloc.getVehicles(plate);
                if (response == null) {
                  final message = SnackBar(
                    backgroundColor: Gray6,
                    content: Text(
                      "Não foi possivel encontrar um veiculo com a placa $plate. Tente novamente",
                      style: TextStyle(
                        color: PrimaryRed2,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontNameDefaultBody),
                    ),
                  );
                  Scaffold.of(context).showSnackBar(message);
                  setState(
                    () {
                      is_visible = true;
                    },
                  );
                } else {
                  final message = SnackBar(
                    content: Text("Carro encontrado."),
                  );
                  Scaffold.of(context).showSnackBar(message);
                  setState(() {
                    is_visible = false;
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
          is_visible == false
              ? Visibility(
                  visible: !is_visible,
                  child: CardBody(_modelo, _placa),
                )
              : Visibility(
                  visible: is_visible,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 200,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.not_interested,
                                  size: 24,
                                  color: Gray4,
                                ),
                              ),
                              TextSpan(
                                text: " Sem resultados",
                                style: TextStyle(
                                    color: Gray4,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: FontNameDefaultBody,
                                    fontSize: 22),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FlatButton(
                          color: Gray4,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 15.0,
                                bottom: 15.0,
                                left: 35.0,
                                right: 35.0),
                            child: Text(
                              "Cadastrar",
                              style: TextStyle(
                                color: Gray6,
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                fontFamily: FontNameDefaultBody,
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VehicleRegisterPage(
                                    plate: bloc.plateCtrl.text),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
      bottomNavigationBar: CurvedNavigation(),
    );
  }
}
