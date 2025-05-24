import 'package:cable_road_project/repositories/poles_list_repo.dart/models/repairs_model.dart';
import 'package:equatable/equatable.dart';

class PoleAdd extends Equatable {
  final String number;
  final List<Repair> repairs;
  final String? userName;
  final bool? check;
  final String? lastCheckDate;

  const PoleAdd({
    required this.number,
    required this.repairs,
    this.userName,
    this.check,
    this.lastCheckDate,
  });

  factory PoleAdd.fromJson(Map<String, dynamic> json) {
    return PoleAdd(
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
      'number': number,
      'repairs': repairs.map((e) => e.toJson()).toList(),
      'userName': userName,
      'check': check,
      'lastCheckDate': lastCheckDate,
    };
  }

  @override
  List<Object?> get props => [number, repairs, userName, check, lastCheckDate];
}
