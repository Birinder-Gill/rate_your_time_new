// To parse this JSON data, do
//
//     final hour = hourFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/utils/api_helper.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AppModel with ChangeNotifier {
  late AnimationController animController;
  var isEmpty = false;

  // Animation Controller for expanding/collapsing the cart menu.
  late AnimationController expandingController;

  bool loaded = false;

  AppModel() {
    final now = DateTime.now();
    selections = [true, if (now.weekday > 1) false, if (now.day > 1) false];
  }

  bool _loading = false;

  var datePickerKey = GlobalKey();

  double patePickerHeight = 0.0;

  late List<bool> selections;

  final DateRangePickerController controller = DateRangePickerController();

  List<DateTime> dates = [DateTime.now()];

  // String frontLabel = '';

  bool get loading => _loading;
  DateTime date = DateTime.now();
  int toggle = 0;

  registerMethodChannel() {
    final channel = const MethodChannel(Constants.CHANNEL_NAME);
    channel.setMethodCallHandler((call) async {
      consoleLog('${call.method}');
    });
  }

  changeViewToggle(int e) async {
    if (toggle == e) return;
    toggle = e;
    _manageTodayCases();
    dates = await _setDates();
    notifyListeners();
  }

  void refresh([DateTime? date]) async {
    if(date!=null)
    this.date = date;
      _manageTodayCases();
    loaded = false;
    dates = await _setDates();
    notifyListeners();
    nextTick(() {
      animController.forward();
    });
  }

  Future<List<DateTime>> _setDates() async {
    if (toggle == 1) {
      return [
        await TimeUtils.getWeekStart(date),
        await TimeUtils.getWeekEnd(date)
      ];
    } else
      return [date];
  }

  String frontLabel(MaterialLocalizations localizations) {
    if (dates.isEmpty) return '-/-';
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
    if (animController.isCompleted??false)
      animController.reverse();
    else
      animController.forward();
  }

  checkIfHoursTableEmpty() async {
    isEmpty = await ApiHelper.isTableEmpty();
    // isEmpty = true;
  }

  ///I don't think we need this now
  void _manageTodayCases() {
    return;
    final now = DateTime.now();
    if (DateUtils.isSameDay(this.date, now)) {
      if (toggle == 1 && this.date.weekday == 1) {
        toggle = 0;
      }
      if (toggle == 2 && this.date.day == 1) {
        toggle = 0;
      }
    }
  }
}

class Hour {
  Hour(
      {required this.date,
      required this.month,
      required this.year,
      required this.id,
      required this.time,
      required this.worth,
      required this.activity,
      required this.note});

  int date;
  int month;
  int year;
  int id;
  int time;
  int worth;
  int activity;
  String note;

  Hour copyWith({
    int? date,
    int? month,
    int? year,
    int? id,
    int? time,
    int? worth,
    int? activity,
    String? note,
  }) =>
      Hour(
        date: date ?? this.date,
        month: month ?? this.month,
        year: year ?? this.year,
        id: id ?? this.id,
        time: time ?? this.time,
        worth: worth ?? this.worth,
        activity: activity ?? this.activity,
        note: note ?? this.note,
      );

  factory Hour.fromJson(String str) => Hour.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (other is Hour) {
      return other.id != 0 && id != 0
          ? (id == other.id)
          : (other.year == year &&
              other.month == month &&
              other.date == date &&
              other.time == time);
    }
    return false;
  }

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

  void update({int? activity, String? note, int? worth}) {
    this.activity = activity??this.activity;
    this.note = note??this.note;
    this.worth = worth??this.worth;
  }

  @override
  int get hashCode => super.hashCode;
}
