import 'package:flutter/material.dart';
import 'package:test/utils/colors/colors.util.dart';

class ARMThemeData {
  static final lightTheme = ThemeData(
    //  primarySwatch: Colors.blue,
    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.all(true),
    ),
    unselectedWidgetColor: ARMColors.primary,
    // backgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ARMColors.primary,
      primary: ARMColors.primary,
      secondary: ARMColors.primary,
      // background: ARMColors.primary,
      //  surface: ARMColors.primary,
      primaryContainer: ARMColors.primary,
      brightness: Brightness.light,
    ),
    primaryColor: ARMColors.primary,
    fontFamily: 'Poppins',
    cardTheme: CardTheme(
      margin: const EdgeInsets.all(.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    textTheme: const TextTheme(
      labelLarge: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
    ),
    appBarTheme: const AppBarTheme(
      // backgroundColor: Colors.white,
      foregroundColor: Colors.black54,
      elevation: .0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: ARMColors.primary,
      ),
      actionsIconTheme: IconThemeData(
          //  color: Colors.black87,
          color: ARMColors.primary),
      titleTextStyle: TextStyle(
        fontSize: 17.0,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: Colors.black54,
        overflow: TextOverflow.clip,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5.0,
        textStyle: const TextStyle(
            fontSize: 17.0, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        backgroundColor: ARMColors.primary,
        minimumSize: const Size(double.maxFinite, 45.0),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(
            width: .0,
            color: ARMColors.primary,
          ),
        ),
        elevation: 5.0,
        // backgroundColor: backgroundColor,
        minimumSize: const Size(double.maxFinite, 45.0),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      // contentPadding: EdgeInsets.symmetric(vertical: 1.0),
      labelStyle: const TextStyle(
        //  color: ARMColors.primary,
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
      hintStyle: const TextStyle(
        color: Colors.black54,
        fontSize: 15.0,
        fontFamily: 'Poppins',
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          width: 1.0,
          color: // Colors.black54
              ARMColors.primary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: ARMColors.primary,
          width: 2.0,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: ARMColors.secondary, width: .5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: .5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
    ),
  );
}
