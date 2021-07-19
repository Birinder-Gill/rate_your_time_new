import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/models/average_data_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class MonthModel with ChangeNotifier {
  bool _loading = false;

  final DateTime date;
  AverageDataModel av;
  bool loaded = false;

  Map hd = {};

  MonthModel({@required this.date}) {
    getHours();
  }

  getHours() async {
    if (_loading) return;
    _loading = true;
    try {
      final body = {"date": date.day, 'month': date.month, 'year': date.year};
      consoleLog("Calling gethours with body $body");
      final channel = MethodChannel(Constants.CHANNEL_NAME);
      Map hourData = await channel.invokeMethod(Constants.getMonthData, body);
      this.hd=hourData;
      // return;
      this.av = await compute<Map,
          AverageDataModel>(Utils.parseAveragesData, hourData);
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
