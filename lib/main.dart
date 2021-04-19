import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/home_screen.dart';
import 'package:rate_your_time_new/hours_screen.dart';
import 'package:rate_your_time_new/select_time_screen.dart';
import 'package:rate_your_time_new/models/app_model.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/splash_screen.dart';
import 'package:rate_your_time_new/themes/gallery_theme_data.dart';
import 'package:rate_your_time_new/themes/shrine_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final hoursModel=HoursModel();

  final _appModel=AppModel();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HoursModel>.value(value: hoursModel)
      ],
      child: ChangeNotifierProvider<AppModel>(
        create: (BuildContext context) =>_appModel,
        child: Consumer<AppModel>(
          builder: (_,model,__)=>MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:model.selectedTheme,
            home:SplashScreen(),
          ),
        ),
      ),
    );
  }
}
