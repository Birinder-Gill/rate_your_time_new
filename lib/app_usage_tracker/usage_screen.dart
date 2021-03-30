import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/pie_chart.dart';

class AppsUsageScreen extends StatefulWidget {
  @override
  _AppsUsageScreenState createState() => _AppsUsageScreenState();
}

class _AppsUsageScreenState extends State<AppsUsageScreen> {
  List<UsageStat> apps;

  var granted = false;

  var search='';

  bool loading=false;

  List<UsageStat> distinctApps=[];

  get sum => sumOf<UsageStat>(distinctApps.sublist(0,4), (e)=>e.totalTimeInForeground);



  getApps() async {
    setState(() {
      loading=true;
    });
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    final List list = await channel.invokeMethod('getApps');
    apps=List<UsageStat>.from(list.map((e)=>UsageStat.fromJson(jsonEncode(e))));
    distinctApps=[];
    apps.forEach((element) {
      int index = distinctApps.indexWhere((s) => s.package==element.package);
      if(index!=-1)
        distinctApps[index].totalTimeInForeground =distinctApps[index].totalTimeInForeground+ element.totalTimeInForeground;
      else
        distinctApps.add(element);


    });
    distinctApps.sort((a,b)=>b.totalTimeInForeground-a.totalTimeInForeground);
    setState(() {
      loading=false;
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
    return Scaffold(
      appBar: AppBar(
        actions: [
         if(!granted) ElevatedButton(onPressed: openSettings, child: Text("Settings"))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:loading?null: () {
          // Timer.periodic(Duration(seconds: 1), (timer) {
          getApps();
          // });
        },
        child: Icon(Icons.refresh),
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
           if(distinctApps.isNotEmpty) Container(
              height: 300,
              child: RallyPieChart(heroLabel:"Usage",wholeAmount: sum,heroAmount: sum,segments:distinctApps.map((e) => RallyPieChartSegment(color: e.color,value: e.totalTimeInForeground.toDouble()),).toList(),),
            ),
            for (UsageStat i in distinctApps ?? [])
              if(i.package.contains(search)||i.appName.contains(search))ExpansionTile(
                leading: Icon(Icons.circle,color: i.color,),
                title: Text(
                  i.appName??'',
                ),
                subtitle: Text("${timeInSecs(i.totalTimeInForeground)}" ?? ''),
                children: [
                  ListTile(
                    title: Text("firstTimeStamp"),
                    subtitle: Text("${TimeUtils.formatDateTime(DateTime.fromMillisecondsSinceEpoch(i.firstTimeStamp))}" ?? ''),
                  ),
                  ListTile(
                    title: Text("LastTimeStamp"),
                    subtitle: Text("${TimeUtils.formatDateTime(DateTime.fromMillisecondsSinceEpoch(i.lastTimeStamp))}" ?? ''),
                  ),
                  ListTile(
                    title: Text("LastTimeUsed"),
                    subtitle: Text("${TimeUtils.formatDateTime(DateTime.fromMillisecondsSinceEpoch(i.lastTimeUsed))}" ?? ''),
                  ),
                  ListTile(
                    title: Text("TotalTimeInForeground"),
                    subtitle: Text("${timeInSecs(i.totalTimeInForeground)}" ?? ''),
                  ),
                  ListTile(
                    title: Text("TotalTimeVisible"),
                    subtitle: Text("${timeInSecs(i.totalTimeVisible)}" ?? ''),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  timeInSecs(int i) {
    final sec = 1000;
    final min= sec*60;
    final hour = min*60;
    final day = hour*24;
    var mins = 0.0;
    var label='';
    if(i>=day) {
      mins = i / day;
      label='Days';
    } else if (i>=hour) {
      mins = i / hour;
      label='Hours';
    } else if (i>=min) {
      mins = i / min;
      label='Minutes';
    } else if (i>=sec) {
      mins = i / sec;
      label='Seconds';
    }else{
      mins=i.toDouble();
      label="ms";
    }


    return "${mins.toStringAsFixed(0)} $label";
  }
}
