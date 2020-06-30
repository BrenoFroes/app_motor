import 'package:flutter/material.dart';

class SurveyListPage extends StatefulWidget {
  SurveyListPage({Key key, this.title, this.surveys}) : super(key: key);

  final String title;
  final surveys;

  @override
  _SurveyListPageState createState() => _SurveyListPageState();
}

class _SurveyListPageState extends State<SurveyListPage> {
  var list = ["one", "two", "three", "four"];
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
            for(var item in widget.surveys) Text(item['local'], style: TextStyle(fontSize: 30),)
          ],
        ),
      ),
    );
  }
}
