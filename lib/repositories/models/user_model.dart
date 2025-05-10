// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  final String id;
  final String name;
  final String password;

  const UserInfo({
    required this.id,
    required this.name,
    required this.password,
  });

  // Для парсинга из JSON
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'],
      password: json['password'],
    );
  }

  // Для преобразования в JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'password': password};
  }

  @override
  List<Object> get props => [id, name, password];
}
