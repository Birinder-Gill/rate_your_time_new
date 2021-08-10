import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/app_model.dart';
import 'package:rate_your_time_new/providers/month_model.dart';
import 'package:rate_your_time_new/providers/week_model.dart';
import 'package:rate_your_time_new/splash_screen.dart';
import 'package:rate_your_time_new/utils/test_screen.dart';
import 'package:rate_your_time_new/widgets/date_pickers/week_range_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final hoursModel=HoursModel();

  final _appModel=AppModel();
  final monthModel = MonthModel();
  final weekModel = WeekModel();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HoursModel>.value(value: hoursModel),
        ChangeNotifierProvider<WeekModel>(create: (BuildContext context)=>weekModel,),
        ChangeNotifierProvider<MonthModel>(create: (BuildContext context)=>monthModel,),
      ],
      child: ChangeNotifierProvider<AppModel>(

        create: (BuildContext context) =>_appModel,
        child: Consumer<AppModel>(
          builder: (_,model,__)=>MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:model.selectedTheme,
            home:false?
            WeekRangePicker(model: hoursModel,firstDate: DateTime(1900),):SplashScreen(),
          ),
        ),
      ),
    );
  }
}
