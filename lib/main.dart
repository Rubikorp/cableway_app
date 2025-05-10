import 'package:cable_road_project/cable_road_app.dart';
import 'package:cable_road_project/repositories/abstract_pole_repositories.dart';
import 'package:cable_road_project/repositories/pole_repositories.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
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

  final supabase = Supabase.instance.client;

  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: TalkerBlocLoggerSettings(
      printStateFullData: false,
      printEventFullData: false,
    ),
  );

  GetIt.I.registerLazySingleton<AbstractPoleRepositories>(
    () => PoleRepository(supabase: supabase),
  );

  runApp(const CableRoadApp());
}
