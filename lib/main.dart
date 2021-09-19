import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/feature_discovery/feature_discovery.dart';
import 'package:rate_your_time_new/providers/app_model.dart';
import 'package:rate_your_time_new/providers/month_model.dart';
import 'package:rate_your_time_new/providers/week_model.dart';
import 'package:rate_your_time_new/splash_screen.dart';
import 'package:rate_your_time_new/utils/test_screen.dart';

import 'models/hours_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final hoursModel=AppModel();

  final _appModel=ThemeModel();
  final monthModel = MonthModel();
  final weekModel = WeekModel();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppModel>.value(value: hoursModel),
        ChangeNotifierProvider<WeekModel>(create: (BuildContext context)=>weekModel,),
        ChangeNotifierProvider<MonthModel>(create: (BuildContext context)=>monthModel,),
      ],
      child: ChangeNotifierProvider<ThemeModel>(

        create: (BuildContext context) =>_appModel,
        child: Consumer<ThemeModel>(
          builder: (_,model,__)=>
            FeatureDiscovery(
              recordStepsInSharedPreferences: false,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme:model.selectedTheme,
                home:false?
                TestScreen([]):SplashScreen(),
              ),
            ),
        ),
      ),
    );
  }
}
