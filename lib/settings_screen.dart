
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/app_usage_tracker/usage_screen.dart';
import 'package:rate_your_time_new/select_time_screen.dart';
import 'package:rate_your_time_new/themes/select_theme_widget.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          children: [
            DrawerHeader(child: Container()),
            ListTile(
              title: Text("Rate on Google play"),
            ),
            ListTile(
              onTap: (){
                dialog(context,  AlertDialog(content: SelectThemeWidget()),);
              },
              title: Text("Select theme"),
            ),
            ListTile(
              onTap: (){
                pushTo(context, AppsUsageScreen());
              },
              title: Text("Track app usage (beta)"),
            ),
            ListTile(
              onTap: (){
                showAboutDialog(context: context,applicationIcon: Icon(Icons.font_download),applicationName: "Rate your time",applicationVersion: '1.0',children: [
                  Text('This is a demo description for the application')
                ]);
              },
              title: Text("Licences"),
            ),
            ListTile(
              onTap: (){
                pushTo(context, SelectTimeScreen());
              },
              title: Text("Select time"),
            ),

          ],
        ),
    );
  }
}
