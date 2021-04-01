import 'dart:async';
import 'dart:convert';

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

  var granted = false;

  var search = '';

  bool loading = false;

  List<UsageStat> distinctApps = [];

  double get sum => sumOf<UsageStat>(
      distinctApps, (e) => e.totalTimeInForeground);

  getApps() async {
    setState(() {
      loading = true;
    });
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    final List list = await channel.invokeMethod('getApps');
    apps = List<UsageStat>.from(
        list.map((e) => UsageStat.fromJson(jsonEncode(e))));
    distinctApps = [];
    apps.forEach((element) {
      int index = distinctApps.indexWhere((s) => s.package == element.package);
      if (index != -1)
        distinctApps[index].totalTimeInForeground =
            distinctApps[index].totalTimeInForeground +
                element.totalTimeInForeground;
      else
        distinctApps.add(element);
    });
    distinctApps
        .sort((a, b) => b.totalTimeInForeground - a.totalTimeInForeground);
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
    isAccessGranted();
    super.initState();
  }

  Future<void> isAccessGranted() async {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    granted = await channel.invokeMethod('isAccessGranted');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!granted)
            ElevatedButton(onPressed: openSettings, child: Text("Settings")),
            ElevatedButton(onPressed: loading?null:getApps, child:loading?simpleLoader(): Text("Get apps"))
        ],
      ),

      body: Scrollbar(
        child: ListView(
          children: [
            // loading?simpleLoader():Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //
            //     onChanged: (e){
            //       setState(() {
            //         search=e;
            //       });
            //     },
            //   ),
            // ),
            if (distinctApps.isNotEmpty)
              Container(
                height: 0,
                child: RallyPieChart(
                  heroLabel: "Total usage",
                  wholeAmount: sum,
                  heroAmount: timeInSecs(sum),
                  segments: distinctApps
                      .map(
                        (e) => RallyPieChartSegment(
                            color: e.color,
                            value: e.totalTimeInForeground.toDouble()),
                      )
                      .toList(),
                ),
              ),
            for (UsageStat i in distinctApps ?? [])
              if (i.package.contains(search) || i.appName.contains(search))
               Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   ListTile(
                            subtitle: Text(timeInSecs(i.totalTimeInForeground,),),
                            title: Text(i.appName,style: theme.headline6,),
                     trailing:SizedBox(
                       width: 100,
                       child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal:8.0),
                                child: LinearProgressIndicator(value:i.totalTimeInForeground/sum,minHeight: 14,),
                              ),
                     ),
                            leading:  Padding(
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
}
