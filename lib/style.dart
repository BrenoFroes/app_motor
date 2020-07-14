import 'package:flutter/material.dart';

const LargeTextSize = 26.0;
const MediumTextSize = 20.0;
const BodyTextSize = 16.0;

const String FontNameDefaultTitle = 'Raleway';
const String FontNameDefaultBody = 'Roboto';

const Color PrimaryBlue1 = Color(0xFF32318C);
const Color PrimaryBlue2 = Color(0xFF38379F);
const Color PrimaryBlue3 = Color(0xFF4948C1);

const Color SecondaryBlue1 = Color(0xFFA4F9C3);
const Color SecondaryBlue2 = Color(0xFFBDFBD4);
const Color SecondaryBlue3 = Color(0xFFEDFFF4);

const Color PrimaryRed1 = Color(0xFFF33030);
const Color PrimaryRed2 = Color(0xFFFF4A4A);
const Color PrimaryRed3 = Color(0xFFFF6B6B);

const Color Gray1 = Color(0xFF333333);
const Color Gray2 = Color(0xFF4F4F4F);
const Color Gray3 = Color(0xFF828282);
const Color Gray4 = Color(0xFFBDBDBD);
const Color Gray5 = Color(0xFFE0E0E0);
const Color Gray6 = Color(0xFFF2F2F2);

const AppBarTextStyle = TextStyle(
  fontFamily: FontNameDefaultTitle,
  fontWeight: FontWeight.w800,
  fontSize: MediumTextSize,
  color: PrimaryBlue1,
);

const TitleTextStyle = TextStyle(
  fontFamily: FontNameDefaultTitle,
  fontWeight: FontWeight.w600,
  fontSize: LargeTextSize,
  color: PrimaryRed1,
);

const Body1TextStyle = TextStyle(
  fontFamily: FontNameDefaultBody,
  fontWeight: FontWeight.w800,
  fontSize: BodyTextSize,
  color: Colors.black,
);

const AppBarStyle = TextStyle(
    color: Gray5,
    fontSize: 18.0,
    fontFamily: FontNameDefaultTitle,
    fontWeight: FontWeight.w600);

// ThemeData buildTheme() {
//   final ThemeData base = ThemeData();
//   return base.copyWith(
//     primaryColor: PrimaryBlue1,
//     accentColor: PrimaryRed3,
//     scaffoldBackgroundColor: Colors.white,
//     primaryIconTheme: base.iconTheme.copyWith(color: PrimaryBlue1),
//     buttonColor: PrimaryBlue3,
//     hintColor: PrimaryBlue1,
//     inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(),
//       labelStyle: TextStyle(color: PrimaryBlue3, fontSize: 24.0),
//     ),
//   );
// }
