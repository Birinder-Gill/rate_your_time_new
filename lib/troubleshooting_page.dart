import 'package:flutter/material.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class TroubleshootScreen extends StatefulWidget {
  @override
  _TroubleshootScreenState createState() => _TroubleshootScreenState();
}

class _TroubleshootScreenState extends State<TroubleshootScreen> {
  final expes = [false, false];

  final _cardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(),
      body: ListView(
        children: [
          _section('Rating notification',
              subtitle:
                  "Rating notification doesn't show up on lock screen or float as a head",
              actions: [
                _action(
                  icon: Icons.notifications,
                  label: 'Allow lock screen notification',
                  onTap: Utils.openNotificationSettings,
                ),
              ]),
           _section("Usage limit problem",
              subtitle:
                  "If the system is killing your app in the background and the notification service stops, here's something you can do.",
          actions: [
            Divider(),
            _action(
              icon: Icons.refresh,
              label:
                  "If you're not getting a notification, restart the service here",

            ),
            Divider(),
            _action(icon: Icons.battery_charging_full_sharp,label: "Remove battery saver restrictions",onTap:  Utils.openAppSettingsScreen),
            Divider(),
            _action(icon: Icons.stop_circle_outlined,label: "Don't kill my app website",onTap:  Utils.openAppSettingsScreen)
          ]),
        ],
      ),
    );
  }

  Widget _section(String title,
      {String subtitle, List<Widget> actions = const []}) {
    final t = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: BeveledRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                title,
                style: t.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                    wordSpacing: 2,
                    letterSpacing: 1),
              ),
              subtitle: (subtitle != null) ?_subTitle(subtitle):null,
            ),
            ...actions
          ],
        ),
      ),
    );
  }

  Widget _subTitle(String s) {
    final t = Theme.of(context).textTheme;
    return Text(
      s,
      style: t.caption,
    );
  }

  get style => TextStyle(
        color: Theme.of(context).primaryColorDark,
        fontSize: 16,
      );

  Widget _action({IconData icon, VoidCallback onTap, String label}) => ListTile(
        leading: Icon(icon,color: Theme.of(context).primaryColorDark,),
        visualDensity: VisualDensity.compact,
        horizontalTitleGap: 0,
        onTap: onTap,
        trailing: Icon(Icons.navigate_next,),
        title: Text(
          '$label',
          style: style,
        ),
      );
}
