import 'package:app_motor/vehicle/vehicle_bloc.dart';
import 'package:app_motor/vehicle/vehicle_register_page.dart';
import 'package:flutter/material.dart';

class SearchVehicle extends StatefulWidget {
  @override
  _SearchVehicleState createState() => _SearchVehicleState();
}

class _SearchVehicleState extends State<SearchVehicle> {
  var bloc = new VehicleBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
                controller: bloc.plateCtrl,
                decoration: InputDecoration(
                  labelText: "Placa",
                ),
                keyboardType: TextInputType.text)),
        Padding(
          padding: EdgeInsets.all(20),
          child:FlatButton(
            color: Theme.of(context).primaryColor,
            child: Text("Buscar",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            onPressed: ()async{
                var plate = bloc.plateCtrl.text;
                var response = await bloc.getVehicles(plate);
                if(response["id"] == null){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>VehicleRegisterWidget()),);
                }
            },
          )
        )
      ],
    ));
  }
}
