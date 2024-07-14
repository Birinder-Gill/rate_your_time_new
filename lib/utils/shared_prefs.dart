import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rate_your_time_new/utils/constants.dart';

class SharedPrefs {
  static const String tutorialSeen = 'tutorialSeen';
  static const String firstDayOnHome = 'firstDayOnHome';
  static const String firstTimeOnStats = 'firstOnStats';
  static const String wakeUpHour = 'wakeUpHour';
  static const String sleepHour = 'sleepHour';
  static const String installDate = 'installDate';

  static MethodChannel Function() _channel =
      () => MethodChannel(Constants.CHANNEL_NAME);

  static String themeIndex = 'themeIndex';

  static Future<bool> getBool(String key) async {
    int result = await getInt(key);
    return (result == 1);
  }

  ///GETS INTEGER USING KEY FROM SHARED PREFS
  ///DEFAULTS TO 0
  static Future<int> getInt(String key,{int defaultValue = 0}) async {
    consoleLog("IN get int $key");
    String result =
        await _channel().invokeMethod(Constants.getString, {'key': '$key'});
    return int.tryParse(result) ?? defaultValue;
  }
  static Future clear()async {
    return
    await _channel().invokeMethod(Constants.clearPrefs);
  }



  static Future<void> setInt(String key, int value) async {
    consoleLog("IN Set int $key:$value");
     await _channel()
        .invokeMethod(Constants.setString, {'key': '$key', 'value': "$value"});
  }

  // static Future<bool> isFirstDayAtHome() async {
  //   final now=DateTime.now();
  //   int today = int.parse(
  //     "${now.day}${now.month}${now.year}"
  //   );
  //   int result = await getInt(firstDayOnHome);
  //   if(result == 0){
  //     await setInt(firstDayOnHome, today);
  //     return true;
  //   }
  //   return (result==today);
  // }

  static const testFlag = true;

  static Future<DateTime> checkInstallDate() async {
    if (testFlag) {
      //TODO::Maybe this should permanently returns an older date because usually we have app usage data for older days
      return DateTime(2000);
    }
    var installTime = await getInt(
      installDate,
    );
    if (installTime == 0) {
      var now = DateTime.now();
      installTime = now.millisecondsSinceEpoch;
      await setInt(installDate, installTime);
      return DateUtils.dateOnly(now);
    }
    return DateUtils.dateOnly(DateTime.fromMillisecondsSinceEpoch(installTime));
  }


}
