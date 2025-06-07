import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../features/auth/auth.dart';
import '../features/call_list/call_list.dart';
import '../features/poles_list/poles_list.dart';
import '../features/splash/splash.dart';

final routes = {
  "/calls": (context) => CallsListScreen(),
  '/auth':
      (_) => BlocProvider.value(
        value: GetIt.I<AuthBloc>(),
        child: const AuthScreen(),
      ),
  '/poles':
      (_) => BlocProvider.value(
        value: GetIt.I<AuthBloc>(),
        child: const PolesListScreen(),
      ),
  '/':
      (_) => BlocProvider.value(
        value: GetIt.I<AuthBloc>(),
        child: const SplashScreen(),
      ),
};
