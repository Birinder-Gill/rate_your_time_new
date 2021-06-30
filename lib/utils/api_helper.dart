import 'package:flutter/services.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class ApiHelper{

  static getWeekData(DateTime from,DateTime to)async{
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    final data = await channel.invokeMethod(Constants.getRangeHours);

  }

}