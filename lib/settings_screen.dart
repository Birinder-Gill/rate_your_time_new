import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/about_screen.dart';
import 'package:rate_your_time_new/app_usage_tracker/usage_screen.dart';
import 'package:rate_your_time_new/select_time_screen.dart';
import 'package:rate_your_time_new/themes/select_theme_widget.dart';
import 'package:rate_your_time_new/troubleshooting_screen.dart';
import 'package:rate_your_time_new/utils/constants.dart';

import 'alarms_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String time = '';

  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      time = MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.now());
      setState(() {
        
      });
    });
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        time =
            MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.now());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          DrawerHeader(
              child: Container(
            child: Center(
              child: Text(
                time,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          )),
          ListTile(
            title: Text("Rate on Google play"),
          ),
          ListTile(
            onTap: () {
              dialog(
                context,
                AlertDialog(content: SelectThemeWidget()),
              );
            },
            title: Text("Select theme"),
          ),
          ListTile(
            onTap: () {
              pushTo(context, AppsUsageScreen());
            },
            title: Text("Track app usage (beta)"),
          ),
          ListTile(
            onTap: () {
              showCupertinoModalPopup(
                  context: context, builder: (c) => AboutScreen());
            },
            title: Text("About Rate your time"),
          ),
          ListTile(
            onTap: () {
              pushTo(context, TroubleShootingScreen());
            },
            title: Text("TroubleShoot"),
          ),
          ListTile(
            onTap: () {
              pushTo(context, SelectTimeScreen());
            },
            title: Text("Select time"),
          ),
          ListTile(
            onTap: () {
              pushTo(context, AlarmsScreen());
            },
            title: Text("See Alarms"),
          ),
          // ListTile(
          //   onTap: (){
          //     setState(() {
          //       Constants.testFlag = !Constants.testFlag;
          //     });
          //   },
          //   leading: Icon(Icons.bug_report_sharp,color: Constants.testFlag?Colors.green:Colors.grey,),
          //   title: Text("Debug mode"),
          //   trailing: CupertinoSwitch(value: Constants.testFlag, onChanged: (e){
          //     setState(() {
          //       Constants.testFlag = e;
          //     });
          //   }),
          // ),
        ],
      ),
    );
  }
}
