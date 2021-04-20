import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/themes/dark_theme.dart';
import 'package:rate_your_time_new/themes/shrine_theme.dart';
import 'package:rate_your_time_new/themes/theme_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_your_time_new/themes/theme_model.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';

const defaultLetterSpacing = 0.03;
const mediumLetterSpacing = 0.04;
const largeLetterSpacing = 1.0;

class AppModel with ChangeNotifier {
  ThemeData selectedTheme;

  AppModel() {
    selectedTheme = _defaultTheme;
  }

  List<MyTheme> themes = [
    MyTheme(
        primaryColor: Color(0xff26363e),
        primaryLightColor: Color(0xff37474f),
        primaryDarkColor: Color(0xff102027),
        secondaryColor: Color(0xffd84315),
        secondaryLightColor: Color(0xffff7543),
        secondaryDarkColor: Color(0xff9f0000),
        primaryTextColor: Color(0xffFFFFFF),
        secondaryTextColor: Color(0xff000000),
        isDark: true),
    MyTheme(
        primaryColor: shrinePink100,
        primaryLightColor: shrineSurfaceWhite,
        primaryDarkColor: shrinePink400,
        secondaryColor: shrineBrown900,
        secondaryLightColor: shrineBrown600,
        secondaryDarkColor: shrineErrorRed,
        secondaryTextColor: shrineBrown900,
        primaryTextColor: shrineBrown900,
        isDark: false),
    MyTheme(
        primaryColor: Color(0xffffde03),
        primaryLightColor: Color(0xfffff9c4),
        primaryDarkColor: Color(0xff0d47a1),
        secondaryColor: Color(0xfff50057),
        secondaryLightColor: Color(0xffec407a),
        secondaryDarkColor: Color(0xff880e4f),
        primaryTextColor: Color(0xff000000),
        secondaryTextColor: Color(0xff000000),
        isDark: true),
MyTheme(
        primaryColor: Color(0xffb2b3b5),
        primaryLightColor: Color(0xffbdbfbe),
        primaryDarkColor: Color(0xffc1c1c1),
        secondaryColor: Color(0xff060707),
        secondaryLightColor: Color(0xff5c5c5e),
        secondaryDarkColor: Color(0xff000000),
        primaryTextColor: Color(0xff4c4c4e),
        secondaryTextColor: Color(0xff969696),
        isDark: true),


  ];

  ThemeData get _defaultTheme => _buildFromMyTheme(themes[1]);

  setTheme(int index) {
    this.selectedTheme = _buildFromMyTheme(themes[index]);
    SharedPrefs.setInt(SharedPrefs.themeIndex, index);
    notifyListeners();
  }

  IconThemeData _customIconTheme(IconThemeData original, MyTheme theme) {
    return original.copyWith(color: theme.primaryTextColor);
  }

  ThemeData _buildFromMyTheme(MyTheme theme) {
    final base = theme.isDark ? ThemeData.dark() : ThemeData.light();
    return base.copyWith(
      appBarTheme: const AppBarTheme(brightness: Brightness.dark, elevation: 0),
      colorScheme: theme.colorScheme,
      accentColor: theme.secondaryColor,
      primaryColor: theme.primaryColor,
      primaryColorDark: theme.primaryDarkColor,
      primaryColorLight: theme.primaryLightColor,
      buttonColor: theme.primaryDarkColor,

      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => theme.secondaryColor))),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                  (states) => theme.primaryTextColor))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                  (states) => theme.primaryTextColor))),
      scaffoldBackgroundColor: theme.primaryLightColor,
      cardColor: theme.primaryColor,
      dialogBackgroundColor: theme.primaryColor,
      dialogTheme: DialogTheme(),
      errorColor: theme.secondaryDarkColor,
      timePickerTheme: TimePickerThemeData(
        backgroundColor: theme.primaryColor,
        hourMinuteTextColor: theme.secondaryColor,
        hourMinuteColor: theme.primaryDarkColor,
        dayPeriodTextColor: theme.secondaryColor,
        dayPeriodColor: theme.primaryColor,
        dialBackgroundColor: theme.primaryDarkColor,
        dialHandColor: theme.secondaryColor,
        dialTextColor: theme.primaryTextColor,

        ),
      buttonTheme: ButtonThemeData(
        colorScheme: theme.colorScheme,
        textTheme: ButtonTextTheme.normal,
      ),
      highlightColor: theme.secondaryLightColor,
      primaryIconTheme: _customIconTheme(base.iconTheme, theme),
      inputDecorationTheme: InputDecorationTheme(

        border: CutCornersBorder(
          borderSide: BorderSide(color: theme.primaryTextColor, width: 0.5),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      ),
      textTheme: _buildTextTheme(base.textTheme, theme),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: theme.secondaryColor,
      ),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme, theme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme, theme),
      iconTheme: _customIconTheme(base.iconTheme, theme),
    );
  }

  TextTheme _buildTextTheme(TextTheme base, MyTheme theme) {
    return GoogleFonts.kanitTextTheme(base
        .copyWith(
          headline5: base.headline5.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
          ),
          headline6: base.headline6.copyWith(
            fontSize: 18,
            letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
          ),
          caption: base.caption.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
          ),
          bodyText1: base.bodyText1.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
          ),
          bodyText2: base.bodyText2.copyWith(
            letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
          ),
          subtitle1: base.subtitle1.copyWith(
            letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
          ),
          headline4: base.headline4.copyWith(
            letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
          ),
          button: base.button.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
          ),
        )
        .apply(
          displayColor: theme.primaryTextColor,
          bodyColor: theme.primaryTextColor,
        ));
  }
}
