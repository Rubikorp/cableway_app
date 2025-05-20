import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CallsListScreen extends StatelessWidget {
  final List<Contact> contacts = [
    Contact(name: "Старший мастер", phone: "89174006196"),
    Contact(name: "Машинист", phone: "83473299175"),
    Contact(name: "Механик", phone: "89173866584"),
    Contact(name: "Механик Временный", phone: "89174386221"),
  ];

  CallsListScreen({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(url);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Звонки')),
      body: ListView.separated(
        itemCount: contacts.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            trailing: const Icon(Icons.call),
            onTap: () => _makePhoneCall(contact.phone),
          );
        },
      ),
    );
  }
}

class Contact {
  final String name;
  final String phone;

  Contact({required this.name, required this.phone});
}
