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
    loadData();
  }

  loadData() async {
    final to = (await TimeUtils.getMonthEnd(date));
    final from = (await TimeUtils.getMonthStart(date));
    this.dateLabel = "${Constants.months[date.month-1]} ${date.year}";
    getHours(from, to).then((value) {
      notifyListeners();
    });
    loadAppUsages(from, to).then((value) {
      notifyListeners();
    });
    nextTick((){
      notifyListeners();
    });
  }
}
