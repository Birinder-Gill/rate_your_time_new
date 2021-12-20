import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/utils/api_helper.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class AppUsageModel with ChangeNotifier {
  List<UsageStat> distinctApps = [];
  final catMap = <int,int>{};
  String label = '';
  bool error = false;
  bool loading = false;

  getApps({DateTime begin, DateTime end}) async {
    try {
      if (begin == null || end == null) return;
      var model = await ApiHelper.trackUsageData(begin, end);
      distinctApps.clear();
      distinctApps.addAll(model.highApps);
      distinctApps.addAll(model.otherApps);
      catMap.clear();
      catMap.addAll(makeCatMap(distinctApps));
      label = model.label;

    } catch (e, trace) {
      consoleLog("$e $trace");
      error = true;
    }
  }

  static Map<int,int> makeCatMap(List<UsageStat> distinctApps) {
    final catMap = <int,int>{};
    distinctApps.forEach((a) {
      catMap[a.category] = (catMap[a.category] ?? 0) + 1;
    });
    return catMap;
  }
}
