import 'package:flutter/material.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/usage_interval_info_dialog.dart';

import '../../utils/error_image.dart';

class AppUsageCard extends StatelessWidget {
  final AverageAppUsageModel appUsage;

  final bool accessGranted;

  final void Function() onRetry;

  final void Function(List<UsageStat> stats) openDetails;

  final String Function() date;

  AppUsageCard(this.appUsage, this.accessGranted,
      {required this.onRetry, required this.openDetails, required this.date});

  num get sum =>
      appUsage.highApps.fold(
          0,
          (previousValue, element) =>
              previousValue + (element.totalTimeInForeground??0)) +
      appUsage.otherApps.fold(
          0,
          (previousValue, element) =>
              previousValue + (element.totalTimeInForeground??0));

  @override
  Widget build(BuildContext context) {
    if (!accessGranted) {
      return _noAccessGranted(context);
    }
    if (appUsage.highApps.isEmpty)
      return Center(
          child: Column(
        children: [
          Text(
            "Could not get app usage stats for this time period."
            "\n If you're looking for app usage of single day, maybe go to App usage screen",
            textAlign: TextAlign.center,
          ),
          OutlinedButton(
              onPressed: () => openDetails([]),
              child: Text("GOTO APP USAGE SCREEN"))
        ],
      ));
    final themeData = Theme.of(context);
    final theme = themeData.textTheme;
    return Card(
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Text('Total time spent using phone.',
              textAlign: TextAlign.center,
              style: theme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeData.primaryColorDark)),
          GestureDetector(
            onTap: () {
              showIntervalInfoDialog(context,date());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('(${date()})',
                    textAlign: TextAlign.center,
                    style: theme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: themeData.primaryColorDark)),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: themeData.colorScheme.secondaryContainer,
                )
              ],
            ),
          ),
          Text(
            TimeUtils.convertMillsToTime(sum),
            textAlign: TextAlign.center,
            style: theme.headlineMedium,
          ),
          Text(
            'Most used apps',
            style: theme.titleLarge,
          ),
          for (final i in appUsage.highApps)
            ListTile(
              horizontalTitleGap: 0,
              title: Text("${i.appName}"),
              subtitle: Text(
                  '${TimeUtils.convertMillsToTime(i.totalTimeInForeground??0)}'),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(
                  i.appLogo!,
                  errorBuilder: (w, o, s) => ErrorImage(),
                ),
              ),
            ),
          ListTile(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.apps),
                ),
                Text("${appUsage.otherApps.length} other apps"),
              ],
            ),
            trailing: OutlinedButton.icon(
              onPressed: () {
                openDetails(
                  [...appUsage.highApps, ...appUsage.otherApps],
                );
              },
              icon: Text("Details"),
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
                Text('Total screen time',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "You need to give android's usage access permission to access this feature",
                    textAlign: TextAlign.center,
                  ),
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
