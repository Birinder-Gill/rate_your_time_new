import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/home_screen.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/widgets/circular_range_picker/double_circular_slider.dart';
import 'package:rate_your_time_new/widgets/date_pickers/month_range_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TestScreen extends StatefulWidget {
  final List<UsageStat> distinctApps;

  TestScreen(this.distinctApps);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  double slideVal = 1;

  RangeValues rangeVal = RangeValues(7, 20);

  final DateRangePickerController _controller = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    // return Scaffold(backgroundColor: Colors.black, body: SleepPage());
    // return SearchPage();
    // return Scaffold(
    //   body: Column(
    //     children: <Widget>[
    //       Card(
    //         margin: const EdgeInsets.fromLTRB(50, 100, 50, 100),
    //         child: SfDateRangePicker(
    //           // controller: _controller,
    //           view: DateRangePickerView.year,
    //           // selectionMode: DateRangePickerSelectionMode.range,
    //           // onSelectionChanged: selectionChanged,
    //           monthViewSettings: DateRangePickerMonthViewSettings(enableSwipeSelection: false),
    //         ),
    //       )
    //     ],
    //   ),
    // );
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: Color(0xffefefef),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Next'),
        icon: Icon(Icons.arrow_forward),
      ),
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Welcome! Tell us a little about your time.",
              style:
                  Theme.of(context).textTheme.headline3.copyWith(height: 1.2),
            ),
            SizedBox(
              height: 52,
            ),
            // SliderTheme(data: _themeData(), child: _slider()),
            _slider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NeumorphicRangeSlider(
                min: 0,
                max: 24,
                valueLow: 5,
                valueHigh: 16,
                sliderHeight: 16,
                // thumb: Icon(Icons.remove_circle_outlined),
                style: RangeSliderStyle(
                  lightSource: LightSource.bottomLeft,
                  accent: Colors.blueGrey,
                  variant: Colors.grey,
                  // thumbBorder: NeumorphicBorder(),
                  disableDepth: false,
                  depth: -2,

                  // border: NeumorphicBorder()
                ),
              ),
            ),
            NeumorphicButton(
              child: Text("TRY"),
              minDistance: 1,
              style: NeumorphicStyle(
                  color: Color(0xffefefef),
                  shadowDarkColor: Colors.black,
                  shadowLightColor: Colors.white,
                  shape: NeumorphicShape.convex,
                  shadowDarkColorEmboss: Colors.black,
                  //boxShape: NeumorphicBoxShape.rect(),
                  shadowLightColorEmboss: Colors.white,
                  depth: slideVal),
              onPressed: () {
                pushTo(context, HomeScreen());
              },
            ),
            Transform.rotate(
              angle: pi + pi/2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Neumorphic(
                  style: NeumorphicStyle(
                      color: Theme.of(context).primaryColor,
                      shadowDarkColor: Colors.black,
                      shadowLightColor: Colors.white,
                      shape: NeumorphicShape.convex,
                      shadowDarkColorEmboss: Colors.black,
                      boxShape: NeumorphicBoxShape.rect(),
                      shadowLightColorEmboss: Colors.white,
                      depth: slideVal),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16),
                        child: Text("2:00 am"),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: true
                            ? NeumorphicProgress(
                                percent: .7,
                                height: 16,

                                style: ProgressStyle(
                                  depth: slideVal,
                                  accent: Theme.of(context).accentColor,
                                  variant: Theme.of(context).accentColor,
                                ),
                              )
                            : LinearProgressIndicator(
                                value: .45,
                              ),
                      ))
                    ],
                  ),
                ),
              ),
            )

            // _rangeSlider(),
            // SliderTheme(data: _themeData(), child: _rangeSlider()),
          ],
        ),
      ),
    );
  }

  _rangeSlider() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Neumorphic(
          curve: Curves.easeInOutQuint,
          style: NeumorphicStyle(
              shadowDarkColor: Colors.grey,
              depth: 2,
              lightSource: LightSource.bottomLeft,
              shape: NeumorphicShape.concave,
              intensity: 1,
              surfaceIntensity: 12,
              shadowLightColor: Colors.black,
              shadowLightColorEmboss: Colors.red,
              shadowDarkColorEmboss: Colors.green),
          child: RangeSlider(
              min: 00,
              max: 24,
              divisions: 24,
              values: rangeVal,
              onChanged: (e) {
                rangeVal = e;
                setState(() {});
              }),
        ),
      );

  _slider() => Slider(
      min: -24,
      max: 24,
      divisions: 48,
      value: slideVal,
      onChanged: (e) {
        setState(() {
          slideVal = e;
        });
      });

  _themeData() => SliderThemeData(
        trackHeight: 36,
        activeTrackColor: Colors.green,
        thumbColor: Colors.blue,
        overlayColor: Colors.orange.withOpacity(0.2),
        inactiveTrackColor: Colors.grey,
        activeTickMarkColor: Colors.red,
        trackShape: RectangularSliderTrackShape(),
        rangeThumbShape: RoundRangeSliderThumbShape(
            pressedElevation: 12, enabledThumbRadius: 12),
        minThumbSeparation: 120,
      );
}

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  final baseColor = Color.fromRGBO(255, 255, 255, 0.3);

  int initTime=7;
  int endTime=22;

  int inBedTime;
  int outBedTime;

  double get _size => 350.0;

  @override
  void initState() {
    super.initState();
    _shuffle();
  }

  void _shuffle() {
    setState(() {
      inBedTime = initTime;
      outBedTime = endTime;
    });
  }

  void _updateLabels(int init, int end, int laps) {
    print("$init, $end, $laps");
    setState(() {
      inBedTime = init;
      outBedTime = end;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Welcome! Tell us a little about your time.',
          style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
        ),
        DoubleCircularSlider(
          24,
          initTime,
          endTime,
          height: _size,
          width: _size,
          primarySectors: 4,
          secondarySectors: 60,
          baseColor: Color.fromRGBO(255, 255, 255, 0.1),
          selectionColor: baseColor,

          handlerColor: Colors.white,

          handlerOutterRadius: 12.0,
          onSelectionChange: _updateLabels,
          sliderStrokeWidth: 12.0,
          child: Padding(
            padding: const EdgeInsets.all(42.0),
            child: Center(
                child: Text('${_formatIntervalTime(inBedTime, outBedTime)}',
                    style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white))),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _formatBedTime('WAKE UP AT', inBedTime,FontAwesomeIcons.solidSun),
          _formatBedTime('SLEEP AT', outBedTime,FontAwesomeIcons.cloudMoon),
        ]),
        TextButton.icon(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith((states) => baseColor),
              foregroundColor:
                  MaterialStateProperty.resolveWith((states) => Colors.white),
              shape: MaterialStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              )),
          icon: Text('  N E X T'),
          onPressed: _shuffle,
          label: Icon(Icons.navigate_next),
        ),
      ],
    );
  }

  Widget _formatBedTime(String pre, int time, IconData ic) {
    return Column(
      children: [
        FaIcon(ic,color: Colors.white,),
        Text(pre, style: TextStyle(color: baseColor)),
        Text(
          '${_formatTime(time)}',
          style: TextStyle(color: Colors.white,fontSize: 24),
        )
      ],
    );
  }

  String _formatTime(int time) {
    return '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay(hour: time, minute: 0))}';
  }

  String _formatIntervalTime(int init, int end) {
    final hours = end > init ? end - init : 24 - init + end;
    return '${hours}hr${hours>1?'s':''}';
  }
}
