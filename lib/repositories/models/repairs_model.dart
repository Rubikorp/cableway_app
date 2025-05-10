import 'package:equatable/equatable.dart';

class Repair extends Equatable {
  final String id;
  final String description;
  final bool urgent;
  final bool completed;
  final String date;
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
