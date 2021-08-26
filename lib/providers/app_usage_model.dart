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

  getApps({DateTime begin,DateTime end}) async {
    try {
      final to = DateUtils.dateOnly(begin??DateTime.now());
      final from = end??to.subtract(Duration(days: 1));
      var model = await ApiHelper.trackUsageData(from,to);
      distinctApps.addAll(model.highApps);
      distinctApps.addAll(model.otherApps);
    } catch (e,trace) {
      consoleLog("$e $trace");
      error = true;
    }
  }
}
