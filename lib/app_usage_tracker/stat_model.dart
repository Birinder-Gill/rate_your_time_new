// To parse this JSON data, do
//
//     final usageStat = usageStatFromMap(jsonString);

import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class UsageStat {
  var appName;


  Uint8List appLogo;

  Color color;

  UsageStat({
    this.lastTimeStamp,
    this.package,
    this.appName,
    this.totalTimeVisible,
    this.firstTimeStamp,
    this.lastTimeUsed,
    this.totalTimeInForeground, this.appLogo, this.color,
  });

  int lastTimeStamp;
  String package;
  int totalTimeVisible;
  int firstTimeStamp;
  int lastTimeUsed;
  int totalTimeInForeground;

  factory UsageStat.fromJson(String str) => UsageStat.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UsageStat.fromMap(Map<String, dynamic> json) {

    final stat =  UsageStat(
    lastTimeStamp: json["LastTimeStamp"] == null ? null : json["LastTimeStamp"],
    package: json["package"] == null ? null : json["package"],
    totalTimeVisible: json["TotalTimeVisible"] == null ? null : json["TotalTimeVisible"],
    firstTimeStamp: json["firstTimeStamp"] == null ? null : json["firstTimeStamp"],
    lastTimeUsed: json["LastTimeUsed"] == null ? null : json["LastTimeUsed"],
    totalTimeInForeground: json["TotalTimeInForeground"] == null ? null : json["TotalTimeInForeground"],
    appName: json["appName"] == null ? 'null' : json["appName"],
      color:json["color"] == null ? null : Color(int.parse(json["color"].replaceAll("#", '0xff')))
  );
    try{
      stat.appLogo= json["appLogo"] == null ? Uint8List(0) : base64.decode(json["appLogo"]);
      // PaletteGenerator.fromImageProvider(MemoryImage(stat.appLogo)).then((value){
      //   stat.color =value.dominantColor.color;
      // });
    }catch(e){
      if(e is FormatException)
      consoleLog(e);
    }
    return stat;
  }

  Map<String, dynamic> toMap() => {
    "LastTimeStamp": lastTimeStamp == null ? null : lastTimeStamp,
    "package": package == null ? null : package,
    "TotalTimeVisible": totalTimeVisible == null ? null : totalTimeVisible,
    "firstTimeStamp": firstTimeStamp == null ? null : firstTimeStamp,
    "LastTimeUsed": lastTimeUsed == null ? null : lastTimeUsed,
    "TotalTimeInForeground": totalTimeInForeground == null ? null : totalTimeInForeground,
    "appName":appName,
    // "appLogo":base64.encode(appLogo),
  };
}
