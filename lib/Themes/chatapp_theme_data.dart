import 'package:flutter/material.dart';

class ChatAppThemeData {

  final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF005180),   //In1go Default Shade of Blue
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: MaterialColor(0xFF005180, <int, Color>{  //In1go Default Shade of Blue
        50: const Color(0xFF005180).withOpacity(0.1),
        100: const Color(0xFF005180).withOpacity(0.2),
        200: const Color(0xFF005180).withOpacity(0.3),
        300: const Color(0xFF005180).withOpacity(0.4),
        400: const Color(0xFF005180).withOpacity(0.5),
        500: const Color(0xFF005180),
        600: const Color(0xFF005180).withOpacity(0.6),
        700: const Color(0xFF005180).withOpacity(0.7),
        800: const Color(0xFF005180).withOpacity(0.8),
        900: const Color(0xFF005180).withOpacity(0.9)
      }),
      backgroundColor: Colors.white
      //backgroundColor: const Color(0xFF005180)                      //Change Background Color to "Colors.white" when using Material 3
    ),
    useMaterial3: true,                                               //Change to "false" if you want to use Material 2
    inputDecorationTheme: const InputDecorationTheme(
      border: UnderlineInputBorder(),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey)
      )
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(StadiumBorder())
      )
    )
  );

  final ThemeData oldLightTheme = ThemeData.light();
  final ThemeData darkTheme = ThemeData.dark();
}