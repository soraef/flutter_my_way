import 'package:flutter_test/flutter_test.dart';
import 'package:fire_repo/fire_repo.dart';

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

// /// Repo Config
// class UserCollectionFactory extends CollectionPathFactory1 {
//   UserCollectionFactory() : super("users");
// }

class UserCollection extends FireCollection {
  UserCollection()
      : super(
          collectionIds: CollectionIds(["users"]),
          documentIds: DocumentIds([]),
        );
}

class UserRepoId extends FireRepoId<UserCollection> {
  UserRepoId(
    String id,
  ) : super(id: id, collection: UserCollection());

  factory UserRepoId.fromEntity(User user) {
    return UserRepoId(user.id);
  }
}

final userRepoConfig = FireRepoConfig<User, UserRepoId, UserCollection>(
  fromJson: User.fromJson,
  toJson: (user) => user.toJson,
  getId: UserRepoId.fromEntity,
);

// Define Repository
class UserGetRepo
    with
        FireRepoGet<User, UserRepoId, UserCollection>,
        FireRepoQuery<User, UserRepoId, UserCollection> {
  @override
  FireRepoConfig<User, UserRepoId, UserCollection> get config => userRepoConfig;
}

class TodoGetRepo with FireRepoGet<Todo, TodoRepoId, TodoCollection> {
  @override
  FireRepoConfig<Todo, TodoRepoId, TodoCollection> get config => todoRepoConfig;
}

class UserReadRepo extends FireRepoWrite {
  @override
  FireRepoConfig<User, UserRepoId, UserCollection> get config => userRepoConfig;
}

class UserRepo extends FireRepoAll<User, UserRepoId, UserCollection> {
  @override
  FireRepoConfig<User, UserRepoId, UserCollection> get config => userRepoConfig;
}

// users/{userId}/todos/{todoId}
class TodoCollection extends FireCollection {
  TodoCollection({
    required String userId,
  }) : super(
          collectionIds: CollectionIds(["users", "todos"]),
          documentIds: DocumentIds([userId]),
        );
}

class TodoRepoId extends FireRepoId<TodoCollection> {
  TodoRepoId({
    required String id,
    required String userId,
  }) : super(id: id, collection: TodoCollection(userId: userId));

  factory TodoRepoId.fromEntity(Todo todo) {
    return TodoRepoId(userId: todo.userId, id: todo.id);
  }
}

final todoRepoConfig = FireRepoConfig<Todo, TodoRepoId, TodoCollection>(
  fromJson: Todo.fromJson,
  toJson: (user) => user.toJson,
  getId: TodoRepoId.fromEntity,
);

class TodoRepo extends FireRepoAll<Todo, TodoRepoId, TodoCollection> {
  @override
  FireRepoConfig<Todo, TodoRepoId, TodoCollection> get config => todoRepoConfig;

  Future<List<Todo>> cursor(
      TodoCollection collectionPath, TodoRepoId? id) async {
    return queryCursor(
      FireQueryCoursorParams(
        collection: collectionPath,
        where: (q) => q,
        afterId: id,
      ),
    );
  }
}

void main() {
  test('adds one to input values', () {
    final user = User("userId", "soraef");
    final repo = UserRepo();

    repo.save(user);
    repo.get(UserRepoId("userId"));
    repo.list(
      FireListParams(collection: UserCollection(), limit: 10),
    );
    repo.delete(user);

    // query
    repo.query(
      FireQueryParams(
        collection: UserCollection(),
        where: (collection) => collection.where("name", isEqualTo: "soraef"),
      ),
    );

    // query cursor for infinity loading
    // get the entities of limit from the next of afterId.
    repo.queryCursor(
      FireQueryCoursorParams(
        collection: UserCollection(),
        where: (collection) => collection.orderBy("createdAt").limit(10),
      ),
    );
  });
}
