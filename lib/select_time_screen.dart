import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rate_your_time_new/home_screen.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';
import 'package:rate_your_time_new/widgets/circular_range_picker/double_circular_slider.dart';

class SelectTimeScreen extends StatefulWidget {
  @override
  _SelectTimeScreenState createState() => _SelectTimeScreenState();
}

class _SelectTimeScreenState extends State<SelectTimeScreen>
    with TickerProviderStateMixin {
  final _wC = TextEditingController();
  final _sC = TextEditingController();

  Color get baseColor => Theme.of(context).primaryColorDark;

  int _wakeUpDefault = 7;
  int _sleepDefault = 22;

  int wakeUpTime;
  int sleepTime;

  double get _size => 350.0;
  final _formKey = GlobalKey<FormState>();

  AnimationController _wTimeC;
  AnimationController _sTimeC;

  ThemeData theme;

  final _duration = 300;

  void _getTime() async {
    wakeUpTime = await SharedPrefs.getInt(SharedPrefs.wakeUpHour,defaultValue: _wakeUpDefault);
    sleepTime = await SharedPrefs.getInt(SharedPrefs.sleepHour,defaultValue: _sleepDefault);
    setState(() {

    });
  }

  void _updateLabels(int init, int end, int laps) {
    print("$init, $end, $laps");
    setState(() {
      wakeUpTime = init;
      sleepTime = end;
    });
  }

  Widget _formatBedTime(String pre, int time, IconData ic) {
    return Column(
      children: [
        FaIcon(
          ic,
          color: theme.primaryColorDark,
        ),
        Text(pre, style: TextStyle(color: baseColor)),
        Text(
          '${_formatTime(time)}',
          style: TextStyle(color: theme.primaryColorDark, fontSize: 24),
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
    _wTimeC = AnimationController(
        vsync: this, duration: Duration(milliseconds: _duration));
    _sTimeC = AnimationController(
        vsync: this, duration: Duration(milliseconds: _duration));

    Timer(Duration(seconds: 1), () {
      _wTimeC.forward();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor: theme.scaffoldBackgroundColor,),
      floatingActionButton: _sC.text.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _savePrefs,
              label: Text('Next'),
              icon: Icon(Icons.arrow_forward),
            )
          : null,
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
                  style: theme.textTheme.headline5.copyWith(height: 1.2),
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
                  textColor: theme.accentColor,
                  baseColor: baseColor.withOpacity(.5),
                  selectionColor: baseColor,
                  handlerOutterRadius: 12.0,
                  onSelectionChange: _updateLabels,
                  sliderStrokeWidth: 10.0,
                  child: Padding(
                    padding: const EdgeInsets.all(42.0),
                    child: Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Hours awake',
                            style: Theme.of(context)
                                .textTheme
                                .caption),
                        Text('${_formatIntervalTime(wakeUpTime, sleepTime)}',
                            style: Theme.of(context)
                                .textTheme
                                .headline4),
                      ],
                    )),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _formatBedTime(
                          'WAKE UP AT', wakeUpTime, FontAwesomeIcons.solidSun),
                      _formatBedTime(
                          'SLEEP AT', sleepTime, FontAwesomeIcons.cloudMoon),
                    ]),
                ElevatedButton.icon(
                  icon: Text('  N E X T'),
                  onPressed: _savePrefs,
                  label: Icon(Icons.navigate_next),
                ),
                // SizedBox(
                //   height: 52,
                // ),
                // _wakeTimeWidget(_wTimeC, onTimeSelect: (time) {
                //   _wC.text = time.format(context);
                //   Timer(Duration(seconds: 1), (){_sTimeC.forward();});
                //   SharedPrefs.setInt(SharedPrefs.wakeUpHour, time.hour);
                //
                //
                // },isWakeUpTime: true),
                // SizedBox(
                //   height: 100,
                // ),
                // _wakeTimeWidget(_sTimeC, onTimeSelect: (time) async {
                //   _sC.text = time.format(context);
                //   if((await SharedPrefs.getInt(SharedPrefs.wakeUpHour))>=time.hour)
                //     return;
                //   SharedPrefs.setInt(SharedPrefs.sleepHour, time.hour);
                //   Timer(Duration(seconds: 1), (){
                //     setState(() {});
                //   });
                // },isWakeUpTime: false),
                // SizedBox(
                //   height: 24,
                // ),
                // AnimatedOpacity(
                //     duration: Duration(milliseconds: 200),
                //     opacity: _sC.text.isNotEmpty ? 1 : 0,
                //     child: Text("Great! Lets move forward.")),
                if (false)
                  ButtonBar(
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            _wTimeC.forward();
                          },
                          child: Text("FORWARD")),
                      OutlinedButton(
                          onPressed: () {
                            _wTimeC.animateTo(0, duration: Duration.zero);
                            _sTimeC.reverse();
                          },
                          child: Text("BACK")),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _savePrefs() async {
    await _setTime(wakeUpTime, sleepTime);
    if (_formKey.currentState.validate()) {
      await Utils.deleteAlarms();
      await Utils.createAlarms();
      pushTo(context, HomeScreen(), clear: true);
    }
  }

  Widget _wakeTimeWidget(AnimationController parent,
      {void Function(TimeOfDay dateTime) onTimeSelect, bool isWakeUpTime}) {
    final label = isWakeUpTime
        ? 'What time do you wake up at:'
        : 'What time do you go to sleep at:';
    final hint = isWakeUpTime ? 'Select Wakeup time' : 'Select sleep time';
    return SlideTransition(
        position: Tween<Offset>(
          end: Offset.zero,
          begin: Offset(0, 0.4),
        ).animate(_wTimeC),
        child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(parent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$label",
                  style: theme.textTheme.headline6,
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                    onTap: () async {
                      final helpText = isWakeUpTime
                          ? 'Pick an approx time when you wake up'
                          : 'Pick an approx time when you go to sleep';
                      final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                          initialEntryMode: TimePickerEntryMode.input,
                          confirmText: "OK",
                          helpText: "$helpText");
                      if (time != null) {
                        onTimeSelect(time);
                      }
                    },
                    child: IgnorePointer(
                        ignoring: true,
                        child: TextFormField(
                          validator: (e) => e.isEmpty ? "$hint" : null,
                          decoration: InputDecoration(
                              hintText: "Select a time",
                              prefixIcon: Icon(Icons.access_time)),
                          controller: isWakeUpTime ? _wC : _sC,
                        ))),
              ],
            )));
  }

  Future<void> _setTime(int start, int end) async {
    consoleLog("Set time called $start - $end");
    await SharedPrefs.setInt(SharedPrefs.wakeUpHour, start);
    await SharedPrefs.setInt(SharedPrefs.sleepHour, end);
  }
}
