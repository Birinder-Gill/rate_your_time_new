import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class AppUsageModel with ChangeNotifier {
  List<UsageStat> distinctApps=[];

  bool error = false;
  bool loading = false;

  getApps() async {
    try {
      final channel = MethodChannel(Constants.CHANNEL_NAME);
      final List list = await channel.invokeMethod('getApps');
      distinctApps =
          await compute<List, List<UsageStat>>(Utils.parseStatsData, list);
      consoleLog("Model length = ${distinctApps.length}");
    } catch (e) {
      error = true;
    }
  }
}
