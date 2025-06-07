import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
          backgroundColor: const Color(0xFFFFF6AA),
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
                accountName: Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                accountEmail: const Text(
                  "ПКД 1",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 5),
              _buildTile(
                icon: Icons.call,
                label: "Звонки",
                onTap: () => Navigator.of(context).pushNamed('/calls'),
              ),
              _buildTile(
                icon: Icons.settings,
                label: "Debug",
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                TalkerScreen(talker: GetIt.I<Talker>()),
                      ),
                    ),
              ),
              const Divider(height: 20, thickness: 1),
              ListTile(
                title: const Row(children: [Text('Developer')]),
                subtitle: GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(
                      'https://rubikorp.github.io/resume-suite/',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Не удалось открыть сайт"),
                        ),
                      );
                    }
                  },
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.green,
                          Colors.blue,
                          Colors.orange,
                          Colors.yellow,
                          Colors.white,
                        ],
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      );
                    },
                    child: const Text(
                      'Rubikorp',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}
