import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class TroubleShootingScreen extends StatefulWidget {
  @override
  _TroubleShootingScreenState createState() => _TroubleShootingScreenState();
}

class _TroubleShootingScreenState extends State<TroubleShootingScreen> {
  final exps = [false,false];

  final _cardColor=Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cardColor,
      appBar: AppBar(
        title: Text("Troubleshoot"),
        backgroundColor: Colors.white,
      ),
      body:ListView(
        children: [
          ExpansionPanelList(
            elevation: 0,
              expansionCallback: (i,b){
                print("$i,$b");
                setState(() {
                  this.exps[i]=!b;
                });
              },
              children: <ExpansionPanel>[
            ExpansionPanel(
              backgroundColor: _cardColor,
              canTapOnHeader: true,
              isExpanded: exps[0],
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
              isExpanded:exps[1],
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
