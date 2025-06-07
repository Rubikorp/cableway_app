import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 236, 174),
  primaryColor: const Color(0xFFFFC107),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFFFFC107),
    secondary: Colors.black,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFFC107),
    foregroundColor: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFC107),
    elevation: 1,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
  ),
  primarySwatch: Colors.lightBlue,
  dividerColor: Color(0xFFFFC107), // Цвет разделителя между элементами
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.black, // Цвет иконок в списке
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      // Основной стиль текста
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
    ),
    labelSmall: TextStyle(
      // Стиль для подзаголовков
      color: Colors.black87,
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
    ),
    titleLarge: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    labelMedium: TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.yellow.shade700, // Жёлтая кнопка
      foregroundColor: Colors.black87, // Цвет текста и иконок
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.2), // Мягкая тень
    ),
  ),
);
