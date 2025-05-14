// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'user_model.g.dart';

@HiveType(typeId: 3)
class UserInfo extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
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
