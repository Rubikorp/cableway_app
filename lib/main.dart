import 'dart:async';

import 'package:cable_road_project/cable_road_app.dart';
import 'package:cable_road_project/features/auth/bloc/auth_bloc.dart';
import 'package:cable_road_project/features/poles_list/bloc/poles_bloc.dart';
import 'package:cable_road_project/repositories/auth_repo.dart/auth_repo.dart';
import 'package:cable_road_project/repositories/auth_repo.dart/models/models.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/models/models.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/pole_list_repo.dart';
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

  FlutterError.onError = (FlutterErrorDetails details) {
    GetIt.I<Talker>().handle(details.exception, details.stack);
  };

  runZonedGuarded(
    () async {
      await runMainApp();
    },
    (error, stackTrace) {
      GetIt.I<Talker>().handle(error, stackTrace);
    },
  );
}

Future<void> runMainApp() async {
  const polesBoxKey = 'poles_box';
  const usersBoxKey = 'users_box';

  await Hive.initFlutter();
  Hive.registerAdapter(PoleAdapter());
  Hive.registerAdapter(UserInfoAdapter());
  Hive.registerAdapter(RepairAdapter());
  final polesBox = await Hive.openBox<Pole>(polesBoxKey);
  final authBox = await Hive.openBox<UserInfo>(usersBoxKey);

  final talker = TalkerFlutter.init();
  GetIt.I.registerSingleton(talker);
  GetIt.I<Talker>().debug('Talker started...');

  await dotenv.load(fileName: ".env");

  final anonKey = dotenv.env['PUBLIC_SUPABASE_ANON_KEY'];
  if (anonKey == null) {
    GetIt.I<Talker>().critical('Supabase anonKey is null!');
    return;
  }

  await Supabase.initialize(
    url: 'https://hpzzviwlnkweomaosyle.supabase.co',
    anonKey: anonKey,
  );

  final supabase = Supabase.instance.client;

  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: TalkerBlocLoggerSettings(
      printStateFullData: true,
      printEventFullData: true,
    ),
  );

  GetIt.I.registerLazySingleton<AbstractPoleRepositories>(
    () => PoleRepository(supabase: supabase, polesBox: polesBox),
  );
  GetIt.I.registerLazySingleton<AbstractAuthRepositories>(
    () => AuthRepositories(supabase: supabase),
  );

  GetIt.I.registerSingleton<Box<UserInfo>>(authBox);
  GetIt.I.registerSingleton<AuthBloc>(
    AuthBloc(GetIt.I<AbstractAuthRepositories>(), authBox),
  );
  GetIt.I.registerSingleton<PolesBloc>(
    PolesBloc(GetIt.I<AbstractPoleRepositories>()),
  );

  runApp(const CableRoadApp());
}
