import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  primarySwatch: Colors.lightBlue,
  dividerColor: Colors.blueGrey, // Цвет разделителя между элементами
  scaffoldBackgroundColor: Color.fromARGB(
    255,
    255,
    247,
    199,
  ), // Цвет фона для Scaffold (всего экрана)
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.black, // Цвет иконок в списке
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 255, 217, 0), // Цвет фона AppBar
    elevation: 0,
    titleTextStyle: TextStyle(
      // Стиль текста заголовка в AppBar
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 20.0,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      // Основной стиль текста
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
    ),
    labelSmall: TextStyle(
      // Стиль для подзаголовков (например, цена)
      color: Colors.black26,
      fontWeight: FontWeight.w700,
      fontSize: 14.0,
    ),
    titleLarge: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(15),
      backgroundColor: const Color.fromARGB(255, 250, 171, 1),
      foregroundColor: const Color.fromARGB(255, 20, 20, 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
);
