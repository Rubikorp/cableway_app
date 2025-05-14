import 'package:cable_road_project/repositories/models/repairs_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'pole_model.g.dart';

@HiveType(typeId: 1)
class Pole extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String number;
  @HiveField(2)
  final List<Repair> repairs;
  @HiveField(3)
  final String? userName;
  @HiveField(4)
  final bool? check;
  @HiveField(5)
  final String? lastCheckDate;

  const Pole({
    required this.id,
    required this.number,
    required this.repairs,
    this.userName,
    this.check,
    this.lastCheckDate,
  });

  factory Pole.fromJson(Map<String, dynamic> json) {
    return Pole(
      id: json['id'],
      number: json['number'],
      repairs:
          (json['repairs'] as List<dynamic>)
              .map((e) => Repair.fromJson(e as Map<String, dynamic>))
              .toList(),
      userName: json['userName'],
      check: json['check'],
      lastCheckDate: json['lastCheckDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'repairs': repairs.map((e) => e.toJson()).toList(),
      'userName': userName,
      'check': check,
      'lastCheckDate': lastCheckDate,
    };
  }

  @override
  List<Object?> get props => [
    id,
    number,
    repairs,
    userName,
    check,
    lastCheckDate,
  ];
}
