import 'package:cable_road_project/repositories/auth_repo.dart/models/user_model.dart';

abstract class AbstractAuthRepositories {
  Future<List<UserInfo>> fetchUsers();
}
