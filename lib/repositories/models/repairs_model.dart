import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'repairs_model.g.dart';

@HiveType(typeId: 2)
class Repair extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final bool urgent;
  @HiveField(3)
  final bool completed;
  @HiveField(4)
  final String date;
  @HiveField(5)
  final String? dateComplete;

  const Repair({
    required this.id,
    required this.description,
    required this.urgent,
    required this.completed,
    required this.date,
    this.dateComplete,
  });

  factory Repair.fromJson(Map<String, dynamic> json) {
    return Repair(
      id: json['id'],
      description: json['description'],
      urgent: json['urgent'],
      completed: json['completed'],
      date: json['date'],
      dateComplete: json['dateComplete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'urgent': urgent,
      'completed': completed,
      'date': date,
      'dateComplete': dateComplete,
    };
  }

  @override
  List<Object?> get props => [
    id,
    description,
    urgent,
    completed,
    date,
    dateComplete,
  ];
}
