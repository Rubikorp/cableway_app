import 'package:cable_road_project/repositories/poles_list_repo.dart/models/models.dart';

abstract class AbstractPoleRepositories {
  Future<List<Pole>> fetchPoles();
  Future<bool> addPole(Pole pole);
  Future<bool> updatePole(String id, {String? number, List<Repair>? repairs});
  Future<void> deletePole(String id);
}
