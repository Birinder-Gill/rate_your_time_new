import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/providers/average_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class WeekModel extends AverageModel with ChangeNotifier {
  DateTime date;
  changeDate(DateTime date) {
    this.date = date;
    _loadData();
  }
  String dateLabel = "";

  _loadData({bool hours = true,bool apps=true}) async {
    consoleLog("LOAD DATA IN WEEK MODEL DATE = $date");
    final to = await TimeUtils.getWeekEnd(date);
    final from = await TimeUtils.getWeekStart(date);
    if(hours)
    _loadHours(from,to);
    if(apps)
    _loadApps(from,to);
    nextTick((){
      notifyListeners();
    });
  }
  void _loadApps(DateTime from, DateTime to){
    loadAppUsages(from, to).then((value) {
      notifyListeners();
    });
  }

  void _loadHours(DateTime from, DateTime to) {
    this.dateLabel = "${from.day}/${from.month}-${to.day}/${to.month}${to.year}";
    this.dateLabel = "${Constants.months[date.month-1]} ${date.year}";
    getHours(from, to).then((value) {
      notifyListeners();
    });
  }
  void refresh({bool hours = true,bool apps=true}) {
    _loadData(hours: hours,apps:apps);
  }
}
