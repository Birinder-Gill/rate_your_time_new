import 'package:flutter/foundation.dart';
import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/models/average_data_model.dart';
import 'package:rate_your_time_new/utils/api_helper.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/graphs/grouped_bar_graph.dart';

class AverageModel{
  bool _loading = false;
  AverageDataModel av;
  bool loaded = false;
  bool isEmpty=false;
  AverageAppUsageModel appUsage;


  getHours(DateTime from,DateTime to) async {
    if (_loading) return;
    _loading = true;
    try {
      consoleLog("Get hours called with from = [$from] and to =[$to]");
      Map hourData = await ApiHelper.getRangeData(to,from);
      this.av = await compute<Map,
          AverageDataModel>(Utils.parseAveragesData, hourData);
      if(sumOf<SingleDayAverage>(this.av.averages, (a)=>a.worth)==0){
        isEmpty=true;
      }else{
        isEmpty=false;
      }
      this.appUsage = await ApiHelper.trackUsageData(from,to);
      loaded = true;
    } catch (e, trace) {
      consoleLog("Error Caught = $e,$trace");
    } finally {
      _loading = false;
    }
  }

}