import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/home_screen.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class SelectTimeScreen extends StatefulWidget {
  @override
  _SelectTimeScreenState createState() => _SelectTimeScreenState();
}

class _SelectTimeScreenState extends State<SelectTimeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(onPressed: _savePrefs, label: Text('Next'),icon: Icon(Icons.arrow_forward),),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                Text("You wake up at:",style: theme.textTheme.headline4,),
                TextFormField(),
                Text("You go to sleep at:",style: theme.textTheme.headline4,),
                TextFormField(),

          ],
        ),
      ),
    );
  }

  Future<void> _savePrefs() async {
    //todo:uncomment in production
    // final body = {
    //   'wakeTime':0,
    //   'sleepTime':0
    // };
    // final channel = new MethodChannel(Constants.CHANNEL_NAME);
    // await channel.invokeMethod(Constants.saveSettings,body);
    pushTo(context, HomeScreen(),clear: true);
  }
}
