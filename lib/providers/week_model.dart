import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/providers/average_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class WeekModel extends AverageModel with ChangeNotifier {
  final DateTime date;

  WeekModel({@required this.date}) {
    loadData();
  }

  loadData() async {
      final to = date;
      final from = (await TimeUtils.getWeekStart(date));

      await getHours(from,to);
    notifyListeners();
  }
}
