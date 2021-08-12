import 'package:flutter/foundation.dart';
import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/providers/average_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class MonthModel extends AverageModel with ChangeNotifier {
  DateTime date;

  AverageAppUsageModel appUsage;

  String dateLabel = "";

  changeDate(DateTime date) {
    this.date = date;
    _loadData();
  }

  _loadData({bool hours = true,bool apps=true}) async {
    final to = (await TimeUtils.getMonthEnd(date));
    final from = (await TimeUtils.getMonthStart(date));
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
    this.dateLabel = "${Constants.months[date.month-1]} ${date.year}";
    getHours(from, to).then((value) {
      notifyListeners();
    });
  }

  void refresh({bool hours = true,bool apps=true}) {
    _loadData(hours: hours,apps:apps);
  }
}
