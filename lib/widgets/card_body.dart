import 'package:flutter/material.dart';

import '../style.dart';

class CardBody extends StatelessWidget {
  String title = '';
  String subtitle = '';

  CardBody(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        child: Card(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Gray3,
                      fontFamily: FontNameDefaultTitle),
                ),
                Text(
                  subtitle,
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
      ),
    );
  }
}
