import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/themes/dark_theme.dart';
import 'package:rate_your_time_new/themes/shrine_theme.dart';
import 'package:rate_your_time_new/themes/theme_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_your_time_new/themes/theme_model.dart';
import 'package:rate_your_time_new/utils/api_helper.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';

const defaultLetterSpacing = 0.03;
const mediumLetterSpacing = 0.04;
const largeLetterSpacing = 1.0;

class ThemeModel with ChangeNotifier {
  ThemeData selectedTheme;

  int selectedSIndex = 0;

  ThemeModel() {
    setTheme(0);
  }

  List<MyTheme> themes = [
    MyTheme(
        scaffoldBackground: Color(0xffe5e5e5),
        cardsOnScaffold: Color(0xffffffff),
        backdropColor: Color(0xff14213d),
        onPrimaryDark: Color(0xfffca311),
        accentColor: Colors.red.shade600,
        textOnLight: Color(0xff14213d),
        textOnDark: Color(0xffffffff),
        isDark: false),
    MyTheme(
      scaffoldBackground: Color(0xffd7e4eb),
      cardsOnScaffold: Color(0xffffffff),
      backdropColor: Color(0xff242424),
      onPrimaryDark: Color(0xfffa5d00),
      accentColor: Color(0xfffa5d00),
      textOnLight: Color(0xff242424),
      textOnDark: Color(0xffffffff),
      isDark: false,
    ),
    MyTheme(
        scaffoldBackground: Color(0xff1d3557),
        cardsOnScaffold: Color(0xff457b9d),
        backdropColor: Color(0xff242424),
        onPrimaryDark: Color(0xffe63946),
        accentColor: Color(0xfff1faee),
        textOnLight: Color(0xffa8dadc),
        textOnDark: Color(0xfffca311),
        isDark: true),
  ];


  setTheme(int index) {
    this.selectedSIndex = index;
    this.selectedTheme = _buildFromMyTheme(themes[index]);
    SharedPrefs.setInt(SharedPrefs.themeIndex, index);
    nextTick(() {
      notifyListeners();
    });
  }

  IconThemeData _customIconTheme(IconThemeData original, MyTheme theme) {
    return original.copyWith(color: theme.backdropColor);
  }

  ThemeData _buildFromMyTheme(MyTheme theme) {
    final base = theme.isDark ? ThemeData.dark() : ThemeData.light();
    return base.copyWith(
      colorScheme: theme.colorScheme,
      accentColor: theme.accentColor,
      primaryColor: theme.cardsOnScaffold,
      primaryColorDark: theme.backdropColor,
      primaryColorLight: theme.scaffoldBackground,
      buttonColor: theme.backdropColor,
      switchTheme: SwitchThemeData(
        thumbColor:
            MaterialStateProperty.resolveWith((states) => theme.backdropColor),
        trackColor: MaterialStateProperty.resolveWith(
            (states) => theme.backdropColor.withOpacity(.4)),

      ),
      unselectedWidgetColor: theme.backdropColor,
      snackBarTheme: SnackBarThemeData(
          backgroundColor: theme.backdropColor,
          contentTextStyle: TextStyle(
            color: !theme.isDark ? theme.textOnDark : theme.textOnLight,
          )),
      appBarTheme: base.appBarTheme.copyWith(
          elevation: 0,
          iconTheme: IconThemeData(color: theme.onPrimaryDark),
          backgroundColor: theme.backdropColor,
          textTheme: _buildTextTheme(base.textTheme, theme,!theme.isDark),
          titleTextStyle: TextStyle(color: theme.cardsOnScaffold),
          brightness: theme.isDark ? Brightness.light : Brightness.dark),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => theme.cardsOnScaffold),
              foregroundColor: MaterialStateProperty.resolveWith(
                  (states) => theme.accentColor))),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                  (states) => theme.backdropColor))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.resolveWith((states) =>
                  RoundedRectangleBorder(
                      side: BorderSide(color: theme.backdropColor))),
              foregroundColor: MaterialStateProperty.resolveWith(
                  (states) => theme.backdropColor))),
      scaffoldBackgroundColor: theme.scaffoldBackground,
      cardColor: theme.cardsOnScaffold,
      dialogBackgroundColor: theme.cardsOnScaffold,
      errorColor: theme.accentColor,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.normal,
      ),
      primaryIconTheme: _customIconTheme(base.iconTheme, theme),
      textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: theme.backdropColor,
          cursorColor: theme.backdropColor,
          selectionColor: theme.backdropColor.withOpacity(.2)),
      applyElevationOverlayColor: true,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: theme.backdropColor),
        enabledBorder: _cutCornerBorder(theme),
        border: _cutCornerBorder(theme),
        focusedBorder: _cutCornerBorder(theme, width: 1),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      ),
      textTheme: _buildTextTheme(base.textTheme, theme,theme.isDark),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme, theme,theme.isDark),
      accentTextTheme: _buildTextTheme(base.accentTextTheme, theme,theme.isDark),
      iconTheme: _customIconTheme(base.iconTheme, theme),
    );
  }

  TextTheme _buildTextTheme(TextTheme base, MyTheme theme,bool isDark) {
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
          displayColor: isDark ? theme.textOnDark : theme.textOnLight,
          bodyColor: isDark ? theme.textOnDark : theme.textOnLight,
        ));
  }

  _cutCornerBorder(MyTheme theme, {Color color, double width}) =>
      CutCornersBorder(
        borderSide: BorderSide(
            color: color ?? theme.backdropColor, width: width ?? 0.5),
      );
}

/*import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/themes/dark_theme.dart';
import 'package:rate_your_time_new/themes/shrine_theme.dart';
import 'package:rate_your_time_new/themes/theme_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_your_time_new/themes/theme_model.dart';
import 'package:rate_your_time_new/utils/api_helper.dart';
import 'package:rate_your_time_new/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:rate_your_time_new/utils/shared_prefs.dart';

const defaultLetterSpacing = 0.03;
const mediumLetterSpacing = 0.04;
const largeLetterSpacing = 1.0;

class ThemeModel with ChangeNotifier {
  ThemeData selectedTheme;


  ThemeModel() {
    selectedTheme = _defaultTheme;
  }

  List<MyTheme> themes = [
    MyTheme(
        primaryColor: shrinePink100,
        primaryLightColor: shrineSurfaceWhite,
        primaryDarkColor: shrinePink400,
        secondaryColor: shrineBrown900,
        secondaryLightColor: shrineBrown600,
        secondaryDarkColor: shrineErrorRed,
        secondaryTextColor: Colors.white,
        primaryTextColor: shrineBrown900,
        isDark: false),
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
                  (states) => theme.secondaryColor),
          foregroundColor:MaterialStateProperty.resolveWith(
                  (states) => theme.secondaryTextColor) )),
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
        dialTextColor: theme.primaryTextColor,),
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
*/
