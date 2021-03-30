// To parse this JSON data, do
//
//     final hour = hourFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class HoursModel with ChangeNotifier{

  List<Hour> hours;

  bool loaded=false;

  bool _loading=false;

  double average=0.0;

  var datePickerKey = GlobalKey();

  double patePickerHeight=0.0;

  bool get loading=>_loading;
  DateTime date = DateTime.now();

  void calculateDatePickerHeight() {
    final RenderBox renderBoxRed = (datePickerKey.currentContext.findRenderObject());
    final size = (renderBoxRed.size);
    patePickerHeight = size.height;
    notifyListeners();
  }

  getHours() async {
   if(_loading) return;
   _loading=true;
    try{
      if(date==null) date=DateTime.now();
      final body = {
        "date":date.day,
        'month':date.month,
        'year':date.year
      };
      consoleLog("Calling gethours with body $body");
      final channel = MethodChannel(Constants.CHANNEL_NAME);
      final hours = await channel.invokeMethod(Constants.getHours,body);
      consoleLog("Hours returned = $hours");

      setData(hours);
    }catch(e){
      consoleLog("Error Caught = $e");

    }finally{
      _loading=false;

    }
  }


  void refresh(DateTime date){
    if(date==null) return;
    this.date=date;
    loaded=false;
    notifyListeners();
  }

  void setData(hoursJson) {
    if(hoursJson == null) this.hours= [];
    try{
      this.hours = List<Hour>.from(hoursJson.map((e)=>Hour.fromJson(jsonEncode(e))));
      Iterable<Hour> setHours=hours.where((element) => element.worth>0);
      if(setHours.isNotEmpty)
      average = sumOf<Hour>(setHours,(e)=>(e.worth/5))/setHours.length;
      else average=0.0;
    }catch(e){
      consoleLog("Error caught in setData ${e.stackTrace}");
      this.hours = [];
    }
    loaded=true;
    notifyListeners();
  }

}


class Hour {
  Hour({
    this.date,
    this.month,
    this.year,
    this.id,
    this.time,
    this.worth,
  });

  int date;
  int month;
  int year;
  int id;
  int time;
  int worth;

  factory Hour.fromJson(String str) => Hour.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Hour.fromMap(Map<String, dynamic> json) => Hour(
    date: json["date"] == null ? null : json["date"],
    month: json["month"] == null ? null : json["month"],
    year: json["year"] == null ? null : json["year"],
    id: json["id"] == null ? null : json["id"],
    time: json["time"] == null ? null : json["time"],
    worth: json["worth"] == null ? null : json["worth"],
  );

  Map<String, dynamic> toMap() => {
    "date": date == null ? null : date,
    "month": month == null ? null : month,
    "year": year == null ? null : year,
    "id": id == null ? null : id,
    "time": time == null ? null : time,
    "worth": worth == null ? null : worth,
  };
}
