import 'package:firestore_repository/src/fire_repo.dart';
import 'package:firestore_repository/src/repo_config.dart';
import 'package:firestore_repository/src/repo_id.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firestore_repository/firestore_repository.dart';

/// Define Entity
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

class Todo {
  final String id;
  final String userId;
  final String name;

  Todo(this.id, this.userId, this.name);

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(json["id"], json["userId"], json["name"]);
  }

  Map<String, dynamic> get toJson => {
        "id": id,
        "userId": userId,
        "name": name,
      };
}

/// Repo Config
class UserCollectionPathFactory extends CollectionPathFactory1 {
  UserCollectionPathFactory() : super("users");
}

class UserRepoId extends FireRepoId {
  final String userId;
  UserRepoId(this.userId) : super(UserCollectionPathFactory().create(), userId);

  factory UserRepoId.fromEntity(User user) {
    return UserRepoId(user.id);
  }
}

final userRepoConfig = RepoConfig<UserRepoId, User>(
  fromJson: User.fromJson,
  toJson: (user) => user.toJson,
  getId: UserRepoId.fromEntity,
);

// Define Repository
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

// Todo Repo Config
class TodoCollectionPathFactory extends CollectionPathFactory2 {
  TodoCollectionPathFactory() : super("users", "todos");
}

class TodoRepoId extends FireRepoId {
  final String userId;
  final String todoId;
  TodoRepoId(this.userId, this.todoId)
      : super(
          TodoCollectionPathFactory().create(userId),
          todoId,
        );

  factory TodoRepoId.fromEntity(Todo todo) {
    return TodoRepoId(todo.userId, todo.id);
  }
}

final todoRepoConfig = RepoConfig<TodoRepoId, Todo>(
  fromJson: Todo.fromJson,
  toJson: (user) => user.toJson,
  getId: TodoRepoId.fromEntity,
);

void main() {
  test('adds one to input values', () {
    final repo = UserGetRepo();
    repo.get(UserRepoId("user_id"));
  });
}
