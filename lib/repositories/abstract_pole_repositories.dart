import 'package:cable_road_project/repositories/models/models.dart';

abstract class AbstractPoleRepositories {
  Future<List<Pole>> fetchPoles();
  Future<List<UserInfo>> fetchUsers();
  Future<bool> addPole(Pole pole);
  Future<bool> updatePole(String id, {String? number, List<Repair>? repairs});
  Future<void> deletePole(String id);
}
