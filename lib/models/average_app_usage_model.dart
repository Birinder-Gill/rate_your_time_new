import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';

class AverageAppUsageModel{
  List<UsageStat> highApps=[];
  List<UsageStat> otherApps=[];
  int? minTimeStamp;
  int? maxTimeStamp;
  String label = '';
}