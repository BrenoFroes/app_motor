import 'package:app_motor/vehicle/vehicle_bloc.dart';
import 'package:app_motor/vehicle/vehicle_register_page.dart';
import 'package:flutter/material.dart';

class SearchVehicle extends StatefulWidget {
  @override
  _SearchVehicleState createState() => _SearchVehicleState();
}

class _SearchVehicleState extends State<SearchVehicle> {
  var bloc = new VehicleBloc();
  var response;
  bool is_Visible = false;
  var modelo="";
  var placa="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            SizedBox(
                width:200 ,
                child:
            TextField(
              controller: bloc.plateCtrl,
              decoration:InputDecoration(
                hintText:'Buscar',
                hintStyle: const TextStyle(color: Colors.white30),

              ),
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
            )),
            Builder(builder:(context)=>IconButton(
              icon: Icon(Icons.search),
              onPressed: ()async {
                var plate = bloc.plateCtrl.text;
                response =  await bloc.getVehicles(plate);
                print(response);
                if(response == null){
                  final message =
                  SnackBar(content: Text("Não foi possivel encontrar um veiculo com essa placa"));
                  Scaffold.of(context).showSnackBar(message);
                  setState(() {
                    is_Visible=true;
                  });
                }else{
                  final message= SnackBar(content: Text("Carro  cadastrado"));
                  Scaffold.of(context).showSnackBar(message);
                  setState(() {
                    is_Visible=false;
                    modelo= response["model"];
                    placa= response["plate"];
                  });

                }


              },
            )),
          ],
        ),
        body: ListView(
      children: <Widget>[
          Visibility(
          visible:!is_Visible,
          child:ListTile( title:Text(modelo),subtitle:Text(placa),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VehicleRegisterWidget(plate:response["plate"])),
              );
            },)),
            Visibility(
             visible:is_Visible,
             child:Padding(
                 padding: EdgeInsets.symmetric(vertical:200),
                 child:Center(child:FlatButton(
                 color: Theme.of(context).primaryColor,
                 child: Text("Cadastrar",
                     style: TextStyle(
                         color: Colors.white,
                         fontWeight: FontWeight.bold,
                         fontSize: 20)),
                 onPressed: (){
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) => VehicleRegisterWidget(plate:response["plate"],)),
                   );
                 }
             ))
           ))





      ],
    ));
  }
}
