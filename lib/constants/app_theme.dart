import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_padding.dart';

ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
    elevation: 0.0,
    toolbarHeight: 20,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  primarySwatch: Colors.deepPurple,
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    contentPadding: EdgeInsets.symmetric(
        vertical: AppPadding.maxValue, horizontal: AppPadding.minValue),
    hoverColor: Colors.deepPurple,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 2.0,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.deepPurple,
        width: 2.0,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 2.0,
      ),
    ),
  ),
  unselectedWidgetColor: Colors.white,
);
