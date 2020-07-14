import 'package:app_motor/models/survey_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SurveyListPage extends StatefulWidget {
  SurveyListPage({Key key}) : super(key: key);

  @override
  _SurveyListPageState createState() => _SurveyListPageState();
}

class _SurveyListPageState extends State<SurveyListPage> {

  List<Survey> _surveys = List<Survey>();

  Future<List<Survey>>fetchSurvey() async {
    var url = "https://appmotorbackend.herokuapp.com/api/survey";
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": "Token 15fa534faf921067f69b1086a63af9aeb1613e4b"},
    );
    var listSurveys = List<Survey>();
    if (response.statusCode == 200) {
      var surveyDecode = utf8.decode(response.bodyBytes);
      var surveysJson = jsonDecode(surveyDecode);
      print('response: ${response.body}');
      print(surveysJson);
      for (var surveyJson in surveysJson) {
        listSurveys.add(Survey.fromJson(surveyJson));
      }
    }
    return listSurveys;
  }

  @override
  void initState() {
    fetchSurvey().then((value) {
      setState(() {
        _surveys.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de vistorias'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_surveys[index].local, style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                  Text(_surveys[index].createdDate, style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),)
                ],
              ),
            ),
          );
        },
        itemCount: _surveys.length,
      ),
    );
  }
}
