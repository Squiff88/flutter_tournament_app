import 'package:flutter/material.dart';
import 'package:tournament_app/helpers/hex_colors.dart';

final ThemeData AppTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: AppColors.fire,
  primaryColor: AppColors.fire,
  primaryColorBrightness: Brightness.light,
  // accentColor: CompanyColors.green[500],
  accentColorBrightness: Brightness.light
);
  
class AppColors {
  AppColors._(); // this basically makes it so you can instantiate this class
  static const Color sand = Color(0xFFfad596);
  static const Color fire = Color(0xFFeb7b6a);
  // static const Color secondaryFire = fire.withGreen(140);
}

class AppBarColor {
  AppBarColor._();
  static LinearGradient linear = LinearGradient(colors: [
          hexToColor('#b63e2b'),
          hexToColor('#e8ac7e'),
          hexToColor('#f0d9af'),
          hexToColor('#e8ac7e'),
          hexToColor('#b63e2b'),
          
    ]);
}

class FontFamilies {
  FontFamilies._();
  static const regular = 'Slabo';
  static const curvy = 'KaushanScript-Regular';
  static const slightlyCurvy = 'Times New Roman';
}