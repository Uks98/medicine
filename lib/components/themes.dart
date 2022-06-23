import 'package:flutter/material.dart';
import 'package:medicine/components/colors.dart';

class DoryThemes {

 static ThemeData get lightTheme => ThemeData(
  fontFamily: "GmarketSans",
  primarySwatch: DoryColors.primaryMeterialColor,
   scaffoldBackgroundColor: Colors.white,
   splashColor: Colors.white,
   textTheme: _textTheme,
   appBarTheme: _appbarTheme,
   brightness: Brightness.light
  );

 static ThemeData get darkTheme => ThemeData(
     fontFamily: "GmarketSans",
     primarySwatch: DoryColors.primaryMeterialColor,
     //scaffoldBackgroundColor: Colors.white,
     splashColor: Colors.white,
     textTheme: _textTheme,
     brightness: Brightness.dark
 );
 static const AppBarTheme _appbarTheme = AppBarTheme(
  backgroundColor: Colors.white,
  elevation: 0.0,
  iconTheme: IconThemeData(color: DoryColors.primaryColor)
 );
  static const TextTheme _textTheme = TextTheme(
  headline4: TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w400,
  ),
  subtitle1: TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  ),
  subtitle2: TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  ),
  bodyText1: TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w300,
  ),
  bodyText2: TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w300,
  ),
  button: TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w300,
  ),
  );
}