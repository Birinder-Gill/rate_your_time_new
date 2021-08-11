import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/providers/average_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class WeekModel extends AverageModel with ChangeNotifier {
  DateTime date;

  changeDate(DateTime date) {
    this.date = date;
    loadData();
  }
  String dateLabel = "";

  loadData() async {
    final to = await TimeUtils.getWeekEnd(date);
    final from = await TimeUtils.getWeekStart(date);
    this.dateLabel = "${from.day}/${from.month}-${to.day}/${to.month}${to.year}";
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
