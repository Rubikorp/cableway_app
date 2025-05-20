import 'package:cable_road_project/features/call_list/call_list.dart';
import '../features/poles_list/poles_list.dart';
import '../features/repair_list/views/repairs_list_screen.dart';

final routes = {
  "/": (context) => PolesListScreen(),
  "/repairs": (context) => RepairListScreen(),
  "/calls": (context) => CallsListScreen(),
};
