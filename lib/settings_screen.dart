import 'package:flutter/material.dart';
import 'package:rate_your_time_new/select_time_screen.dart';
import 'package:rate_your_time_new/splash_screen.dart';
import 'package:rate_your_time_new/themes/select_theme_widget.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';
import 'package:rate_your_time_new/welcome_info_screen.dart';

import 'alarms_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final expes = [false, false];

  final _cardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              pushTo(context, WelcomeInfoScreen());
            },
            title: Text("Welcome"),
          ),
          ListTile(
            onTap: () {
              pushTo(context, AlarmsScreen());
            },
            title: Text("See Alarms"),
          ),
          ListTile(
            onTap: () async {
              await SharedPrefs.clear();
              pushTo(context, SplashScreen(), clear: true);
            },
            title: Text("Clear data and restart"),
          ),
          ListTile(
            onTap: () {
              pushTo(context, SelectTimeScreen());
            },
            title: Text("Select time"),
          ),
          ListTile(
            onTap: () {
              pushTo(
                context,
                SelectThemeWidget(),
              );
            },
            title: Text("Select theme"),
          ),
          ExpansionPanelList(
              elevation: 1,
              expansionCallback: (i, b) {
                setState(() {
                  this.expes[i] = !b;
                });
              },
              children: <ExpansionPanel>[
                ExpansionPanel(
                  backgroundColor: _cardColor,
                  canTapOnHeader: true,
                  isExpanded: expes[0],
                  headerBuilder: (c, b) => ListTile(
                    title: Text("Rating notification"),
                    isThreeLine: true,
                    subtitle: Text(
                        "Rating notification does'nt show up on lock screen or float as a head"),
                  ),
                  body: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: Utils.openNotificationSettings,
                        title: Text("Notification settings"),
                        subtitle: Text(
                            "Go here and allow notifications to be shown on lock screen"),
                      ),
                    ],
                  ),
                ),
                ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor: _cardColor,
                  isExpanded: expes[1],
                  headerBuilder: (c, b) => ListTile(
                    title: Text("Usage limit problem"),
                    isThreeLine: true,
                    subtitle: Text(
                        "If the system is killing your app in the background and the notification service stops, here's something you can do."),
                  ),
                  body: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text("Restart service"),
                        subtitle: Text(
                            "If the notification service has stopped, try and restart it here"),
                        trailing: ElevatedButton(
                            onPressed: () {}, child: Text("Restart service")),
                      ),
                      ListTile(
                        title: Text("Don't kill my app website"),
                      ),
                      ListTile(
                        onTap: Utils.openAppSettingsScreen,
                        title: Text("Apps system level settings"),
                        subtitle: Text(
                            "Go here and remove restrictions from battery saver"),
                      ),
                    ],
                  ),
                ),
              ])
        ],
      ),
    );
  }
}
