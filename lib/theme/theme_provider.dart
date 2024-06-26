import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/light_theme.dart';
import 'package:habit_tracker/theme/dark_theme.dart';
class ThemeProvider extends ChangeNotifier{
  //initially light mode
  ThemeData _themeData = lightmode;

  //get current theme
  ThemeData get themeData  => _themeData;

  //is current theme dark mode
  bool get isDarkMode => _themeData == darkmode;

  // set theme 
  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }
  // toggle theme
  void toggleTheme() {
  _themeData = _themeData == lightmode ? darkmode : lightmode;
  notifyListeners();
}

}