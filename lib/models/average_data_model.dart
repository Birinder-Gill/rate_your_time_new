import 'dart:collection';

import 'package:rate_your_time_new/models/activity_model.dart';
import 'package:rate_your_time_new/widgets/graphs/grouped_bar_graph.dart';

class AverageDataModel{
  List<SingleDayAverage> averages=[];
  List<Activity> activities= [];

  List<Activity> others=[];

  @override
  String toString() {
    return averages.map((e) => "${e.date.toIso8601String().substring(0,10)} -> ${e.worth}").toString();
  }
}