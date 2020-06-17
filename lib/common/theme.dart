import 'package:flutter/material.dart';

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFFE1E1E1),
    100: Color(0xFFB5B5B5),
    200: Color(0xFF848484),
    300: Color(0xFF525252),
    400: Color(0xFF2D2D2D),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF070707),
    700: Color(0xFF060606),
    800: Color(0xFF040404),
    900: Color(0xFF020202),
  },
);
const int _blackPrimaryValue = 0xFF080808;

final appTheme = ThemeData(
  primarySwatch: primaryBlack,
);
