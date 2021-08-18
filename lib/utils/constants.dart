import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/data/activities.dart';
import 'package:rate_your_time_new/models/activity_model.dart';
import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/models/average_data_model.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';
import 'package:rate_your_time_new/widgets/graphs/grouped_bar_graph.dart';

class CutCornersBorder extends OutlineInputBorder {
  const CutCornersBorder({
    BorderSide borderSide = const BorderSide(),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(2)),
    this.cut = 7,
    double gapPadding = 2,
  }) : super(
          borderSide: borderSide,
          borderRadius: borderRadius,
          gapPadding: gapPadding,
        );

  @override
  CutCornersBorder copyWith({
    BorderSide borderSide,
    BorderRadius borderRadius,
    double gapPadding,
    double cut,
  }) {
    return CutCornersBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      gapPadding: gapPadding ?? this.gapPadding,
      cut: cut ?? this.cut,
    );
  }

  final double cut;

  @override
  ShapeBorder lerpFrom(ShapeBorder a, double t) {
    if (a is CutCornersBorder) {
      final outline = a;
      return CutCornersBorder(
        borderRadius: BorderRadius.lerp(outline.borderRadius, borderRadius, t),
        borderSide: BorderSide.lerp(outline.borderSide, borderSide, t),
        cut: cut,
        gapPadding: outline.gapPadding,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder lerpTo(ShapeBorder b, double t) {
    if (b is CutCornersBorder) {
      final outline = b;
      return CutCornersBorder(
        borderRadius: BorderRadius.lerp(borderRadius, outline.borderRadius, t),
        borderSide: BorderSide.lerp(borderSide, outline.borderSide, t),
        cut: cut,
        gapPadding: outline.gapPadding,
      );
    }
    return super.lerpTo(b, t);
  }

  Path _notchedCornerPath(Rect center, [double start = 0, double extent = 0]) {
    final path = Path();
    if (start > 0 || extent > 0) {
      path.relativeMoveTo(extent + start, center.top);
      _notchedSidesAndBottom(center, path);
      path..lineTo(center.left + cut, center.top)..lineTo(start, center.top);
    } else {
      path.moveTo(center.left + cut, center.top);
      _notchedSidesAndBottom(center, path);
      path.lineTo(center.left + cut, center.top);
    }
    return path;
  }

  Path _notchedSidesAndBottom(Rect center, Path path) {
    return path
      ..lineTo(center.right - cut, center.top)
      ..lineTo(center.right, center.top + cut)
      ..lineTo(center.right, center.top + center.height - cut)
      ..lineTo(center.right - cut, center.top + center.height)
      ..lineTo(center.left + cut, center.top + center.height)
      ..lineTo(center.left, center.top + center.height - cut)
      ..lineTo(center.left, center.top + cut);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double gapStart,
    double gapExtent = 0,
    double gapPercentage = 0,
    TextDirection textDirection,
  }) {
    assert(gapExtent != null);
    assert(gapPercentage >= 0 && gapPercentage <= 1);

    final paint = borderSide.toPaint();
    final outer = borderRadius.toRRect(rect);
    if (gapStart == null || gapExtent <= 0 || gapPercentage == 0) {
      canvas.drawPath(_notchedCornerPath(outer.middleRect), paint);
    } else {
      final extent = lerpDouble(0.0, gapExtent + gapPadding * 2, gapPercentage);
      switch (textDirection) {
        case TextDirection.rtl:
          {
            final path = _notchedCornerPath(
                outer.middleRect, gapStart + gapPadding - extent, extent);
            canvas.drawPath(path, paint);
            break;
          }
        case TextDirection.ltr:
          {
            final path = _notchedCornerPath(
                outer.middleRect, gapStart - gapPadding, extent);
            canvas.drawPath(path, paint);
            break;
          }
      }
    }
  }
}

void nextTick(void Function() run) {
  Timer.run(run);
}

class Constants {
  static const String getDayData = "getDayData";
  static const String addAlarms = "addAlarms";
  static const String getAlarms = "getAlarms";
  static const String deleteAlarms = "deleteAlarms";
  static const String getInt = 'getInt';
  static const String setInt = 'setInt';
  static const String getString = 'getString';
  static const String setString = 'setString';
  static const String getRangeHours = 'getRangeHours';
  static const String updateHour = 'updateHour';
  static const String getWeekData = 'getWeekData';
  static const String getMonthData = 'getMonthData';

  static const String CHANNEL_NAME = 'name';

  static const String saveSettings = 'saveSettings';

  static const double datePickerHeight =450;

  static final months = [
  'Jan',
  'Feb',
  'Mar',
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sept",
  "Oct",
  "Nov",
  "Dec"
  ];


}

double letterSpacingOrNone(double letterSpacing) => letterSpacing;

Widget adButton() => OutlinedButton.icon(
    onPressed: () {
      // _openAd();
    },
    icon: Icon(Icons.font_download),
    label: Text("Watch an Ad"));

void pushTo(BuildContext context, Widget screen,
    {bool replace = false, bool clear = false}) {
  if (clear) {
    Navigator.pushAndRemoveUntil(
        context, CupertinoPageRoute(builder: (c) => screen), (route) => false);
    return;
  }
  if (replace) {
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (c) => screen));
    return;
  }
  Navigator.push(context, CupertinoPageRoute(builder: (c) => screen));
}

void dialog(context, Widget screen) =>
    showDialog(context: context, builder: (c) => screen);

Widget simpleLoader() => Center(child: CircularProgressIndicator());

consoleLog(e, {bool log = true}) {
 if(log) print("$e");
}

double sumOf<T>(Iterable<T> where, num Function(T e) fun) {
  double result = 0.0;
  where.forEach((element) {
    result += fun(element);
  });
  return result;
}

class TimeUtils {
  ///RETURNS DATE IN dd/mm/yyyy
  static String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static String convertMillsToTime(num i) {
    final sec = 1000;
    final min = sec * 60;
    final hour = min * 60;
    final day = hour * 24;
    var mins = 0.0;
    var label = '';
    // if (i >= day) {
    //   mins = i / day;
    //   label = 'Days';
    // } else
    if (i >= hour) {
      mins = i / hour;
      label = 'Hours';
    } else if (i >= min) {
      mins = i / min;
      label = 'Minutes';
    } else if (i >= sec) {
      mins = i / sec;
      label = 'Seconds';
    } else {
      mins = i.toDouble();
      label = "ms";
    }

    return "${mins.toStringAsFixed(0)} $label";
  }

  ///RETURNS DATE IN dd/mm/yyyy hh:mm
  static String formatDateTime(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${parseTimeHours(date.hour, minutes: date.minute)}";
  }

  ///CONVERT 24 hrs INTO 12 hr(am pm) FORMAT
  static String parseTimeHours(int time, {int minutes = 0}) {
    if (time > 12) return "${time - 12} pm";
    return "$time${minutes > 0 ? ":$minutes" : ''} am";
  }

  ///TAKES AN HOUR AND RETURNS A STRING OF ONE HOUR RANGE i.e 18 becomes 5 - 6 pm
  static String parseTimeRange(int time, {int minutes = 0}) {
    final bef = time - 1;

    if (time > 12) return "${bef - 12} - ${time - 12} pm";
    return "$bef - $time${minutes > 0 ? ":$minutes" : ''} am";
  }

  static Future<DateTime> getWeekStart(DateTime to) async {
    final from = to.subtract(Duration(days: to.weekday - 1));
    final installDate = await SharedPrefs.checkInstallDate();
    consoleLog('----------------------------');
    consoleLog(from);
    consoleLog(installDate);
    return from.isBefore(installDate) ? installDate : from;
  }

  static Future<DateTime> getWeekEnd(DateTime from) async {
    final to = from.add(Duration(days: 7-from.weekday));
    final now = DateTime.now();
    consoleLog('----------------------------');
    consoleLog(from);
    return to.isBefore(now) ? to : now;
  }


  static Future<DateTime> getMonthEnd(DateTime from) async {

    final to = DateTime(from.year,from.month,DateUtils.getDaysInMonth(from.year, from.month));
    final now = DateTime.now();
    consoleLog('----------------------------');
    consoleLog(from);
    return to.isBefore(now) ? to : now;
  }



  static Future<DateTime> getMonthStart(DateTime to) async {
    final from = DateTime.utc(to.year, to.month, 1);
    final installDate = await SharedPrefs.checkInstallDate();
    consoleLog('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    consoleLog(from);
    consoleLog(installDate);
    return from.isBefore(installDate) ? installDate : from;
  }

}

class Utils {
  static var shortDays = {
    1: "Mon",
    2: "Tue",
    3: "Wed",
    4: "Thu",
    5: "Fri",
    6: "Sat",
    7: "Sun",
  };

  static const int ACTIVITIES_TO_SHOW = 5;
  static const int APPS_TO_SHOW = 3;

  static Future createAlarms() async {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    return channel.invokeMethod(Constants.addAlarms, {
      'wHour': await SharedPrefs.getInt(SharedPrefs.wakeUpHour),
      'sHour': await SharedPrefs.getInt(SharedPrefs.sleepHour)
    });
  }

  static deleteAlarms() {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    return channel.invokeMethod(Constants.deleteAlarms);
  }

  static AverageDataModel parseAveragesData(Map hourData) {
    final Map<String, List<Map<String, dynamic>>> hours =
        Map<String, List<Map<String, dynamic>>>.from(hourData.map(
            (key, value) => MapEntry(
                '$key',
                List<Map<String, dynamic>>.from(value.map((e) =>
                    Map<String, dynamic>.from(
                        e.map((k, v) => MapEntry("$k", v))))))));
    consoleLog(hours,log:true);
    AverageDataModel av = AverageDataModel();
    if (av.averages == null) av.averages = [];
    final tempActivityMap = {};
    hours.entries.forEach((element) {
      double total = 0.0;
      element.value.forEach((e) {
        total += e['worth'];
        tempActivityMap[e['activity']] =
            (tempActivityMap[e['activity']] ?? 0) + 1;
      });
      double sales = total / element.value.length;
      final keys = element.key.split('-');
      DateTime dt = DateTime(
        int.parse(keys[0]),

        ///ADDED ONE HERE BECAUSE MONTH RETURNED FROM JAVA SIDE IS ONE LESS THAN WHAT WE NEED HERE
        ///(because months in java start from 0 and in dart start from 1)
        int.parse(keys[1]) + 1,

        int.parse(keys[2]),
      );
      consoleLog(dt);
      av.averages.add(SingleDayAverage(dt, sales));
    });
    consoleLog("${tempActivityMap.map((key, value) => MapEntry("${activities[key]}",value))}");
    av.averages.sort((a, b) =>
        a.date.millisecondsSinceEpoch - b.date.millisecondsSinceEpoch);
    final sorted = SplayTreeMap<int, int>.from(tempActivityMap,
        (b, a) => tempActivityMap[a].compareTo(tempActivityMap[b]));
    sorted.forEach((key, value) {
      Activity act = activities[key]?.copyWith(timeSpent: value);
      if (act != null) av.activities.add(act);
    });
    if (av.activities.length > ACTIVITIES_TO_SHOW) {
      final temp = List<Activity>.from(av.activities);
      consoleLog(temp.map((e) => e.timeSpent));
      av.activities = temp.take(ACTIVITIES_TO_SHOW).toList();
      av.others = temp.sublist(ACTIVITIES_TO_SHOW);
      av.activities.add(Activity(
          id: 16,
          name: "Others",
          icon: FaIcon(FontAwesomeIcons.list),
          timeSpent: temp.sublist(ACTIVITIES_TO_SHOW).fold(0,
              (previousValue, element) => previousValue + element.timeSpent)));
    }
    consoleLog(av,log:true);

    return av;
  }

  static AverageAppUsageModel parseStatsData(List list){
    consoleLog("In parsestat data with list = $list");
    final result = AverageAppUsageModel();
    var apps = List<UsageStat>.from(
        list.map((e) => UsageStat.fromJson(jsonEncode(e))));
    apps.sort((b,a)=>a.totalTimeInForeground-b.totalTimeInForeground);

    if (apps.length > APPS_TO_SHOW) {
      final temp = List<UsageStat>.from(apps);
      consoleLog(temp.map((e) => e.totalTimeInForeground));
      apps = temp.take(APPS_TO_SHOW).toList();
      final others = temp.sublist(APPS_TO_SHOW);
      result.highApps = apps;
      result.otherApps = others;
    }else{
      result.highApps = apps;
      result.otherApps = [];
    }
    return result;
    // var distinctApps = <UsageStat>[];
    // apps.forEach((element) {
    //   int index =
    //   distinctApps.indexWhere((s) => s.package == element.package);
    //   if (index != -1)
    //     distinctApps[index].totalTimeInForeground =
    //         distinctApps[index].totalTimeInForeground +
    //             element.totalTimeInForeground;
    //   else
    //     distinctApps.add(element);
    // });
    // distinctApps
    //     .sort((a, b) => b.totalTimeInForeground - a.totalTimeInForeground);
    // return distinctApps;
  }

  static Future<bool> isUsageAccessGranted() async {
    consoleLog("Is Usage granted getting called");
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    return await channel.invokeMethod('isAccessGranted');
  }

  static void openUsageSettingsScreen() {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    channel.invokeMethod('openSettings');
  }
}

///OLD HOUR WIDGET
/**Card(
    color: hour.worth > 0 ? theme.cardColor : theme.scaffoldBackgroundColor,
    borderOnForeground: hour.worth == 0,
    elevation: hour.worth > 0 ? 1 : 0,
    child: Container(
    decoration: BoxDecoration(
    border: hour.worth > 0
    ? null
    : Border.all(color: theme.primaryColorDark),
    borderRadius: BorderRadius.all(Radius.circular(4))),
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    const SizedBox(
    height: 4,
    ),
    SizedBox(
    width: 50,
    child: Text(
    '${TimeUtils.parseTimeHours(hour.time)}',
    style: TextStyle(
    color: theme.textTheme.bodyText2.color
    .withOpacity(hour.worth > 0 ? 1 : .5)),
    )),
    const SizedBox(
    height: 42,
    ),
    Expanded(
    child: (hour.worth > 0)
    ? LinearProgressIndicator(
    minHeight: 4,
    valueColor: AlwaysStoppedAnimation<Color>(
    Theme.of(context).accentColor),
    backgroundColor: Theme.of(context).primaryColorDark,
    value: (hour.worth / 5),
    )
    : _emptyWorthCard(theme),
    ),
    const SizedBox(
    height: 4,
    ),
    // Text("${hour.date}/${hour.month}/${hour.year}"),
    // const SizedBox(height: 4,),
    ],
    ),
    ),
    ),
    ),**/
