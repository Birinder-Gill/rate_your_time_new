import 'package:flutter/services.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class SharedPrefs {

  static const String tutorialSeen='tutorialSeen';
  static const String firstDayOnHome='firstDayOnHome';
  static const String firstTimeOnStats='firstOnStats';
  static const String wakeUpHour = 'wakeUpHour';
  static const String sleepHour = 'sleepHour';

  static MethodChannel Function()  _channel = ()=> MethodChannel(Constants.CHANNEL_NAME);

  static String themeIndex='themeIndex';

  static Future<bool> getBool(String key) async {
    int result = await _channel().invokeMethod(Constants.getInt,{
      'key':'$key'
    });
    return (result == 1);
  }

  static Future<int> getInt(String key) async {
    int result = await _channel().invokeMethod(Constants.getInt,{
      'key':'$key'
    });
    return result;
  }


  static Future<void> setInt(String key,int value) async {
    bool result = await _channel().invokeMethod(Constants.setInt,{
      'key':'$key',
      'value':value
    });
    return result;
  }

  static Future<bool> isFirstDayAtHome() async {
    final now=DateTime.now();
    int today = int.parse(
      "${now.day}${now.month}${now.year}"
    );
    int result = await getInt(firstDayOnHome);
    if(result == 0){
      await setInt(firstDayOnHome, today);
      return true;
    }
    return (result==today);
  }



}