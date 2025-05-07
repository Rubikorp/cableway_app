import 'package:flutter/material.dart';

class PolesListScreen extends StatefulWidget {
  const PolesListScreen({super.key});

  @override
  State<PolesListScreen> createState() => _PolesListScreenState();
}

class _PolesListScreenState extends State<PolesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Главная')),
      body: Column(
        children: [
          Center(child: Text('Hello World!')),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/repairs');
              },
              child: Text("Перейти"),
            ),
          ),
        ],
      ),
    );
  }
}
