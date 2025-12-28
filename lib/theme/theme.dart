import 'package:flutter/material.dart';

final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    dividerColor: Colors.white24,
    primarySwatch: Colors.grey,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      labelSmall: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Colors.white10,
      height: 120,

    )

);