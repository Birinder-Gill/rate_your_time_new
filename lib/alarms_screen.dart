import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class AlarmsScreen extends StatefulWidget {
  @override
  _AlarmsScreenState createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  List alarms;

  getAllAlarms() {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    channel.invokeMethod(Constants.getAlarms).then((value) {
      setState(() {
        this.alarms = value;
      });
    });
  }

  deleteAlarms() {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    channel.invokeMethod(Constants.deleteAlarms).then((value) {
      getAllAlarms();
    });
  }

  createAlarms() {
    final channel = MethodChannel(Constants.CHANNEL_NAME);
    channel.invokeMethod(Constants.addAlarms).then((value) {
      getAllAlarms();
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAllAlarms();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alarms"),
        actions: [
          IconButton(onPressed: deleteAlarms, icon: Icon(Icons.delete_forever)),
          IconButton(onPressed: getAllAlarms, icon: Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: createAlarms, child: Icon(Icons.alarm_add)),
      body: ListView(
        children: [
          for (var i in (alarms ?? []))
            ListTile(
              title: Text('${i['time']}'),
              subtitle: Text('${i['repeat']}'),
              trailing: i['enabled']==1?Icon(
                Icons.alarm_on,
                color: Colors.green,
              ):Icon(
                Icons.alarm_off,
              ),
            )
        ],
      ),
    );
  }
}
