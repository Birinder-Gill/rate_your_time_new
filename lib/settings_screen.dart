import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/select_time_screen.dart';
import 'package:rate_your_time_new/splash_screen.dart';
import 'package:rate_your_time_new/themes/select_theme_widget.dart';
import 'package:rate_your_time_new/troubleshooting_page.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';
import 'package:rate_your_time_new/welcome_info_screen.dart';

import 'alarms_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            expandedHeight: 220,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Settings",
                style: TextStyle(color: Colors.white),
              ),
              background: Image.network(
                'https://images.pexels.com/photos/1410119/pexels-photo-1410119.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFillRemaining(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               _themeSelector(),
                Divider(),
                _setting(icon:Icons.access_time_outlined,label:"Select time",onTap: () {
                  pushTo(context, SelectTimeScreen(firstTime: false,));
                }),
                if(false)
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
                if(false)ListTile(
                  onTap: () async {
                    await SharedPrefs.clear();
                    pushTo(context, SplashScreen(), clear: true);
                  },
                  title: Text("Clear data and restart"),
                ),
                if(false)ListTile(
                  onTap: () {
                    pushTo(context, SelectTimeScreen());
                  },
                  title: Text("Select time"),
                ),
                Divider(),
                _setting(label:'Troubleshoot',icon: Icons.support,onTap: (){
                  pushTo(context,TroubleshootScreen());
                }),
                Divider(),
                _setting(label:'Show app usage card',icon: Icons.bar_chart,onTap: (){
                  pushTo(context,TroubleshootScreen());
                },trailing: Switch.adaptive(value: true, onChanged: (e){})),
                Divider(),
                _setting(label:'Rating dialog',icon: Icons.star_border,onTap: (){
                  pushTo(context,TroubleshootScreen());
                },trailing: Switch.adaptive(value: false, onChanged: (e){})),

              ],
            ),
          )
        ],
      ),
    );
  }
  get style => TextStyle(color: Theme.of(context).primaryColorDark,fontSize: 16, fontWeight: FontWeight.bold);

  Widget _setting({IconData icon, String label, VoidCallback onTap,Widget trailing,Widget subtitle}) => ListTile(
    leading: Icon(icon),
    subtitle: subtitle,
    horizontalTitleGap: 0,
    onTap:onTap,
    trailing:trailing?? Icon(Icons.navigate_next),
    title: Text('$label',style: style,),
  );

  Widget _subtitle(String s) =>Container(
    color: Colors.white,
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(s,style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),),
        ),
      ],
    ),
  );

  Widget _themeSelector() =>Column(
    mainAxisSize:MainAxisSize.min,children: [
    _setting(
      icon: Icons.image,
      label: "Select theme",
    ),
    SelectThemeWidget(),
  ],);
}
