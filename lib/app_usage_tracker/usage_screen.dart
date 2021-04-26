import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/finance_entity.dart';
import 'package:rate_your_time_new/widgets/pie_chart.dart';

class AppsUsageScreen extends StatefulWidget {
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

  double get sum => sumOf<UsageStat>(
      distinctApps.sublist(0, 4), (e) => e.totalTimeInForeground);

  get granted => (_granted != null && (_granted));

  getApps() async {
    setState(() {
      loading = true;
    });
    try {
      final channel = MethodChannel(Constants.CHANNEL_NAME);
      final List list = await channel.invokeMethod('getApps');
      apps = List<UsageStat>.from(
          list.map((e) => UsageStat.fromJson(jsonEncode(e))));
      distinctApps = [];
      apps.forEach((element) {
        int index =
            distinctApps.indexWhere((s) => s.package == element.package);
        if (index != -1)
          distinctApps[index].totalTimeInForeground =
              distinctApps[index].totalTimeInForeground +
                  element.totalTimeInForeground;
        else
          distinctApps.add(element);
      });
      distinctApps
          .sort((a, b) => b.totalTimeInForeground - a.totalTimeInForeground);
    } catch (e) {
      error = true;
    }
    setState(() {
      loading = false;
    });
  }

  openSettings() {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    channel.invokeMethod('openSettings');
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isAccessGranted();
    });
    super.initState();
  }

  Future<void> isAccessGranted() async {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    _granted = await channel.invokeMethod('isAccessGranted');
    if (_granted)
      getApps();
    else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        // title: Text("$_granted - $granted"),
        actions: [
          TextButton(
              onPressed: loading ? null : getApps,
              child: loading ? simpleLoader() : Text("Get apps"))
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
                          Text(
                            "Time spent on mobile",
                            textAlign: TextAlign.center,
                            style: theme.headline5,
                          ),
                          Text(
                            timeInSecs(sum),
                            textAlign: TextAlign.center,
                            style: theme.headline4,
                          ),
                          Text('in last 24 hrs', textAlign: TextAlign.center),
                          if (distinctApps.isNotEmpty)
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: RallyPieChart(
                                heroLabel: "",
                                wholeAmount: sum,
                                heroAmount: '',
                                segments: distinctApps
                                    .sublist(0, 4)
                                    .map(
                                      (e) => RallyPieChartSegment(
                                          color: e.color,
                                          value: e.totalTimeInForeground
                                              .toDouble()),
                                    )
                                    .toList(),
                              ),
                            ),
                          for (UsageStat i in distinctApps ?? [])
                            if (i.package.contains(search) ||
                                i.appName.contains(search))
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    subtitle: Text(
                                      timeInSecs(
                                        i.totalTimeInForeground,
                                      ),
                                    ),
                                    title: Text(
                                      i.appName,
                                      style: theme.headline6,
                                    ),
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: LinearProgressIndicator(
                                          value: i.totalTimeInForeground / sum,
                                          minHeight: 14,
                                          valueColor:
                                              AlwaysStoppedAnimation(i.color),
                                          backgroundColor: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.memory(i.appLogo),
                                    ),
                                    // horizontalTitleGap: 0,
                                  ),
                                  const Divider(
                                    height: 16,
                                    indent: 16,
                                    endIndent: 16,
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ),
    );
  }

  timeInSecs(num i) {
    final sec = 1000;
    final min = sec * 60;
    final hour = min * 60;
    final day = hour * 24;
    var mins = 0.0;
    var label = '';
    if (i >= day) {
      mins = i / day;
      label = 'Days';
    } else if (i >= hour) {
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

  _errorView() => Center(child: Text("An error occured"));
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
