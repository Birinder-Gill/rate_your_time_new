import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rate_your_time_new/app_usage_tracker/stat_model.dart';
import 'package:rate_your_time_new/home_screen.dart';
import 'package:rate_your_time_new/utils/constants.dart';
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

  RangeValues rangeVal=RangeValues(7, 20);

  final DateRangePickerController _controller = DateRangePickerController();
  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    int firstDayOfWeek = DateTime.sunday % 7;
    int endDayOfWeek = (firstDayOfWeek - 1) % 7;
    endDayOfWeek = endDayOfWeek < 0? 7 + endDayOfWeek : endDayOfWeek;
    PickerDateRange ranges = args.value;
    DateTime date1 = ranges.startDate;
    DateTime date2 = (ranges.endDate?? ranges.startDate);
    if(date1.isAfter(date2))
    {
      var date=date1;
      date1=date2;
      date2=date;
    }
    int day1 = date1.weekday % 7;
    int day2 = date2.weekday % 7;

    DateTime dat1 = date1.add(Duration(days: (firstDayOfWeek - day1)));
    DateTime dat2 = date2.add(Duration(days: (endDayOfWeek - day2)));

    if( !DateUtils.isSameDay(dat1, ranges.startDate)|| !DateUtils.isSameDay(dat2,ranges.endDate))
    {
      _controller.selectedRange = PickerDateRange(dat1, dat2);
    }
  }
  @override
  Widget build(BuildContext context) {
    // return SearchPage();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.fromLTRB(50, 100, 50, 100),
            child: SfDateRangePicker(
              // controller: _controller,
              view: DateRangePickerView.year,
              // selectionMode: DateRangePickerSelectionMode.range,
              // onSelectionChanged: selectionChanged,
              monthViewSettings: DateRangePickerMonthViewSettings(enableSwipeSelection: false),
            ),
          )
        ],
      ),
    );
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: Color(0xffefefef),
      floatingActionButton:  FloatingActionButton.extended(
        onPressed: (){},
        label: Text('Next'),
        icon: Icon(Icons.arrow_forward),
      ),
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Welcome! Tell us a little about your time.",
              style: Theme.of(context).textTheme.headline3.copyWith(height: 1.2),
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
            NeumorphicButton(child: Text("TRY"),
              minDistance: 1,style: NeumorphicStyle(
              color:Color(0xffefefef),
              shadowDarkColor: Colors.black,
              shadowLightColor: Colors.white,
              shape: NeumorphicShape.convex,
              shadowDarkColorEmboss: Colors.black,
              //boxShape: NeumorphicBoxShape.rect(),
              shadowLightColorEmboss: Colors.white,
              depth: slideVal
            ),
            onPressed: (){
              pushTo(context, HomeScreen());
            },),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Neumorphic(
                style: NeumorphicStyle(
                    color:Theme.of(context).primaryColor,
                    shadowDarkColor: Colors.black,
                    shadowLightColor: Colors.white,
                    shape: NeumorphicShape.convex,
                    shadowDarkColorEmboss: Colors.black,
                    boxShape: NeumorphicBoxShape.rect(),
                    shadowLightColorEmboss: Colors.white,
                    depth: slideVal
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8.0,vertical:16),
                      child: Text("2:00 am"),
                    ),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: true?NeumorphicProgress(
                        percent: .7,
                        style: ProgressStyle(depth: slideVal,accent: Theme.of(context).accentColor,variant: Theme.of(context).accentColor,),
                      ):LinearProgressIndicator(value: .45,),
                    ))
                  ],
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

  _rangeSlider()=>Padding(
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
          shadowLightColorEmboss:Colors.red,
          shadowDarkColorEmboss:Colors.green


      ),
      child: RangeSlider(
          min: 00,
          max: 24,
          divisions: 24,
          values: rangeVal, onChanged: (e){
        rangeVal=e;
        setState(() {

        });
      }),
    ),
  );

  _slider() =>Slider(
      min: -24,
      max: 24,
      divisions: 48,
      value: slideVal,
      onChanged: (e) {
        setState(() {
          slideVal = e;
        });
      });

  _themeData() =>SliderThemeData(
    trackHeight: 36,
    activeTrackColor: Colors.green,
    thumbColor: Colors.blue,
    overlayColor: Colors.orange.withOpacity(0.2),
    inactiveTrackColor: Colors.grey,
    activeTickMarkColor: Colors.red,
    trackShape: RectangularSliderTrackShape(),
    rangeThumbShape: RoundRangeSliderThumbShape(
      pressedElevation: 12,
      enabledThumbRadius: 12
    ),
    minThumbSeparation: 120,

  );
}
