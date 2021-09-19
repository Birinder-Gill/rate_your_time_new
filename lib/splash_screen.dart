import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_your_time_new/home_screen.dart';
import 'package:rate_your_time_new/models/hours_model.dart';
import 'package:rate_your_time_new/providers/app_model.dart';
import 'package:rate_your_time_new/select_time_screen.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';
import 'package:rate_your_time_new/welcome_info_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkCurrentState();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: FlutterLogo(size:300,style: FlutterLogoStyle.stacked,)),
    );
  }

  Future<void> _checkCurrentState() async {
    await checkTheme();
    await _loadAppModelVariables();
    if(await SharedPrefs.getBool(SharedPrefs.tutorialSeen)){
      int wakeUpTime = await SharedPrefs.getInt(SharedPrefs.wakeUpHour);
      int sleepTime = await SharedPrefs.getInt(SharedPrefs.sleepHour);
      consoleLog("$wakeUpTime - $sleepTime");
      if(wakeUpTime!=0 && sleepTime!=0){
        pushTo(context, HomeScreen(),clear:true);
        return;
      }
      pushTo(context, SelectTimeScreen(),clear: true);
      return;
    }
    pushTo(context, WelcomeInfoScreen(),clear: true);

  }

  checkTheme() async {
    final model=Provider.of<ThemeModel>(context,listen: false);
    var index = await SharedPrefs.getInt(SharedPrefs.themeIndex);
    model.setTheme(index);
  }

  Future _loadAppModelVariables() async{
    final model = Provider.of<AppModel>(context,listen: false);
    await model.checkIfHoursTableEmpty();
    await model.registerMethodChannel();
  }
}
