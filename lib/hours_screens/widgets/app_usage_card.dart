import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/app_usage_tracker/detailed_report.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/app_usage_tracker/usage_screen.dart';
import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class AppUsageCard extends StatelessWidget {
  final AverageAppUsageModel appUsage;

  final bool accessGranted;

  final void Function() onRetry;

  final void Function(List<UsageStat> stats) openDetails;

  AppUsageCard(this.appUsage, this.accessGranted, {@required this.onRetry,this.openDetails});

  @override
  Widget build(BuildContext context) {
    if (!accessGranted) {
      return _noAccessGranted(context);
    }
    if (appUsage == null) return simpleLoader();
    if (appUsage.highApps?.isEmpty ?? true)
      return Center(
          child: Text(
        "Could not get app usage stats for this time period."
        "\n If you're looking for app usage of single day, maybe go to App usage screen",
        textAlign: TextAlign.center,
      ));
    return Card(
      child: Column(
        children: [
          Text('Time spent on mobile this week: '),
          for (final i in appUsage.highApps)
            ListTile(
              horizontalTitleGap: 0,
              title: Text("${i.appName}"),
              subtitle: Text(
                  '${TimeUtils.convertMillsToTime(i.totalTimeInForeground)}'),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(
                  i.appLogo,
                  errorBuilder: (w, o, s) => Image.network(
                      'https://freepikpsd.com/media/2019/10/android-app-icon-png-Free-PNG-Images-Transparent.png'),
                ),
              ),
            ),
          ListTile(
            leading: Icon(Icons.apps),
            title: Text("${appUsage.otherApps.length} other apps"),
            trailing: OutlinedButton.icon(
              onPressed: () {
                openDetails([...appUsage.highApps,...appUsage.otherApps],);
              },
              icon: Text("Detailed report"),
              label: Icon(Icons.arrow_right),
            ),
          )
        ],
      ),
    );
  }

  Widget _noAccessGranted(BuildContext context) => Center(
        child: Material(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "No access granted\nA small description about why and how to give usage access",
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                    onPressed: openSettings, child: Text("Open settings")),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: Text("Retry"),
                  label: Icon(Icons.replay),
                ),
              ],
            ),
          ),
        ),
      );

  void openSettings() {
    Utils.openUsageSettingsScreen();
  }
}
