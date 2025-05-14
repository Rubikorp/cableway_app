import 'package:cable_road_project/cable_road_app.dart';
import 'package:cable_road_project/repositories/abstract_pole_repositories.dart';
import 'package:cable_road_project/repositories/models/models.dart';
import 'package:cable_road_project/repositories/pole_repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final talker = TalkerFlutter.init();
  GetIt.I.registerSingleton(talker);
  GetIt.I<Talker>().debug('Talker started...');

  const polesBoxKey = 'poles_box';
  const usersBoxKey = 'users_box';

  await Hive.initFlutter();
  Hive.registerAdapter(PoleAdapter());
  Hive.registerAdapter(UserInfoAdapter());
  Hive.registerAdapter(RepairAdapter());

  final usersBox = await Hive.openBox<UserInfo>(usersBoxKey);
  final polesBox = await Hive.openBox<Pole>(polesBoxKey);

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
    () => PoleRepository(
      supabase: supabase,
      polesBox: polesBox,
      usersBox: usersBox,
    ),
  );

  runApp(const CableRoadApp());
}
