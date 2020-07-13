import 'package:app_motor/models/survey_model.dart';
import 'package:app_motor/style.dart';
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

  Future<List<Survey>> fetchSurvey() async {
    var url = "https://appmotorbackend.herokuapp.com/api/survey";
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Token 15fa534faf921067f69b1086a63af9aeb1613e4b"
      },
    );
    var listSurveys = List<Survey>();
    if (response.statusCode == 200) {
      var surveysJson = jsonDecode(response.body);
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
    return _surveys == null
        ? CircularProgressIndicator()
        : ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _surveys[index].local,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Gray3,
                              fontFamily: FontNameDefaultTitle),
                        ),
                        Text(
                          _surveys[index].createdDate,
                          style: TextStyle(
                              fontSize: 15,
                              color: Gray3,
                              fontWeight: FontWeight.w400,
                              fontFamily: FontNameDefaultBody),
                        )
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              );
            },
            itemCount: _surveys.length,
          );
  }
}
