import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class ApiHelper{

  ///SUBTRACT 1 FROM MONTH BECAUSE MONTHS START FROM 0 IN JAVA AND 1 N DART
  static Future<Map> getRangeData(DateTime to,DateTime from)async{
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    final body = {
      'd1':from.day,
      'm1':from.month-1,
      'y1':from.year,
      'd2':to.day,
      'm2':to.month-1,
      'y2':to.year
    };
    consoleLog("MONTH BODY + $body");
    final data = await channel.invokeMethod<Map>(Constants.getRangeHours,body);
    return data;
  }


  ///SUBTRACT 1 FROM MONTH BECAUSE MONTHS START FROM 0 IN JAVA AND 1 N DART
  static Future<List> getData(DateTime date)async{
    final body = {
      "date": date.day,
      'month': date.month-1,
      'year': date.year
    };
    consoleLog("Calling gethours with body $body");
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    final hours = await channel.invokeMethod(Constants.getDayData, body);
    return hours;
  }

  static Future<AverageAppUsageModel> trackUsageData(DateTime from,DateTime to) async {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    final body = {
      'd1':from.day,
      'm1':from.month-1,
      'y1':from.year,
      'd2':to.day,
      'm2':to.month-1,
      'y2':to.year
    };
    consoleLog("Body = $body");
    final List list = await channel.invokeMethod('getApps',body);
    return await compute<List, AverageAppUsageModel>(Utils.parseStatsData, list);
  }



}