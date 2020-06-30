import 'package:app_motor/survey/survey_list_page.dart';
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
                child: Text('Nova Vistoria',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VehicleRegisterWidget()));
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
                  var list = await survey.surveysList();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SurveyListPage(title: 'Lista de vistorias', surveys: list))
                  );
                },
              ),
            ]),
      ),
    );
  }
}
