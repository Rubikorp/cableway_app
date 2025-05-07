import 'package:cable_road_project/repositories/models/repairs.dart';

class Pole {
  final String id;
  final String number;
  final List<Repair> repairs;
  final String? userName;
  final bool? check;
  final String? lastCheckDate;

  Pole({
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
}
