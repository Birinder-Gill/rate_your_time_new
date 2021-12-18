import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/providers/app_usage_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/test_screen.dart';
import 'package:rate_your_time_new/widgets/finance_entity.dart';
import 'package:rate_your_time_new/widgets/graphs/pie%20chart.dart';
import 'package:rate_your_time_new/widgets/pie_chart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AppsUsageScreen extends StatefulWidget {
  final DateTime from;
  final DateTime to;
  final List<UsageStat> distinctApps;

  const AppsUsageScreen({Key key, this.from, this.to, this.distinctApps})
      : super(key: key);

  @override
  _AppsUsageScreenState createState() => _AppsUsageScreenState();
}

class _AppsUsageScreenState extends State<AppsUsageScreen> {
  List<UsageStat> apps;

  var _granted;

  var search = '';

  bool loading = false;

  List<UsageStat> distinctApps = [];

  var error = false;

  DateTime to, from;

  double get sum =>
      sumOf<UsageStat>(distinctApps, (e) => e.totalTimeInForeground);

  get granted => (_granted != null && (_granted));

  Color get primaryDark => Theme.of(context).primaryColorDark;

  getApps({bool forceReload = true}) async {
    setState(() {
      loading = true;
    });
    try {
      if (widget.distinctApps == null || forceReload) {
        final model = AppUsageModel();
        await model.getApps(begin: from, end: to);
        distinctApps = model.distinctApps;
      } else
        setState(() {
          distinctApps = widget.distinctApps;
        });
    } catch (e) {
      error = true;
    }
    setState(() {
      loading = false;
    });
  }

  openSettings() {
    Utils.openUsageSettingsScreen();
  }

  @override
  void initState() {
    to = DateUtils.dateOnly(widget.to ?? DateTime.now());
    from = widget.from ?? to.subtract(Duration(days: 1));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isAccessGranted();
    });
    super.initState();
  }

  Future<void> isAccessGranted() async {
    _granted = await Utils.isUsageAccessGranted();
    if (_granted) {
      getApps(forceReload: false);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final theme = themeData.textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0),
            child: TextButton.icon(
              onPressed: pickFromDate,
              label: Text(
                "${_label(from)} - ${_label(to)}",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(
                    color:
                    themeData.accentColor),
              ),
              icon: Icon(Icons.edit,
                  size: 16,
                  color: themeData.accentColor),
            ),
          ),
        ],
      ),
      body: !granted
          ? gotoSettingsView()
          : loading
              ? simpleLoader()
              : error
                  ? _errorView()
                  : Scrollbar(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Material(
                              elevation: 12,
                              color: themeData.primaryColorDark,
                              // borderRadius:
                              //     BorderRadius.all(Radius.circular(12)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          "Total screen time",
                                          textAlign: TextAlign.center,
                                          style: theme.subtitle1.copyWith(
                                              color: themeData
                                                  .colorScheme.onSecondary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Divider(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        TimeUtils.convertMillsToTime(sum),
                                        textAlign: TextAlign.center,
                                        style: theme.headline3.copyWith(
                                            color: themeData
                                                .colorScheme.onSecondary),
                                      ),
                                      IconButton(
                                        iconSize: 36,
                                        icon: Icon(
                                          Icons.refresh,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onPressed: getApps,
                                        // mini: true,
                                        // backgroundColor:
                                        //     Theme.of(context).accentColor,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24,
                                  )
                                ],
                              ),
                            ),
                          ),
                          _categoryGraph(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text('Most used apps'),
                                for(final e in [0,1])
                                Row(
                                  children: [
                                    for(final i in [0,1])
                                    Expanded(
                                      child: Material(
                                        elevation: 4,
                                        child: ListTile(
                                            leading: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child:
                                                  Image.memory(distinctApps[int.parse('$e$i',radix: 2)].appLogo),
                                            ),
                                            title: Text(
                                              TimeUtils.convertMillsToTime(
                                                distinctApps[int.parse('$e$i',radix: 2)].totalTimeInForeground,
                                              ),
                                              style: theme.bodyText1.copyWith(
                                                  color: themeData.accentColor),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: 200,
                                child: DatumLegendWithMeasures.withSampleData()),
                          ),
                          Center(child: Text('All apps')),
                          for (UsageStat i in distinctApps ?? [])
                            if (i.package.contains(search) ||
                                i.appName.contains(search))
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: Card(
                                  // elevation: 2,
                                  child: ListTile(
                                    trailing: Text(
                                      TimeUtils.convertMillsToTime(
                                        i.totalTimeInForeground,
                                      ),
                                      style: theme.bodyText1.copyWith(
                                          color: themeData.accentColor),
                                    ),
                                    title: Text(
                                      "${i.appName}",
                                      style: theme.headline6,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: LinearProgressIndicator(
                                        value: i.totalTimeInForeground / sum,
                                        minHeight: 8,
                                        valueColor:
                                            AlwaysStoppedAnimation(primaryDark),
                                        backgroundColor:
                                            themeData.scaffoldBackgroundColor,
                                      ),
                                    ),
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.memory(i.appLogo),
                                    ),
                                    // horizontalTitleGap: 0,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
    );
  }

  gotoSettingsView() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Make tutorial on how to give access rights here",
            textAlign: TextAlign.center,
          ),
          ElevatedButton(onPressed: openSettings, child: Text("Settings"))
        ],
      ),
    ));
  }

  _errorView() => Center(child: Text("An error occurred"));

  String _label(DateTime date) => date == null
      ? "-/-"
      : MaterialLocalizations.of(context).formatShortMonthDay(date);

  void pickFromDate() {
    final theme = Theme.of(context);
    final c = Theme.of(context).colorScheme;
    showDateRangePicker(
            builder: (context, child) => Theme(
                data: theme.copyWith(
                    colorScheme: c.copyWith(
                        onSurface: c.secondaryVariant,
                        primary: c.primaryVariant,
                        brightness: Brightness.light,
                        onPrimary: c.onSecondary,
                        onSecondary: c.onPrimary)),
                child: child),
            context: context,
            initialDateRange: DateTimeRange(start: from, end: to),
            firstDate: DateTime(2018),
            lastDate: DateTime.now())
        .then((value) {
      if (value != null) {
        if (value.start != from || value.end != to) {
          from = value.start;
          to = value.end;
          getApps();
        }
      }
    });
  }

  _categoryGraph() {
    return SizedBox.shrink();
  }
}

class TestDeco extends Decoration {
  @override
  BoxPainter createBoxPainter([onChanged]) {
    return TestPainter();
  }
}

class TestPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    const strokeWidth = 4.0;
    final outerRadius = math.min(
          configuration.size.width,
          configuration.size.height,
        ) /
        2;
    final outerRect = Rect.fromCircle(
      center: configuration.size.center(offset),
      radius: outerRadius - strokeWidth * 3,
    );
    final innerRect = Rect.fromCircle(
      center: configuration.size.center(offset),
      radius: outerRadius - strokeWidth * 15,
    );

    // Paint each arc with spacing.
    var cumulativeSpace = 0.0;
    var cumulativeTotal = 0.0;
    var colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.grey,
      Colors.purple,
      Colors.brown
    ];
    double startAngle = 0;
    double sweepAngle = 1;
    for (final segment in [0, 1, 2, 3, 4, 5]) {
      final paint = Paint()..color = colors[segment];
      canvas.drawArc(outerRect, startAngle, sweepAngle, true, paint);
      startAngle += 1;
    }
    // final paint = Paint()..color = Colors.white;
    // canvas.drawCircle(outerRect.center, innerRect.height/2, paint);
  }
}
