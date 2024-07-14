// To parse this JSON data, do
//
//     final myTheme = myThemeFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

class MyTheme {
  MyTheme({
    required this.cardsOnScaffold,
    required this.scaffoldBackground,
    required this.backdropColor,
    required this.onPrimaryDark,
    required this.accentColor,
    required this.textOnDark,
    required this.textOnLight,
    required this.isDark,
  });

  Color cardsOnScaffold;
  Color scaffoldBackground;
  Color backdropColor;
  Color onPrimaryDark;
  Color accentColor;
  Color textOnDark;
  Color textOnLight;
  bool isDark;

  factory MyTheme.fromJson(String str) => MyTheme.fromMap(json.decode(str));

  get colorScheme =>  ColorScheme(
    primary: scaffoldBackground,
    secondary: onPrimaryDark,
    surface: cardsOnScaffold,
    error: Colors.red,
    onPrimary: textOnLight,
    onSecondary: textOnDark,
    onSurface: backdropColor,
    onError: Colors.white,
    brightness: isDark?Brightness.dark:Brightness.light,
  );

  String toJson() => json.encode(toMap());

  factory MyTheme.fromMap(Map<String, dynamic> json) {
    final _parseColor = (source) {
      return Color(int.parse(source.toString().replaceAll("#", '0xff')));
    };
    return MyTheme(
    cardsOnScaffold: _parseColor(json["primaryColor"]),
    scaffoldBackground: _parseColor(json["primaryLightColor"]),
    backdropColor: _parseColor(json["primaryDarkColor"]),
    onPrimaryDark: _parseColor(json["secondaryColor"]),
    accentColor: _parseColor(json["secondaryDarkColor"]),
    textOnDark: _parseColor(json["secondaryTextColor"]),
    textOnLight: _parseColor(json["primaryTextColor"]),
    isDark: json["isDark"] == null ? null : json["isDark"],
  );
  }

  Map<String, dynamic> toMap() => {
    "primaryColor": cardsOnScaffold ,
    "primaryLightColor": scaffoldBackground ,
    "primaryDarkColor": backdropColor ,
    "secondaryColor": onPrimaryDark ,
    "secondaryDarkColor": accentColor ,
    "secondaryTextColor": textOnDark ,
    "primaryTextColor": textOnLight ,
    "isDark": isDark,
  };


}
