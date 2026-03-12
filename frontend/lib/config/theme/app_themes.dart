import 'package:flutter/material.dart';
import 'app_design.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: AppDesign.surface,
    fontFamily: 'Muli',
    appBarTheme: appBarTheme(),
    colorScheme: const ColorScheme.light(
      primary: AppDesign.primary,
      surface: AppDesign.surface,
      error: AppDesign.error,
      onPrimary: AppDesign.surface,
      onSurface: AppDesign.textPrimary,
      onError: AppDesign.surface,
    ),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    backgroundColor: AppDesign.surface,
    elevation: 2,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppDesign.appBarIcon),
    titleTextStyle: TextStyle(color: AppDesign.appBarIcon, fontSize: 18),
  );
}