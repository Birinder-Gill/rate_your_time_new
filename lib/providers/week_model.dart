import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/models/average_data_model.dart';
import 'package:rate_your_time_new/utils/api_helper.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class WeekModel with ChangeNotifier {
  bool _loading = false;

  final DateTime date;
  AverageDataModel av;
  bool loaded = false;

  Map hd = {};

  WeekModel({@required this.date}) {
    getHours();
  }

  getHours() async {
    if (_loading) return;
    _loading = true;
    try {
      Map hourData = await ApiHelper.getRangeData(date, (await TimeUtils.getWeekStart(date)));
      this.hd=hourData; //used for debugging(can be removed in production)
      this.av = await compute<Map,
          AverageDataModel>(Utils.parseAveragesData, hourData);
      consoleLog("Hours returned = $av");
      loaded = true;
    } catch (e, trace) {
      consoleLog("Error Caught = $e,$trace");
    } finally {
      _loading = false;
    }
    notifyListeners();
  }
}
