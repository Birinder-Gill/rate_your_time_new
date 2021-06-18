import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';

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
  static const String getHours = "getHours";
  static const String addAlarms = "addAlarms";
  static const String getAlarms = "getAlarms";
  static const String deleteAlarms = "deleteAlarms";
  static const String getInt = 'getInt';
  static const String setInt = 'setInt';
  static const String getRangeHours = 'getRangeHours';
  static const String updateHour = 'updateHour';


  static const String CHANNEL_NAME = 'name';

  static const String saveSettings='saveSettings';
}


double letterSpacingOrNone(double letterSpacing) => letterSpacing;

Widget adButton() =>OutlinedButton.icon(
    onPressed: () {
      // _openAd();
    },
    icon: Icon(Icons.font_download),
    label: Text("Watch an Ad"));

final DateTime launchDate = DateTime(2000);

void pushTo(BuildContext context, Widget screen,{bool replace=false,bool clear=false}) {
  if(clear){
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (c)=>screen), (route) => false);
    return;
  }
  if(replace){
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (c) => screen));
    return;
  }
  Navigator.push(context, CupertinoPageRoute(builder: (c) => screen));
}
void dialog(context,Widget screen)=>showDialog(context: context, builder: (c)=>screen);

Widget simpleLoader()=>Center(child: CircularProgressIndicator());

consoleLog(e){
  print("$e");
}

double sumOf<T>(Iterable<T> where, num Function(T e) fun) {
  double result=0.0;
  where.forEach((element) {
    result+=fun(element);
  });
  return result;
}

class TimeUtils{
  static String formatDate(DateTime date){
    return "${date.day}/${date.month}/${date.year}";
  }

  static String formatDateTime(DateTime date){
    return "${date.day}/${date.month}/${date.year} ${parseTimeHours(date.hour,minutes: date.minute)}";
  }

  static String parseTimeHours(int time,{int minutes=0}) {
    if(time>12) return "${time-12} pm";
    return "$time${minutes>0?":$minutes":''} am";
  }
  static String parseTimeRange(int time,{int minutes=0}) {
    final bef=time-1;

    if(time>12) return "${bef-12} - ${time-12} pm";
    return "$bef - $time${minutes>0?":$minutes":''} am";
  }


}

class Utils{
  static Future createAlarms() async {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    return channel.invokeMethod(Constants.addAlarms,{
      'wHour':await SharedPrefs.getInt(SharedPrefs.wakeUpHour),
      'sHour':await SharedPrefs.getInt(SharedPrefs.sleepHour)
    });
  }

  static deleteAlarms() {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    return channel.invokeMethod(Constants.deleteAlarms);
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