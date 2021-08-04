import 'package:flutter/foundation.dart';
import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/providers/average_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class MonthModel extends AverageModel with ChangeNotifier {
  final DateTime date;

  AverageAppUsageModel appUsage;

  MonthModel({@required this.date}) {
    loadData();
  }

  loadData() async {
    final to = (await TimeUtils.getMonthEnd(date));
    final from = (await TimeUtils.getMonthStart(date));
    await getHours(from,to);
    notifyListeners();
  }

}
