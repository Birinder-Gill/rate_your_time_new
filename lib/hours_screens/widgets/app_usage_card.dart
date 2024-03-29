import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/models/average_app_usage_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/usage_interval_info_dialog.dart';

class AppUsageCard extends StatelessWidget {
  final AverageAppUsageModel appUsage;

  final bool accessGranted;

  final void Function() onRetry;

  final void Function(List<UsageStat> stats) openDetails;

  final String Function() date;

  AppUsageCard(this.appUsage, this.accessGranted,
      {@required this.onRetry, this.openDetails, @required this.date});

  num get sum =>
      appUsage.highApps.fold(
          0,
          (previousValue, element) =>
              previousValue + element.totalTimeInForeground) +
      appUsage.otherApps.fold(
          0,
          (previousValue, element) =>
              previousValue + element.totalTimeInForeground);

  @override
  Widget build(BuildContext context) {
    if (!accessGranted) {
      return _noAccessGranted(context);
    }
    if (appUsage == null) return simpleLoader();
    if (appUsage.highApps?.isEmpty ?? true)
      return Center(
          child: Column(
        children: [
          Text(
            "Could not get app usage stats for this time period."
            "\n If you're looking for app usage of single day, maybe go to App usage screen",
            textAlign: TextAlign.center,
          ),
          OutlinedButton(
              onPressed: () => openDetails(null),
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
              style: theme.subtitle1.copyWith(
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
                    style: theme.subtitle1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: themeData.primaryColorDark)),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: themeData.colorScheme.secondaryVariant,
                )
              ],
            ),
          ),
          Text(
            TimeUtils.convertMillsToTime(sum),
            textAlign: TextAlign.center,
            style: theme.headline4,
          ),
          Text(
            'Most used apps',
            style: theme.headline6,
          ),
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
                Text('Total screen time',style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),),
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
