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
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
    double? cut,
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
  ShapeBorder lerpFrom(ShapeBorder? a, double? t) {
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
    assert(gapPercentage >= 0 && gapPercentage <= 1);

    final paint = borderSide.toPaint();
    final outer = borderRadius.toRRect(rect);
    if (gapExtent <= 0 || gapPercentage == 0) {
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

void nextTick(VoidCallback run) {
  Timer.run(run);
}

void toast(String msg) {
  final channel = MethodChannel(Constants.CHANNEL_NAME);
  channel.invokeMethod(Constants.toast);
}

bool _dialogShowing = false;

void showLoader(BuildContext context, {String label = "Loading..."}) {
  if (_dialogShowing) {
    return;
  }
  _dialogShowing = true;
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (c) => Center(
      child: SizedBox(
        height: 150,
        width: 200,
        child: Center(
          child: Material(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: simpleLoader(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("$label"),
              )
            ],
          )),
        ),
      ),
    ),
  ).then((value) {
    _dialogShowing = false;
  });
}

void hideLoader(BuildContext context) {
  if (_dialogShowing) {
    Navigator.pop(context);
    _dialogShowing = false;
  }
}

class Constants {
  static const String appName = "Rate your time";

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
  static const String openNotificationSettings = 'openNotificationSettings';
  static const String openSettings = 'openSettings';
  static const String openAppSettings = 'openAppSettings';
  static const String toast = 'toast';
  static const String isBatterySaverDisabled = 'isBatterySaverDisabled';

  static const String clearPrefs = 'clearPrefs';
  static const String loadGoal = 'loadGoal';
  static const String isTableEmpty = 'isTableEmpty';

  static const String CHANNEL_NAME = 'channel_name';

  static const String saveSettings = 'saveSettings';

  static const double datePickerHeight = 420;

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

Future<T> pushTo<T>(BuildContext context, Widget screen,
    {bool replace = false, bool clear = false, bool dialog = false}) {
  if (clear) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      CupertinoPageRoute(builder: (c) => screen, fullscreenDialog: dialog),
      (route) => false,
    );
  }
  if (replace) {
    return Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (c) => screen, fullscreenDialog: dialog),
    );
  }
  return Navigator.push<T>(context,
      CupertinoPageRoute(builder: (c) => screen, fullscreenDialog: dialog));
}

void dialog(context, Widget screen) =>
    showDialog(context: context, builder: (c) => screen);

Widget simpleLoader() => Center(child: CircularProgressIndicator());

consoleLog(e, {bool log = true}) {
  if (log) print("$e");
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

  static Future<DateTime> getWeekStart(DateTime? date) async {
    final to = date??DateTime.now();
    final from = to.subtract(Duration(days: to.weekday - 1));
    final installDate = await SharedPrefs.checkInstallDate();
    consoleLog('----------------------------');
    consoleLog(from);
    consoleLog(installDate);
    return from.isBefore(installDate) ? installDate : from;
  }

  static Future<DateTime> getWeekEnd(DateTime? date) async {
    final from = date??DateTime.now();
    final to = from.add(Duration(days: 7 - from.weekday));
    final now = DateTime.now();
    return to;
    consoleLog('----------------------------');
    consoleLog(from);
    return to.isBefore(now) ? to : now;
  }

  static Future<DateTime> getMonthEnd(DateTime? date) async {
    final from = date??DateTime.now();
    final to = DateTime(
        from.year, from.month, DateUtils.getDaysInMonth(from.year, from.month));
    final now = DateTime.now();
    consoleLog('----------------------------');
    consoleLog(from);
    return to.isBefore(now) ? to : now;
  }

  static Future<DateTime> getMonthStart(DateTime? date) async {
    final to = date??DateTime.now();
    //FIXME: Maybe we could remove initial dae check and make it synchronous;
    final from = DateTime.utc(to.year, to.month, 1);
    final installDate = await SharedPrefs.checkInstallDate();
    consoleLog('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    consoleLog(from);
    consoleLog(installDate);
    return from.isBefore(installDate) ? installDate : from;
  }

  static String makeLabelForTimestampRange(int min, int max) {
    final l = DefaultMaterialLocalizations();
    final from = DateTime.fromMillisecondsSinceEpoch(min);
    final to = DateTime.fromMillisecondsSinceEpoch(max);
    if (from.year == to.year) {
      return '${l.formatShortMonthDay(from)} - ${l.formatShortMonthDay(to)}';
    }
    return '${l.formatShortDate(from)}  - ${l.formatShortDate(to)}';
  }

  static Future<String> getTimeTillNextAlarm() async {
    String label(DateTime now, {int hrs}) {
      int result = 0;
      String unit = '';
      String trail = '';
      if (now.minute == 59) {
        result = 60 - now.second;
        unit = 'second';
      } else {
        result = 60 - now.minute;
        unit = 'minute';
      }
      if (result > 1) {
        trail = 's';
      }
      var prefix = '';
      if (hrs > 0) {
        prefix = '$hrs hr ';
      }
      return '$prefix $result $unit$trail';
    }

    final list = await Utils.getAllAlarms();
    final now = DateTime.now();
    bool captured = false;
    int firstHr;
    int lastHr;
    list.forEach((element) {
      final hr = int.parse(element['time'].toString().split(':').first);
      if (captured) {
        return label(now);
      }
      lastHr = hr;
      if (hr == now.hour) {
        captured = true;
      }
    });
    final tom = now.add(Duration(days: now.hour>lastHr?1:0));
    final newD = DateTime(tom.year, tom.month, tom.day, firstHr);
    int hrs = newD.difference(now).inHours;

    return label(now, hrs: hrs);
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

  static Future<bool> batterySaverDisabled() {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    return channel.invokeMethod<bool>(Constants.isBatterySaverDisabled);
  }

  static deleteAlarms() {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    return channel.invokeMethod(Constants.deleteAlarms);
  }

  static Future<List> getAllAlarms() {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    return channel.invokeMethod(Constants.getAlarms);
  }

  static AverageDataModel parseAveragesData(Map data) {
    final hourData = data['data'];
    final Map<String, List<Map<String, dynamic>>> hours =
        Map<String, List<Map<String, dynamic>>>.from(hourData.map(
            (key, value) => MapEntry(
                '$key',
                List<Map<String, dynamic>>.from(value.map((e) =>
                    Map<String, dynamic>.from(
                        e.map((k, v) => MapEntry("$k", v))))))));
    consoleLog(hours, log: true);
    AverageDataModel av = AverageDataModel();
    final tempActivityMap = {};
    final weekDayActivityMap = <int, Map<int, int>>{};

    ///Looping through every day data.
    hours.entries.forEach((element) {
      double total = 0.0;

      ///Looping through every hour of single day data
      element.value.forEach((e) {
        total += e['worth'];
        tempActivityMap[e['activity']] =
            (tempActivityMap[e['activity']] ?? 0) + 1;

        if (weekDayActivityMap[e['activity']] == null) {
          weekDayActivityMap[e['activity']] = {};
        }
        final ymd = element.key.split('-');
        final dt = DateTime(
            int.parse(ymd[0]), int.parse(ymd[1]) + 1, int.parse(ymd[2]));
        print("DATETIME DT =========>  $dt");
        var key = data['week'] == true ? dt.weekday : dt.day;
        weekDayActivityMap[e['activity']][key] =
            (1 + (weekDayActivityMap[e['activity']][key] ?? 0));
      });
      double filledSales = total / Utils.wokeHours();

      final keys = element.key.split('-');
      DateTime dt = DateTime(
        int.parse(keys[0]),

        ///ADDED ONE HERE BECAUSE MONTH RETURNED FROM JAVA SIDE IS ONE LESS THAN WHAT WE NEED HERE
        ///(because months in java start from 0 and in dart start from 1)
        int.parse(keys[1]) + 1,

        int.parse(keys[2]),
      );
      consoleLog(dt);
      if (!filledSales.isNaN) {
        double pendingSales = ((total / element.value.length) - filledSales);
        av.averages.add(SingleDayAverage(dt, filledSales,
            pendingSales: pendingSales.isNaN ? 0 : pendingSales));
        // filledRegion:((element.value.length/Utils.wokeHours())*5).toInt()
      }
    });

    consoleLog(
        "${tempActivityMap.map((key, value) => MapEntry("${activities[key]}", value))}");
    consoleLog("Day activity map = $weekDayActivityMap");
    av.averages.sort((a, b) =>
        a.date.millisecondsSinceEpoch - b.date.millisecondsSinceEpoch);
    final sorted = SplayTreeMap<int, int>.from(tempActivityMap,
        (b, a) => tempActivityMap[a].compareTo(tempActivityMap[b]));
    sorted.forEach((key, value) {
      Activity act = activities[key]?.copyWith(timeSpent: value);
      av.activities.add(act);
    });
    if (av.activities.length > ACTIVITIES_TO_SHOW) {
      final temp = List<Activity>.from(av.activities);
      consoleLog(temp.map((e) => e.timeSpent));
      av.activities = temp.take(ACTIVITIES_TO_SHOW).toList();
      av.others = temp.sublist(ACTIVITIES_TO_SHOW);
      av.activities.add(Activity(
          id: 16,
          name: "Others",
          icon: FontAwesomeIcons.list,
          timeSpent: temp.sublist(ACTIVITIES_TO_SHOW).fold(0,
              (previousValue, element) => previousValue + element.timeSpent)));
    }
    consoleLog(av, log: true);

    av.weekDayActivities = weekDayActivityMap.map((key, value) => MapEntry(
        key,
        SplayTreeMap<int, int>.from(value, (a, b) => a.compareTo(b))
            .map((key, value) => MapEntry(key, value))));

    return av;
  }

  static AverageAppUsageModel parseStatsData(List list) {
    ///Get actual time range interval
    int min=0, max=0;
    list.forEach((element) {
      final from = element['firstTimeStamp'];
      if (min > from) {
        min = from;
      }
      final to = element['LastTimeStamp'];
      if (max < to) {
        max = to;
      }
    });

    final result = AverageAppUsageModel();
    result.minTimeStamp = min;
    result.maxTimeStamp = max;
    result.label = TimeUtils.makeLabelForTimestampRange(min, max);
    var apps = List<UsageStat>.from(
      list.map(
        (e) => UsageStat.fromJson(jsonEncode(e)),
      ),
    );
    apps.sort((b, a) => (a.totalTimeInForeground??0) - (b.totalTimeInForeground??0));

    if (apps.length > APPS_TO_SHOW) {
      final temp = List<UsageStat>.from(apps);
      consoleLog(temp.map((e) => e.totalTimeInForeground));
      apps = temp.take(APPS_TO_SHOW).toList();
      final others = temp.sublist(APPS_TO_SHOW);
      result.highApps = apps;
      result.otherApps = others;
    } else {
      result.highApps = apps;
      result.otherApps = [];
    }
    return result;

    ///DO NOT DELETE
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
    channel.invokeMethod(Constants.openSettings);
  }

  static void openAppSettingsScreen() {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    channel.invokeMethod(Constants.openAppSettings);
  }

  static void openNotificationSettings() {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    channel.invokeMethod(Constants.openNotificationSettings);
  }

  ///The number of hours between wake up and sleep time.
  static int wokeHours() => 22 - 7;
}
