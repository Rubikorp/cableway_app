import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CallsListScreen extends StatelessWidget {
  final List<Contact> contacts = [
    Contact(name: "Старший мастер", phone: "89174006196"),
    Contact(name: "Машинист", phone: "83473299175"),
    Contact(name: "Евгений Механик", phone: "89173866584"),
    Contact(name: "Тимур начальник", phone: "89174301674"),
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
      appBar: AppBar(
        title: const Text('Звонки'),
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          itemCount: contacts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Card(
              color: Colors.yellow.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                title: Text(
                  contact.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  contact.phone,
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.call),
                  color: Colors.black87,
                  onPressed: () => _makePhoneCall(contact.phone),
                ),
                onTap: () => _makePhoneCall(contact.phone),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Contact {
  final String name;
  final String phone;

  const Contact({required this.name, required this.phone});

  /// Создание контакта из JSON
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'] as String,
      phone: json['phone'] as String,
    );
  }

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone};
  }

  @override
  String toString() => 'Contact(name: $name, phone: $phone)';
}
