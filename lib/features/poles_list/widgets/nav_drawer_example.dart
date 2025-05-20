import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

const drawerHeader = UserAccountsDrawerHeader(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/poles/27.jpg'),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black45, // степень затемнения
        BlendMode.darken, // режим наложения
      ),
    ),
  ),
  accountName: Text("Руслан"),
  accountEmail: Text('ПКД 1'),
);
final drawerItems = Builder(
  builder: (context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 2 / 3,
      decoration: BoxDecoration(color: Colors.yellow),
      child: ListView(
        children: <Widget>[
          drawerHeader,
          ListTile(
            title: Row(
              children: [Icon(Icons.call), SizedBox(width: 10), Text("Звонки")],
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/calls');
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.settings),
                SizedBox(width: 10),
                Text('Debug'),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TalkerScreen(talker: GetIt.I<Talker>()),
                ),
              );
            },
          ),
        ],
      ),
    );
  },
);
