import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/about_screen.dart';
import 'package:rate_your_time_new/app_usage_tracker/usage_screen.dart';
import 'package:rate_your_time_new/settings_screen.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          DrawerHeader(
            child: Container(
              child: Center(
                  child: DigitalClock(
                is24HourTimeFormat: false,
                showSecondsDigit: true,
                areaDecoration: BoxDecoration(),
                areaAligment: AlignmentDirectional.center,
                hourDigitDecoration: BoxDecoration(),
                minuteDigitDecoration: BoxDecoration(),
                secondDigitDecoration: BoxDecoration(),
                digitAnimationStyle: Curves.decelerate,
                hourMinuteDigitTextStyle: Theme.of(context).textTheme.displaySmall,
                secondDigitTextStyle: Theme.of(context).textTheme.bodySmall,
                amPmDigitTextStyle: Theme.of(context).textTheme.titleLarge,
              )),
            ),
          ),
          ListTile(
            leading: Icon(Icons.android_outlined),
            onTap: () {
              pushTo(context, AppsUsageScreen());
            },
            title: Text("See app usage"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            onTap: () {
              pushTo(context, SettingsScreen());
            },
            title: Text("Settings"),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            onTap: () {
              showCupertinoModalPopup(
                  context: context, builder: (c) => AboutScreen());
            },
            title: Text("About"),
          ),
        ],
      ),
    );
  }
}
