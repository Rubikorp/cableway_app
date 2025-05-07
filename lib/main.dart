import 'package:cable_road_project/cable_road_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final talker = TalkerFlutter.init();
  GetIt.I.registerSingleton(talker);
  GetIt.I<Talker>().debug('Talker started...');

  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: 'https://hpzzviwlnkweomaosyle.supabase.co',
    anonKey: dotenv.env['PUBLIC_SUPABASE_ANON_KEY']!,
  );

  runApp(const CableRoadApp());
}
