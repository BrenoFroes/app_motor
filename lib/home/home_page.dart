import 'package:app_motor/style.dart';
import 'package:app_motor/survey/survey_list_page.dart';
import 'package:app_motor/vehicle/search_vehicle_page.dart';
import 'package:app_motor/vehicle/vehicle_register_page.dart';
import 'package:app_motor/survey/survey_bloc.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var survey = new SurveyBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                color: Theme.of(context).primaryColor,
                child: Text('Nova Vistoria', style: TextStyle(color: PrimaryRed3, fontFamily: FontNameDefaultBody, fontWeight: FontWeight.w800),),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchVehicle()));
                },
              ),
              FlatButton(
                color: Theme.of(context).primaryColor,
                child: Text('Visualizar Vistorias',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SurveyListPage())
                  );
                },
              ),
            ]),
      ),
    );
  }
}
