import 'package:adb_manager/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final appTheme = ThemeData(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF42CCC5),
      selectionColor: Color(0xFF009a95),
      selectionHandleColor: Color(0xFF42CCC5),
    ),
    colorScheme: ColorScheme(
      primary: const Color(0xFF42CCC5),
      primaryVariant: const Color(0xFF009a95),
      secondary: const Color(0xFF6842DB),
      secondaryVariant: const Color(0xFF2b14a8),
      background: const Color(0xFF081824),
      surface: const Color(0xFF031729),
      error: Colors.red[900]!,
      onBackground: Colors.white,
      onError: Colors.white,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF010E1B),
    scrollbarTheme: ScrollbarThemeData(
      thickness: MaterialStateProperty.all(6),
      thumbColor: MaterialStateProperty.all(const Color(0xFF009a95)),
    ),
    cardTheme: CardTheme(
        elevation: 1,
        color: const Color(0xFF081824),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
        )),
    splashFactory: InkRipple.splashFactory,
    highlightColor: const Color(0xFF42CCC5).withOpacity(0.3),
    splashColor: const Color(0xFF42CCC5).withOpacity(0.1),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          const Color(0xFF42CCC5).withOpacity(0.1),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          const Color(0xFF42CCC5).withOpacity(0.1),
        ),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: const Color(0xFF010E1B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusM),
      ),
    ),
    textTheme: TextTheme(
      headline1: GoogleFonts.montserrat(),
      headline2: GoogleFonts.montserrat(),
      headline3: GoogleFonts.montserrat(),
      headline4: GoogleFonts.montserrat(),
      headline5: GoogleFonts.montserrat(),
      headline6: GoogleFonts.montserrat(),
      //
      bodyText1: GoogleFonts.montserrat(),
      bodyText2: GoogleFonts.montserrat(),
      //
      subtitle1: GoogleFonts.montserrat(),
      subtitle2: GoogleFonts.montserrat(),
      //
      button: GoogleFonts.montserrat(),
      caption: GoogleFonts.montserrat(),
      overline: GoogleFonts.montserrat(),
    ));
