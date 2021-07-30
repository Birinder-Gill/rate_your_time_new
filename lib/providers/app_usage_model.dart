import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/utils/api_helper.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class AppUsageModel with ChangeNotifier {
  List<UsageStat> distinctApps=[];

  bool error = false;
  bool loading = false;

  getApps() async {
    try {
      final today = DateUtils.dateOnly(DateTime.now());
      final yesterday = today.subtract(Duration(days: 1));
      var model = await ApiHelper.trackUsageData(yesterday,today);
      distinctApps.addAll(model.highApps);
      distinctApps.addAll(model.otherApps);
    } catch (e,trace) {
      consoleLog("$e $trace");
      error = true;
    }
  }
}
