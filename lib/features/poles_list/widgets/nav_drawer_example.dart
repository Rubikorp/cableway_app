import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../auth/bloc/auth_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String username = 'Гость';
        if (state is Authenticated) {
          username = state.user.name;
          GetIt.I<Talker>().debug('Пользователь в Drawer: $username');
        }

        return Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/poles/27.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black45,
                      BlendMode.darken,
                    ),
                  ),
                ),
                accountName: Text(username),
                accountEmail: const Text("ПКД 1"),
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.call),
                    SizedBox(width: 10),
                    Text("Звонки"),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/calls');
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                    Text('Debug'),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => TalkerScreen(talker: GetIt.I<Talker>()),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
