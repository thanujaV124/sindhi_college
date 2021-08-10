import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sindhi_college/theme/shared_preference.dart';
import 'package:velocity_x/velocity_x.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePrefrence darkThemePrefrence = DarkThemePrefrence();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePrefrence.setDarkTheme(value);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    const int _blackPrimaryValue = 0xFF1B62DB;

    const MaterialColor primaryColor = MaterialColor(
      _blackPrimaryValue,
      <int, Color>{
        50: Color(0xFF000000),
        100: Color(0xFF000000),
        200: Color(0xFF000000),
        300: Color(0xFF000000),
        400: Color(0xFF000000),
        500: Color(_blackPrimaryValue),
        600: Color(0xFF000000),
        700: Color(0xFF000000),
        800: Color(0xFF000000),
        900: Color(0xFF000000),
      },
    );
    return ThemeData(
      fontFamily: GoogleFonts.montserrat().fontFamily,
      primarySwatch: primaryColor,
      primaryColor: isDarkTheme ? primaryColor : primaryColor,
      accentColor: isDarkTheme ? Colors.black : Colors.white,
      backgroundColor: isDarkTheme ? Vx.hexToColor('#1c202a') : Colors.white,
      cardColor: isDarkTheme ? Vx.hexToColor('#272c39') : Colors.white,
      shadowColor:
          isDarkTheme ? Colors.black.withAlpha(50) : Colors.black.withAlpha(50),
      canvasColor:
          isDarkTheme ? Vx.hexToColor('#242936') : Vx.hexToColor('#F5F5F5'),
      hintColor: isDarkTheme ? Colors.white38 : Colors.black45,
      disabledColor: Colors.grey,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          foregroundColor: isDarkTheme ? Colors.white : Colors.black),
    );
  }
}
