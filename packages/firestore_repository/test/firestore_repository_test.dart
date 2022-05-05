import 'package:firestore_repository/src/fire_repo.dart';
import 'package:firestore_repository/src/repo_config.dart';
import 'package:firestore_repository/src/repo_id.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firestore_repository/firestore_repository.dart';

class User {
  final String id;
  final String name;

  User(this.id, this.name);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["id"], json["name"]);
  }

  Map<String, dynamic> get toJson => {
        "id": id,
        "name": name,
      };
}

class UserRepoId extends RepoId1 {
  UserRepoId(String value) : super(collectionId1: "users", docId1: value);

  factory UserRepoId.fromEntity(User user) {
    return UserRepoId(user.id);
  }
}

final userRepoConfig = RepoConfig<UserRepoId, User>(
  fromJson: User.fromJson,
  toJson: (user) => user.toJson,
  getId: UserRepoId.fromEntity,
  example: UserRepoId("user_id"),
);

class UserGetRepo with FireRepoGet<UserRepoId, User> {
  @override
  RepoConfig<UserRepoId, User> get config => userRepoConfig;
}

class UserReadRepo extends FireRepoWrite {
  @override
  RepoConfig<FireRepoId, dynamic> get config => userRepoConfig;
}

class UserRepo extends FireRepoAll {
  @override
  RepoConfig<FireRepoId, dynamic> get config => userRepoConfig;
}

void main() {
  test('adds one to input values', () {
    final repo = UserGetRepo();
    repo.get(UserRepoId("user_id"));
  });
}
