import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rate_your_time_new/home_screen.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';
import 'package:rate_your_time_new/widgets/circular_range_picker/double_circular_slider.dart';

class SelectTimeScreen extends StatefulWidget {
  final bool firstTime;

  const SelectTimeScreen({Key? key, this.firstTime = true}) : super(key: key);

  @override
  _SelectTimeScreenState createState() => _SelectTimeScreenState();
}

class _SelectTimeScreenState extends State<SelectTimeScreen> {
  Color get baseColor => Theme.of(context).primaryColorDark;

  int _wakeUpDefault = 7;
  int _sleepDefault = 22;

  late int wakeUpTime;
  late int sleepTime;

  double get _size => 350.0;
  final _formKey = GlobalKey<FormState>();


  void _getTime() async {
    wakeUpTime = await SharedPrefs.getInt(SharedPrefs.wakeUpHour,
        defaultValue: _wakeUpDefault);
    sleepTime = await SharedPrefs.getInt(SharedPrefs.sleepHour,
        defaultValue: _sleepDefault);
    setState(() {});
  }

  void _updateLabels(int init, int end, int laps) {
    print("$init, $end, $laps");
    setState(() {
      wakeUpTime = init;
      sleepTime = end;
    });
  }

  Widget _formatBedTime(String pre, int time, IconData ic ,Color color) {
    return Column(
      children: [
        FaIcon(
          ic,
          color: color,
        ),
        Text(pre, style: TextStyle(color: baseColor)),
        Text(
          '${_formatTime(time)}',
          style: TextStyle(color: color, fontSize: 24),
        )
      ],
    );
  }

  String _formatTime(int time) {
    return '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay(hour: time, minute: 0))}';
  }

  String _formatIntervalTime(int init, int end) {
    final hours = end > init ? end - init : 24 - init + end;
    return '${hours}hr${hours > 1 ? 's' : ''}';
  }

  @override
  void initState() {
    _getTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Select time'),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Welcome! Tell us a little about your time.",
                  style: theme.textTheme.headlineSmall!.copyWith(height: 1.2),
                  textAlign: TextAlign.center,
                ),
                DoubleCircularSlider(
                  24,
                  wakeUpTime,
                  sleepTime,
                  height: _size,
                  width: _size,
                  primarySectors: 4,
                  secondarySectors: 120,
                  textColor: theme.colorScheme.secondary,
                  baseColor: baseColor.withOpacity(.5),
                  selectionColor: baseColor,
                  handlerOutterRadius: 12.0,
                  onSelectionChange: _updateLabels,
                  sliderStrokeWidth: 10.0,
                  onSelectionEnd: (int a, int b, int c) {  },
                  child: Padding(
                    padding: const EdgeInsets.all(42.0),
                    child: Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Hours awake',
                            style: Theme.of(context).textTheme.bodySmall),
                        Text('${_formatIntervalTime(wakeUpTime, sleepTime)}',
                            style: Theme.of(context).textTheme.headlineMedium),
                      ],
                    )),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _formatBedTime(
                          'WAKE UP AT', wakeUpTime, FontAwesomeIcons.solidSun,theme.primaryColorDark),
                      _formatBedTime(
                          'SLEEP AT', sleepTime, FontAwesomeIcons.cloudMoon,theme.primaryColorDark),
                    ]),
                ElevatedButton.icon(
                  icon: Text('  N E X T'),
                  onPressed: _savePrefs,
                  label: Icon(Icons.navigate_next),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _savePrefs() async {
    await _setTime(wakeUpTime, sleepTime);
    if (_formKey.currentState?.validate()??false) {
      await Utils.deleteAlarms();
      await Utils.createAlarms();

      if (widget.firstTime && !(await Utils.batterySaverDisabled())) {
        dialog(
            context,
            AlertDialog(
              title: Text("Just one more thing"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "Please remove battery optimisation restrictions or the android system may sometimes prevent the hourly notification."),
                  _action(
                      icon: Icons.battery_charging_full_sharp,
                      label: "Remove battery saver restrictions",
                      onTap: Utils.openAppSettingsScreen),
                ],
              ),
              actions: [
                OutlinedButton.icon(
                    onPressed: () {
                      pushTo(context, HomeScreen(), clear: true);
                    },
                    label: Icon(Icons.navigate_next),
                    icon: Text("Maybe later")),
              ],
            ));
      } else {
        pushTo(context, HomeScreen(), clear: true);
      }
    }
  }

  Future<void> _setTime(int start, int end) async {
    consoleLog("Set time called $start - $end");
    await SharedPrefs.setInt(SharedPrefs.wakeUpHour, start);
    await SharedPrefs.setInt(SharedPrefs.sleepHour, end);
  }

  get style => TextStyle(
        color: Theme.of(context).primaryColorDark,
        fontSize: 16,
      );

  Widget _action({required IconData icon,required  VoidCallback onTap,required  String label}) => ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColorDark,
        ),
        visualDensity: VisualDensity.compact,
        horizontalTitleGap: 0,
        onTap: onTap,
        trailing: Icon(
          Icons.navigate_next,
        ),
        title: Text(
          '$label',
          style: style,
        ),
      );
}
