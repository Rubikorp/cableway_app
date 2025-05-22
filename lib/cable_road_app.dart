import 'package:cable_road_project/routes/routes.dart';
import 'package:cable_road_project/theme/theme.dart';
import 'package:flutter/material.dart';

class CableRoadApp extends StatelessWidget {
  const CableRoadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      routes: routes,
      initialRoute: '/',
    );
  }
}
