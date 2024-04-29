import 'package:chat_all/config/theme/text_color_schemes.dart';
import 'package:flutter/material.dart';

import 'color_schemes.dart';

class AppTheme {
  static ThemeData light = ThemeData(
      colorScheme: lightColorScheme,
      textTheme: lightTextColorSchemes);

  static ThemeData dark = ThemeData(
      colorScheme: darkColorScheme,
      textTheme: darkTextColorSchemes);
}