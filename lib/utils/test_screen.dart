import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rate_your_time_new/home_screen.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  double slideVal = 1;

  RangeValues rangeVal=RangeValues(7, 20);

  @override
  Widget build(BuildContext context) {
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
