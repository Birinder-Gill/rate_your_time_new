import 'package:flutter/material.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class DetailedReport extends StatefulWidget {
  final AverageAppUsageModel appUsage;

  DetailedReport(this.appUsage);

  @override
  _DetailedReportState createState() => _DetailedReportState();
}

class _DetailedReportState extends State<DetailedReport> {
  String search='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          TextFormField(
            onChanged: (e){
             setState(() {
               search=e;
             });
            },
          ),
          for (final i in widget.appUsage.highApps) _tile(i),
          for (final i in widget.appUsage.otherApps) _tile(i),
        ],
      ),
    );
  }

  Widget _tile(UsageStat i) =>search.isEmpty||(i.appName).contains(search)? ListTile(
        horizontalTitleGap: 0,
        title: Text("${i.appName}"),
        subtitle:
            Text('${TimeUtils.convertMillsToTime(i.totalTimeInForeground)}'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.memory(i.appLogo),
        ),
      ):SizedBox.shrink();
}
