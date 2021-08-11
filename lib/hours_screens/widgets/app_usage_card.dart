import 'package:flutter/material.dart';
import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class AppUSageCard extends StatelessWidget {
  final AverageAppUsageModel  appUsage;

  AppUSageCard(this.appUsage);

  @override
  Widget build(BuildContext context) {
    if(appUsage==null)
      return simpleLoader();
    if(appUsage.highApps?.isEmpty??true)
      return Center(child: Text("No app usage found for this time period"));
    return Card(
      child: Column(
        children: [
          Text('Most used app this week: '),
          for(final i in appUsage.highApps)
          ListTile(
            horizontalTitleGap: 0,
            title: Text("${i.appName}"),
            subtitle: Text('${TimeUtils.convertMillsToTime(i.totalTimeInForeground)}'),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.memory(i.appLogo),
            ),
          ),
        ],
      ),
    );
  }
}
