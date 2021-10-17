// To parse this JSON data, do
//
//     final myTheme = myThemeFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

class MyTheme {
  MyTheme({
    @required this.cardsOnScaffold,
    @required this.scaffoldBackground,
    @required this.backdropColor,
    @required this.onPrimaryDark,
    @required this.accentColor,
    @required this.textOnDark,
    @required this.textOnLight,
    @required this.isDark,
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
    primaryVariant: backdropColor,
    secondary: onPrimaryDark,
    secondaryVariant: accentColor,
    surface: cardsOnScaffold,
    background: scaffoldBackground,
    error: Colors.red,
    onPrimary: textOnLight,
    onSecondary: textOnDark,
    onSurface: backdropColor,
    onBackground: accentColor,
    onError: Colors.white,
    brightness: isDark?Brightness.dark:Brightness.light,
  );

  String toJson() => json.encode(toMap());

  factory MyTheme.fromMap(Map<String, dynamic> json) {
    final _parseColor = (source) {
      return Color(int.parse(source.toString().replaceAll("#", '0xff')));
    };
    return MyTheme(
    cardsOnScaffold: json["primaryColor"] == null ? null : _parseColor(json["primaryColor"]),
    scaffoldBackground: json["primaryLightColor"] == null ? null : _parseColor(json["primaryLightColor"]),
    backdropColor: json["primaryDarkColor"] == null ? null : _parseColor(json["primaryDarkColor"]),
    onPrimaryDark: json["secondaryColor"] == null ? null : _parseColor(json["secondaryColor"]),
    accentColor: json["secondaryDarkColor"] == null ? null : _parseColor(json["secondaryDarkColor"]),
    textOnDark: json["secondaryTextColor"] == null ? null : _parseColor(json["secondaryTextColor"]),
    textOnLight: json["primaryTextColor"] == null ? null : _parseColor(json["primaryTextColor"]),
    isDark: json["isDark"] == null ? null : json["isDark"],
  );
  }

  Map<String, dynamic> toMap() => {
    "primaryColor": cardsOnScaffold == null ? null : cardsOnScaffold,
    "primaryLightColor": scaffoldBackground == null ? null : scaffoldBackground,
    "primaryDarkColor": backdropColor == null ? null : backdropColor,
    "secondaryColor": onPrimaryDark == null ? null : onPrimaryDark,
    "secondaryDarkColor": accentColor == null ? null : accentColor,
    "secondaryTextColor": textOnDark == null ? null : textOnDark,
    "primaryTextColor": textOnLight == null ? null : textOnLight,
    "isDark": isDark == null ? null : isDark,
  };


}
