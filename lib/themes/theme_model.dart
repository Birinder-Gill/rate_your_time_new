// To parse this JSON data, do
//
//     final myTheme = myThemeFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

class MyTheme {
  MyTheme({
    @required this.primaryColor,
    @required this.primaryLightColor,
    @required this.primaryDarkColor,
    @required this.secondaryColor,
    @required this.secondaryLightColor,
    @required this.secondaryDarkColor,
    @required this.secondaryTextColor,
    @required this.primaryTextColor,
    @required this.isDark,
  });

  Color primaryColor;
  Color primaryLightColor;
  Color primaryDarkColor;
  Color secondaryColor;
  Color secondaryLightColor;
  Color secondaryDarkColor;
  Color secondaryTextColor;
  Color primaryTextColor;
  bool isDark;

  factory MyTheme.fromJson(String str) => MyTheme.fromMap(json.decode(str));

  get colorScheme =>  ColorScheme(
    primary: primaryLightColor,
    primaryVariant: primaryColor,
    secondary: secondaryColor,
    secondaryVariant: secondaryDarkColor,
    surface: primaryTextColor,
    background: primaryColor,
    error: secondaryDarkColor,
    onPrimary: primaryTextColor,
    onSecondary: secondaryTextColor,
    onSurface: secondaryDarkColor,
    onBackground: secondaryColor,
    onError: primaryTextColor,
    brightness: isDark?Brightness.dark:Brightness.light,
  );

  String toJson() => json.encode(toMap());

  factory MyTheme.fromMap(Map<String, dynamic> json) {
    final _parseColor = (source) {
      return Color(int.parse(source.toString().replaceAll("#", '0xff')));
    };
    return MyTheme(
    primaryColor: json["primaryColor"] == null ? null : _parseColor(json["primaryColor"]),
    primaryLightColor: json["primaryLightColor"] == null ? null : _parseColor(json["primaryLightColor"]),
    primaryDarkColor: json["primaryDarkColor"] == null ? null : _parseColor(json["primaryDarkColor"]),
    secondaryColor: json["secondaryColor"] == null ? null : _parseColor(json["secondaryColor"]),
    secondaryLightColor: json["secondaryLightColor"] == null ? null : _parseColor(json["secondaryLightColor"]),
    secondaryDarkColor: json["secondaryDarkColor"] == null ? null : _parseColor(json["secondaryDarkColor"]),
    secondaryTextColor: json["secondaryTextColor"] == null ? null : _parseColor(json["secondaryTextColor"]),
    primaryTextColor: json["primaryTextColor"] == null ? null : _parseColor(json["primaryTextColor"]),
    isDark: json["isDark"] == null ? null : json["isDark"],
  );
  }

  Map<String, dynamic> toMap() => {
    "primaryColor": primaryColor == null ? null : primaryColor,
    "primaryLightColor": primaryLightColor == null ? null : primaryLightColor,
    "primaryDarkColor": primaryDarkColor == null ? null : primaryDarkColor,
    "secondaryColor": secondaryColor == null ? null : secondaryColor,
    "secondaryLightColor": secondaryLightColor == null ? null : secondaryLightColor,
    "secondaryDarkColor": secondaryDarkColor == null ? null : secondaryDarkColor,
    "secondaryTextColor": secondaryTextColor == null ? null : secondaryTextColor,
    "primaryTextColor": primaryTextColor == null ? null : primaryTextColor,
    "isDark": isDark == null ? null : isDark,
  };


}
