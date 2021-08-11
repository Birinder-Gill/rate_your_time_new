// To parse this JSON data, do
//
//     final hour = hourFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HoursModel with ChangeNotifier {

  AnimationController animController;

  // Animation Controller for expanding/collapsing the cart menu.
  AnimationController expandingController;

  bool loaded = false;

  bool _loading = false;


  var datePickerKey = GlobalKey();

  double patePickerHeight = 0.0;

  final selections = [true,false,false];

  final DateRangePickerController controller = DateRangePickerController();

  String frontLabel = '';


  bool get loading => _loading;
  DateTime date = DateTime.now();
  int toggle=0;

  changeViewToggle(int e)async{
    selections[toggle] = false;
   toggle=e;
    selections[toggle]=true;
    frontLabel = await _setLabel();
    notifyListeners();
  }

  void calculateDatePickerHeight() {
    // final RenderBox renderBoxRed = (datePickerKey.currentContext
    //     .findRenderObject());
    // final size = (renderBoxRed.size);
    // patePickerHeight = size.height;
    // notifyListeners();
  }

  void refresh(DateTime date) async{
    if (date == null) return;
    this.date = date;
    loaded = false;
    frontLabel = await _setLabel();
    notifyListeners();
    nextTick((){
      animController.forward();
    });
  }

  Future<String> _setLabel() async{
    switch(toggle){
      case 0:{
        return "${TimeUtils.formatDate(date)}";
      }
      case 1:{
        return "${date.day}/${date.month} to ${TimeUtils.formatDate(await TimeUtils.getWeekEnd(date))}";
      }
      default:{
        return "${Constants.months[date.month-1]} ${date.year}";
      }

    }
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
    this.activity,
    this.note
  });

  int date;
  int month;
  int year;
  int id;
  int time;
  int worth;
  int activity;
  String note;

  factory Hour.fromJson(String str) => Hour.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Hour.fromMap(Map<String, dynamic> json) =>
      Hour(
        date: json["date"] == null ? null : json["date"],
        month: json["month"] == null ? null : json["month"],
        year: json["year"] == null ? null : json["year"],
        id: json["id"] == null ? null : json["id"],
        time: json["time"] == null ? null : json["time"],
        worth: json["worth"] == null ? null : json["worth"],
        activity: json["activity"] == null ? null : json["activity"],
        note: json["note"] == null ? null : json["note"],
      );

  Map<String, dynamic> toMap() =>
      {
        "date": date == null ? null : date,
        "month": month == null ? null : month,
        "year": year == null ? null : year,
        "id": id == null ? null : id,
        "time": time == null ? null : time,
        "worth": worth == null ? null : worth,
        "activity": activity,
        "note": note
      };

  void update({int activity, String note}) {
    this.activity = activity;
    this.note = note;
  }
}
