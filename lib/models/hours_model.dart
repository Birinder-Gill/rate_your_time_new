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

  final selections = [true, false, false];

  final DateRangePickerController controller = DateRangePickerController();

  List<DateTime> dates = [DateTime.now()];

  // String frontLabel = '';

  bool get loading => _loading;
  DateTime date = DateTime.now();
  int toggle = 0;

  changeViewToggle(int e) async {
    if (toggle == e) return;
    selections[toggle] = false;
    toggle = e;
    selections[toggle] = true;
    dates = await _setLabel();
    notifyListeners();
  }

  void calculateDatePickerHeight() {
    // final RenderBox renderBoxRed = (datePickerKey.currentContext
    //     .findRenderObject());
    // final size = (renderBoxRed.size);
    // patePickerHeight = size.height;
    // notifyListeners();
  }

  void refresh([DateTime date]) async {
    if (date == null) {
      if (this.date == null) return;
    } else {
      this.date = date;
    }
    loaded = false;
    dates = await _setLabel();
    notifyListeners();
    nextTick(() {
      animController.forward();
    });
  }

  Future<List<DateTime>> _setLabel() async {
    if (toggle == 1) {
      return [
        await TimeUtils.getWeekStart(date),
        await TimeUtils.getWeekEnd(date)
      ];
    } else
      return [date];
  }

  String frontLabel(MaterialLocalizations localizations) {
    if (dates == null || dates.isEmpty) return '-/-';
    switch (toggle) {
      case 0:
        return localizations.formatShortDate(dates[0]);
      case 1:
        return "${localizations.formatShortMonthDay(dates[0])}-${localizations.formatShortMonthDay(dates[1])}";
      default:
        return localizations.formatMonthYear(date);
    }
  }

  void toggleBackdrop() {
    if (animController.isCompleted)
      animController.reverse();
    else
      animController.forward();
  }
}

class Hour {
  Hour(
      {this.date,
      this.month,
      this.year,
      this.id,
      this.time,
      this.worth,
      this.activity,
      this.note});

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

  factory Hour.fromMap(Map<String, dynamic> json) => Hour(
        date: json["date"] == null ? null : json["date"],
        month: json["month"] == null ? null : json["month"],
        year: json["year"] == null ? null : json["year"],
        id: json["id"] == null ? null : json["id"],
        time: json["time"] == null ? null : json["time"],
        worth: json["worth"] == null ? null : json["worth"],
        activity: json["activity"] == null ? null : json["activity"],
        note: json["note"] == null ? null : json["note"],
      );

  Map<String, dynamic> toMap() => {
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
