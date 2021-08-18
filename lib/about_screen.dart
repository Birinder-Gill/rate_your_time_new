import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String about = 'Proven method to manage time and make most of your day\n\n'
  'Simple technique proved to make day more productive,\n\n'
      'All we need is a trick\n\n'

  'Summary:\n\n'
  'STEP 1 (5 Minutes) Set Plan for Day. Sit down and decide what will make this day highly successful.\n\n'

  'STEP 2 (1 minute every hour) Refocus. When the app rings, take a deep breath, look at your list and ask yourself if you spent your last hour productively and rate your hour on scale of 1 to 5.Then look at your calendar and deliberately recommit to how you are going to use the next hour. Manage your day hour by hour.\n\n'

  'At the end of the day, review your day. What worked? Where did you focus? Where did you get distracted? What did you learn that will help you be more productive tomorrow?';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Rate your time")),
      body: ListView(
        children: [
          Text(about),
          OutlinedButton(onPressed: (){
            showAboutDialog(context: context,applicationIcon: Icon(Icons.font_download),applicationName: "Rate your time",applicationVersion: '1.0',children: [
              Text('This is a demo description for the application')
            ]);
          }, child: Text("Licences"))
        ],
      ),
    );
  }
}
