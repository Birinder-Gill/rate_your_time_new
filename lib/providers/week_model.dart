import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/models/average_data_model.dart';
import 'package:rate_your_time_new/utils/api_helper.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/graphs/grouped_bar_graph.dart';

class WeekModel with ChangeNotifier {
  bool _loading = false;

  final DateTime date;
  AverageDataModel av;
  bool loaded = false;

  Map hd = {};

  bool isEmpty=false;

  AverageAppUsageModel appUsage;

  WeekModel({@required this.date}) {
    getHours();
  }

  getHours() async {
    if (_loading) return;
    _loading = true;
    try {
      final to = date;
      final from = (await TimeUtils.getWeekStart(date));
      Map hourData = await ApiHelper.getRangeData(to, from);

      this.hd=hourData; //used for debugging(can be removed in production)
      this.av = await compute<Map,
          AverageDataModel>(Utils.parseAveragesData, hourData);
      if(sumOf<SingleDayAverage>(this.av.averages, (a)=>a.worth)==0){
        isEmpty=true;
      }else{
        isEmpty=false;
      }
      this.appUsage = await ApiHelper.trackUsageData(from,to);

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
