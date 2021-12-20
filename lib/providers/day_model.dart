import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/models/average_data_model.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/average_model.dart';
import 'package:rate_your_time_new/utils/api_helper.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class DayModel with ChangeNotifier {
  bool _loading = false;
  List<Hour> hours;
  double average = 0.0;

  final DateTime date;
  bool loaded = false;

  Map hd = {};

  DayModel({@required this.date}) {
    getHours();
  }

  getHours() async {
    if (_loading) return;
    _loading = true;
    try {
      final hours = await ApiHelper.getData(date);
      consoleLog("Hours returned = ${hours.map((e) => e['time'])}");

      setData(hours);
    } catch (e, trace) {
      consoleLog("Error Caught = $e,$trace");
    } finally {
      _loading = false;
    }
  }

  updateHour(Hour hour) async {
    final body = hour.toMap();
    print(hour.toMap());
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    await channel.invokeMethod(Constants.updateHour, body);
    _updateInMemory(hour);
    _calculateAverage();
    notifyListeners();
  }

  void setData(hoursJson) {
    if (hoursJson == null) this.hours = [];
    try {
      this.hours =
          List<Hour>.from(hoursJson.map((e) => Hour.fromJson(jsonEncode(e))));
      _calculateAverage();
    } catch (e) {
      consoleLog("Error caught in setData ${e.stackTrace}");
      this.hours = [];
    }
    loaded = true;
    notifyListeners();
  }

  void _updateInMemory(Hour hour) {
    hours
        .singleWhere((element) => element==hour)
        .update(activity: hour.activity, note: hour.note, worth: hour.worth);
    AverageModel.clearCache();
  }

  void _calculateAverage() {
    Iterable<Hour> setHours = hours.where((element) => element.worth > 0);
    if (setHours.isNotEmpty) {
      average = sumOf<Hour>(setHours, (e) => (e.worth / 5)) / setHours.length;
    } else {
      average = 0.0;
    }
  }
}
