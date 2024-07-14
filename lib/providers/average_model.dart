import 'package:flutter/material.dart';
import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/models/average_data_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/data_cache.dart';

class AverageModel {
  bool _loading = false;
  AverageDataModel av = AverageDataModel();
  double rating=0;

  bool loaded = false;
  bool isEmpty = false;
  AverageAppUsageModel appUsage = AverageAppUsageModel();

  static DataCache cache = DataCache();

  bool accessGranted=true;

  bool _appsLoading=false;

  Future getHours(DateTime from, DateTime to,{bool week = true}) async {
    if (_loading) return;
    _loading = true;
    try {
      loaded=false;
      rating=0;
      consoleLog("Get hours called with from = [$from] and to =[$to]");
      this.av = cache.getAverageData(to, from);
      isEmpty = av.averages.isEmpty|| (av.averages.fold(0, (previousValue, element) => previousValue+element.worth.toInt())==0);

      if(!isEmpty){
        rating=av.averages.fold<double>(0.0, (previousValue, element) => previousValue+element.worth)/5;
      }
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
    if(to.isAfter(DateTime.now())){
      to = DateUtils.dateOnly(DateTime.now());
    }
    if(DateUtils.isSameDay(from, to) || from.isAfter(to)){
      from = to.subtract(Duration(days: 1));
    }
    this.appUsage = (cache.getAppsData(to, from));
    _appsLoading=false;
  }

  static void clearCache() {
    cache.clear();
  }
}
