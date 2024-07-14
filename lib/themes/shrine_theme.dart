// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rate_your_time_new/utils/constants.dart';

const defaultLetterSpacing = 0.03;
const mediumLetterSpacing = 0.04;
const largeLetterSpacing = 1.0;

final ThemeData shrineTheme = _buildShrineTheme();

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: shrineBrown900);
}
const Color shrinePink50 = Color(0xFFFEEAE6);
const Color shrinePink100 = Color(0xFFFEDBD0);
const Color shrinePink300 = Color(0xFFFBB8AC);
const Color shrinePink400 = Color(0xFFEAA4A4);

const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
const Color shrineBackgroundWhite = Colors.white;
ThemeData _buildShrineTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    appBarTheme: const AppBarTheme(elevation: 0, systemOverlayStyle: SystemUiOverlayStyle.dark),
    primaryColor: shrinePink100,
    scaffoldBackgroundColor: shrineBackgroundWhite,
    cardColor: shrineBackgroundWhite,
    buttonTheme: const ButtonThemeData(
      colorScheme: _shrineColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: _customIconTheme(base.iconTheme),
    inputDecorationTheme: const InputDecorationTheme(
      border: CutCornersBorder(
        borderSide: BorderSide(color: shrineBrown900, width: 0.5),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    ),
    textTheme: _buildShrineTextTheme(base.textTheme),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: shrinePink100,
    ),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    iconTheme: _customIconTheme(base.iconTheme), colorScheme: _shrineColorScheme.copyWith(secondary: shrineBrown900).copyWith(error: shrineErrorRed),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return GoogleFonts.kanitTextTheme(base
      .copyWith(
    headlineSmall: base.headlineSmall?.copyWith(
      fontWeight: FontWeight.w500,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontSize: 18,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    bodySmall: base.bodySmall?.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    titleMedium: base.titleMedium?.copyWith(
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    labelLarge: base.labelLarge?.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
  )
      .apply(
    displayColor: shrineBrown900,
    bodyColor: shrineBrown900,
  ));
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: shrinePink100,
  secondary: shrinePink50,
  surface: shrineSurfaceWhite,
  error: shrineErrorRed,
  onPrimary: shrineBrown900,
  onSecondary: shrineBrown900,
  onSurface: shrineBrown900,
  onError: shrineSurfaceWhite,
  brightness: Brightness.light,
);
