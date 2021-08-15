import 'package:flutter/foundation.dart';
import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/models/average_data_model.dart';
import 'package:rate_your_time_new/utils/api_helper.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/data_cache.dart';

class AverageModel {
  bool _loading = false;
  AverageDataModel av;
  bool loaded = false;
  bool isEmpty = false;
  AverageAppUsageModel appUsage;

  DataCache cache = DataCache();

  bool accessGranted=true;

  bool _appsLoading=false;

  Future getHours(DateTime from, DateTime to) async {
    if (_loading) return;
    _loading = true;
    try {
      loaded=false;
      consoleLog("Get hours called with from = [$from] and to =[$to]");
      this.av = cache.getAverageData(to, from);
      if (this.av == null) {
        Map hourData = await ApiHelper.getRangeData(to, from);
        this.av = await compute<Map, AverageDataModel>(
            Utils.parseAveragesData, hourData);
        cache.addAverageCache(to, from, this.av);
      }
      isEmpty = true;
      this.av.averages.forEach((element) {
        if (!element.worth.isNaN) isEmpty = false;
        return;
      });
      loaded = true;
    } catch (e, trace) {
      consoleLog("Error Caught = $e,$trace");
    } finally {
      _loading = false;
    }
  }

  Future loadAppUsages(DateTime from, DateTime to) async {
    if(_appsLoading)return;
    _appsLoading=true;

    this.accessGranted=true;
    this.appUsage = (cache.getAppsData(to, from));
    if(this.appUsage==null) {
      this.accessGranted = await Utils.isUsageAccessGranted();
      this.appUsage = (await ApiHelper.trackUsageData(from, to));
      if(this.appUsage.highApps.isNotEmpty)
      cache.addAppDataCache(to, from, this.appUsage);
    }
    _appsLoading=false;
  }
}
